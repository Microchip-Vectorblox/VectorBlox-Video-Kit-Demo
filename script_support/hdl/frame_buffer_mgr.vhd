--=================================================================================================
-- File Name                           : frame_buffer_mgr.vhd
-- Targeted device                     : Microsemi-SoC
--
-- Pool-based frame buffer manager for 3 independent clock domains.
-- Replaces frame_controller.vhd. See frame_buffer_mgr_design.txt for design rationale.
--
-- Clock domains:
--   mgt_clk  (apb_clk)  -- arbiter, host interface, process outputs
--   vid_clk             -- camera frame_sync input, write address output
--   ddr_clk             -- display read address output
--
-- disp_frame_end_i originates in pixel_clk (async to all three domains).
-- It is synchronized directly into mgt_clk for event detection.
--=================================================================================================

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity frame_buffer_mgr is
  port(
    -- Management clock domain (apb_clk, free-running)
    mgt_clk_i            : in  std_logic;
    mgt_resetn_i         : in  std_logic;

    -- Video input clock domain
    vid_clk_i            : in  std_logic;
    vid_resetn_i         : in  std_logic;
    vid_frame_sync_i     : in  std_logic;

    -- DDR clock domain (for display read output)
    ddr_clk_i            : in  std_logic;
    ddr_resetn_i         : in  std_logic;

    -- Display frame end (from pixel_clk domain, async to all clocks above)
    disp_frame_end_i     : in  std_logic;

    -- Host interface (mgt_clk domain)
    swap_toggle_i        : in  std_logic;
    swap_new_frame_o     : out std_logic;

    -- Configuration (static, sets upper nibble of DDR frame address)
    frame_base_addr_i    : in  std_logic_vector(3 downto 0);

    -- Output: vid_clk domain (CDC'd via toggle handshake)
    vid_write_addr_o     : out std_logic_vector(7 downto 0);

    -- Output: ddr_clk domain (CDC'd via toggle handshake)
    disp_read_addr_o     : out std_logic_vector(7 downto 0);

    -- Output: mgt_clk domain (direct, no CDC)
    process_frame_addr_o : out std_logic_vector(7 downto 0);
    process_next_addr_o  : out std_logic_vector(7 downto 0)
  );
end frame_buffer_mgr;

architecture rtl of frame_buffer_mgr is

  type t_idx_array is array (natural range <>) of std_logic_vector(3 downto 0);

  constant C_FREE_DEPTH : integer := 3;

  -- Initial buffer indices matching DDR frame slot layout (0x7X000000)
  constant C_INIT_WR   : std_logic_vector(3 downto 0) := x"7";
  constant C_INIT_PROC : std_logic_vector(3 downto 0) := x"8";
  constant C_INIT_DISP : std_logic_vector(3 downto 0) := x"9";
  constant C_INIT_FREE : t_idx_array(0 to 2)          := (x"A", x"B", x"C");

  ---------------------------------------------------------------------------
  -- CDC: vid_clk frame_sync --> mgt_clk (event via toggle)
  ---------------------------------------------------------------------------
  signal s_fsync_d1      : std_logic;
  signal s_fsync_d2      : std_logic;
  signal s_fsync_toggle  : std_logic;

  signal s_fsync_m1      : std_logic;
  signal s_fsync_m2      : std_logic;
  signal s_fsync_prev    : std_logic;
  signal s_write_event   : std_logic;

  ---------------------------------------------------------------------------
  -- CDC: pixel_clk disp_frame_end --> mgt_clk (direct sync, no toggle)
  -- 3 FFs in mgt_clk: m1/m2 resolve metastability, d provides edge ref
  ---------------------------------------------------------------------------
  signal s_fend_m1       : std_logic;
  signal s_fend_m2       : std_logic;
  signal s_fend_d        : std_logic;
  signal s_display_event : std_logic;

  ---------------------------------------------------------------------------
  -- Host swap event (mgt_clk domain, no CDC needed)
  ---------------------------------------------------------------------------
  signal s_swap_prev     : std_logic;
  signal s_swap_event    : std_logic;

  ---------------------------------------------------------------------------
  -- Buffer pool state (mgt_clk domain)
  ---------------------------------------------------------------------------
  signal s_wr_buf        : std_logic_vector(3 downto 0);
  signal s_wr_latest     : std_logic_vector(3 downto 0);
  signal s_wr_latest_v   : std_logic;
  signal s_proc_buf      : std_logic_vector(3 downto 0);
  signal s_proc_latest   : std_logic_vector(3 downto 0);
  signal s_proc_latest_v : std_logic;
  signal s_disp_buf      : std_logic_vector(3 downto 0);
  signal s_free_stack    : t_idx_array(0 to C_FREE_DEPTH - 1);
  signal s_free_count    : integer range 0 to C_FREE_DEPTH;
  signal s_new_frame     : std_logic;

  ---------------------------------------------------------------------------
  -- CDC: mgt_clk --> vid_clk (write buffer index)
  ---------------------------------------------------------------------------
  signal s_wr_hold       : std_logic_vector(3 downto 0);
  signal s_wr_cdc_toggle : std_logic;
  signal s_wr_cdc_m1     : std_logic;
  signal s_wr_cdc_m2     : std_logic;
  signal s_wr_cdc_d      : std_logic;
  signal s_vid_wr_idx    : std_logic_vector(3 downto 0);

  ---------------------------------------------------------------------------
  -- CDC: mgt_clk --> ddr_clk (display buffer index)
  ---------------------------------------------------------------------------
  signal s_disp_hold       : std_logic_vector(3 downto 0);
  signal s_disp_cdc_toggle : std_logic;
  signal s_disp_cdc_m1     : std_logic;
  signal s_disp_cdc_m2     : std_logic;
  signal s_disp_cdc_d      : std_logic;
  signal s_ddr_disp_idx    : std_logic_vector(3 downto 0);

begin

  --=========================================================================
  -- vid_clk: frame_sync edge detect --> toggle
  -- vid_frame_sync_i is synchronous to vid_clk (camera parallel clock)
  --=========================================================================
  p_vid_fsync : process(vid_clk_i, vid_resetn_i)
  begin
    if vid_resetn_i = '0' then
      s_fsync_d1     <= '0';
      s_fsync_d2     <= '0';
      s_fsync_toggle <= '0';
    elsif rising_edge(vid_clk_i) then
      s_fsync_d1 <= vid_frame_sync_i;
      s_fsync_d2 <= s_fsync_d1;
      if s_fsync_d1 = '1' and s_fsync_d2 = '0' then
        s_fsync_toggle <= not s_fsync_toggle;
      end if;
    end if;
  end process;

  --=========================================================================
  -- mgt_clk: 2-FF sync of frame_sync toggle, detect write event
  --=========================================================================
  p_mgt_fsync : process(mgt_clk_i, mgt_resetn_i)
  begin
    if mgt_resetn_i = '0' then
      s_fsync_m1   <= '0';
      s_fsync_m2   <= '0';
      s_fsync_prev <= '0';
    elsif rising_edge(mgt_clk_i) then
      s_fsync_m1   <= s_fsync_toggle;
      s_fsync_m2   <= s_fsync_m1;
      s_fsync_prev <= s_fsync_m2;
    end if;
  end process;

  s_write_event <= s_fsync_m2 xor s_fsync_prev;

  --=========================================================================
  -- mgt_clk: disp_frame_end CDC directly from pixel_clk
  -- 3-FF synchronizer: m1/m2 resolve metastability, d for edge detect
  --=========================================================================
  p_mgt_fend : process(mgt_clk_i, mgt_resetn_i)
  begin
    if mgt_resetn_i = '0' then
      s_fend_m1 <= '0';
      s_fend_m2 <= '0';
      s_fend_d  <= '0';
    elsif rising_edge(mgt_clk_i) then
      s_fend_m1 <= disp_frame_end_i;
      s_fend_m2 <= s_fend_m1;
      s_fend_d  <= s_fend_m2;
    end if;
  end process;

  s_display_event <= s_fend_m2 and not s_fend_d;

  --=========================================================================
  -- mgt_clk: swap toggle event detect (same clock domain as APB bus)
  --=========================================================================
  p_mgt_swap : process(mgt_clk_i, mgt_resetn_i)
  begin
    if mgt_resetn_i = '0' then
      s_swap_prev <= '0';
    elsif rising_edge(mgt_clk_i) then
      s_swap_prev <= swap_toggle_i;
    end if;
  end process;

  s_swap_event <= swap_toggle_i xor s_swap_prev;

  --=========================================================================
  -- mgt_clk: ARBITER -- pool-based buffer state machine
  --
  -- Uses variables so events are processed sequentially within one cycle:
  -- write --> swap --> display. A camera frame arriving on the same cycle
  -- as a swap flows through in one clock (swap sees the just-written frame).
  --
  -- Free stack depth is 3. Proven invariant: free_count >= 1 at all times,
  -- and array indices stay within 0..2.
  --=========================================================================
  p_arbiter : process(mgt_clk_i)
    variable v_wr_buf        : std_logic_vector(3 downto 0);
    variable v_wr_latest     : std_logic_vector(3 downto 0);
    variable v_wr_latest_v   : std_logic;
    variable v_proc_buf      : std_logic_vector(3 downto 0);
    variable v_proc_latest   : std_logic_vector(3 downto 0);
    variable v_proc_latest_v : std_logic;
    variable v_disp_buf      : std_logic_vector(3 downto 0);
    variable v_free          : t_idx_array(0 to C_FREE_DEPTH - 1);
    variable v_fcnt          : integer range 0 to C_FREE_DEPTH;
    variable v_new_frame     : std_logic;
    variable v_wr_changed    : boolean;
    variable v_disp_changed  : boolean;
  begin
    if rising_edge(mgt_clk_i) then
      -- Snapshot current state into variables
      v_wr_buf        := s_wr_buf;
      v_wr_latest     := s_wr_latest;
      v_wr_latest_v   := s_wr_latest_v;
      v_proc_buf      := s_proc_buf;
      v_proc_latest   := s_proc_latest;
      v_proc_latest_v := s_proc_latest_v;
      v_disp_buf      := s_disp_buf;
      v_free          := s_free_stack;
      v_fcnt          := s_free_count;
      v_new_frame     := s_new_frame;
      v_wr_changed    := false;
      v_disp_changed  := false;

      -----------------------------------------------------------------
      -- WRITE EVENT: camera finished a frame, needs a new buffer
      -----------------------------------------------------------------
      if s_write_event = '1' then
        -- Recycle stale wr_latest if host hasn't consumed it
        if v_wr_latest_v = '1' then
          v_free(v_fcnt) := v_wr_latest;
          v_fcnt         := v_fcnt + 1;
        end if;
        -- Just-finished frame becomes available for processing
        v_wr_latest   := v_wr_buf;
        v_wr_latest_v := '1';
        -- Allocate a free buffer for the next camera write
        v_fcnt       := v_fcnt - 1;
        v_wr_buf     := v_free(v_fcnt);
        v_wr_changed := true;
      end if;

      -----------------------------------------------------------------
      -- SWAP EVENT: host finished processing, wants next frame
      -- Only rotate when a new camera frame is available, otherwise
      -- proc_buf and proc_latest would alias the same physical buffer.
      -----------------------------------------------------------------
      if s_swap_event = '1' then
        if v_wr_latest_v = '1' then
          -- Recycle stale proc_latest if display hasn't consumed it
          if v_proc_latest_v = '1' then
            v_free(v_fcnt) := v_proc_latest;
            v_fcnt         := v_fcnt + 1;
          end if;
          -- Just-processed frame becomes available for display
          v_proc_latest   := v_proc_buf;
          v_proc_latest_v := '1';
          -- Host gets the newest camera frame
          v_proc_buf    := v_wr_latest;
          v_wr_latest_v := '0';
          v_new_frame   := '1';
        else
          -- No new camera frame: skip rotation, host keeps same buffer
          v_new_frame := '0';
        end if;
      end if;

      -----------------------------------------------------------------
      -- DISPLAY EVENT: display finished, wants next processed frame
      -----------------------------------------------------------------
      if s_display_event = '1' then
        if v_proc_latest_v = '1' then
          -- Recycle old display buffer and show the processed frame
          v_free(v_fcnt) := v_disp_buf;
          v_fcnt         := v_fcnt + 1;
          v_disp_buf      := v_proc_latest;
          v_proc_latest_v := '0';
          v_disp_changed  := true;
        end if;
        -- else: no new processed frame, keep displaying the same one
      end if;

      -----------------------------------------------------------------
      -- Commit state
      -----------------------------------------------------------------
      s_wr_buf        <= v_wr_buf;
      s_wr_latest     <= v_wr_latest;
      s_wr_latest_v   <= v_wr_latest_v;
      s_proc_buf      <= v_proc_buf;
      s_proc_latest   <= v_proc_latest;
      s_proc_latest_v <= v_proc_latest_v;
      s_disp_buf      <= v_disp_buf;
      s_free_stack    <= v_free;
      s_free_count    <= v_fcnt;
      s_new_frame     <= v_new_frame;

      -- Update CDC hold registers and toggle when indices change
      if v_wr_changed then
        s_wr_hold       <= v_wr_buf;
        s_wr_cdc_toggle <= not s_wr_cdc_toggle;
      end if;

      if v_disp_changed then
        s_disp_hold       <= v_disp_buf;
        s_disp_cdc_toggle <= not s_disp_cdc_toggle;
      end if;

      -----------------------------------------------------------------
      -- Synchronous reset (last priority -- overrides all above)
      -----------------------------------------------------------------
      if mgt_resetn_i = '0' then
        s_wr_buf          <= C_INIT_WR;
        s_wr_latest       <= C_INIT_WR;
        s_wr_latest_v     <= '0';
        s_proc_buf        <= C_INIT_PROC;
        s_proc_latest     <= C_INIT_PROC;
        s_proc_latest_v   <= '0';
        s_disp_buf        <= C_INIT_DISP;
        s_free_stack      <= C_INIT_FREE;
        s_free_count      <= C_FREE_DEPTH;
        s_new_frame       <= '0';
        s_wr_hold         <= C_INIT_WR;
        s_wr_cdc_toggle   <= '0';
        s_disp_hold       <= C_INIT_DISP;
        s_disp_cdc_toggle <= '0';
      end if;
    end if;
  end process;

  --=========================================================================
  -- CDC: mgt_clk --> vid_clk (write buffer index)
  -- Hold register is stable before toggle propagates through 2-FF sync.
  --=========================================================================
  p_vid_wr_cdc : process(vid_clk_i, vid_resetn_i)
  begin
    if vid_resetn_i = '0' then
      s_wr_cdc_m1  <= '0';
      s_wr_cdc_m2  <= '0';
      s_wr_cdc_d   <= '0';
      s_vid_wr_idx <= C_INIT_WR;
    elsif rising_edge(vid_clk_i) then
      s_wr_cdc_m1 <= s_wr_cdc_toggle;
      s_wr_cdc_m2 <= s_wr_cdc_m1;
      s_wr_cdc_d  <= s_wr_cdc_m2;
      if s_wr_cdc_m2 /= s_wr_cdc_d then
        s_vid_wr_idx <= s_wr_hold;
      end if;
    end if;
  end process;

  --=========================================================================
  -- CDC: mgt_clk --> ddr_clk (display buffer index)
  --=========================================================================
  p_ddr_disp_cdc : process(ddr_clk_i, ddr_resetn_i)
  begin
    if ddr_resetn_i = '0' then
      s_disp_cdc_m1  <= '0';
      s_disp_cdc_m2  <= '0';
      s_disp_cdc_d   <= '0';
      s_ddr_disp_idx <= C_INIT_DISP;
    elsif rising_edge(ddr_clk_i) then
      s_disp_cdc_m1 <= s_disp_cdc_toggle;
      s_disp_cdc_m2 <= s_disp_cdc_m1;
      s_disp_cdc_d  <= s_disp_cdc_m2;
      if s_disp_cdc_m2 /= s_disp_cdc_d then
        s_ddr_disp_idx <= s_disp_hold;
      end if;
    end if;
  end process;

  --=========================================================================
  -- Output assignments
  --=========================================================================
  vid_write_addr_o     <= frame_base_addr_i & s_vid_wr_idx;
  disp_read_addr_o     <= frame_base_addr_i & s_ddr_disp_idx;
  process_frame_addr_o <= frame_base_addr_i & s_proc_buf;
  process_next_addr_o  <= frame_base_addr_i & s_wr_latest;
  swap_new_frame_o     <= s_new_frame;

end rtl;
