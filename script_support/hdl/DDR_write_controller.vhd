--=================================================================================================
-- File Name                           : DDR_write_controller.vhd


-- Targeted device                     : Microsemi-SoC
-- Author                              : India Solutions Team
--
-- COPYRIGHT 2019 BY MICROSEMI
-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROSEMI
-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROSEMI FOR USE OF THIS
-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
--
--=================================================================================================

--=================================================================================================
-- Libraries
--=================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_SIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

--=================================================================================================
-- DDR_write_controller entity declaration
--=================================================================================================
entity DDR_write_controller is
  generic(
-- Generic list
    -- Video format selection
    g_DDR_AXI_AWIDTH : integer := 32
    );
  port(
-- Port list
    -- System reset
    reset_i : in std_logic;

    -- System clock
    sys_clk_i : in std_logic;

    -- write enable
    start_i : in std_logic;

    -- write Acknowledgement input
    write_ackn_i : in std_logic;

    -- write done input
    write_done_i : in std_logic;

    -- frame end signal from video source
    frame_valid_i : in std_logic;

    -- save last frame on signal switch
    save_frame_i       : in std_logic;
    -- Horizontal pixel resolution
    horiz_resolution_i : in std_logic_vector(15 downto 0);

    --Frame DDR address
    frame_ddr_addr_i : in std_logic_vector(7 downto 0);

    -- write request to DDR
    write_req_o : out std_logic;

    -- Read request to fifo
    read_fifo_o : out std_logic;

    -- DDR write FRAME ADDRESS
    display_frame_addr_o : out std_logic_vector(7 downto 0);

    -- DDR write START ADDRESS
    write_start_addr_o : out std_logic_vector(g_DDR_AXI_AWIDTH-1 downto 0);

    -- Number of Bytes to write
    write_length_o : out std_logic_vector(15 downto 0);

    --frame buffer that is not overwritten
    process_frame_addr_o      : out std_logic_vector(g_DDR_AXI_AWIDTH-1 downto 0);
    process_next_frame_addr_o : out std_logic_vector(g_DDR_AXI_AWIDTH-1 downto 0);
    process_next_next_frame_addr_o : out std_logic_vector(g_DDR_AXI_AWIDTH-1 downto 0)

    );
end DDR_write_controller;

--=================================================================================================
-- DDR_write_controller architecture body
--=================================================================================================

architecture DDR_write_controller of DDR_write_controller is

--=================================================================================================
-- Component declarations
--=================================================================================================
--NA--
--=================================================================================================
-- Synthesis Attributes
--=================================================================================================
--NA--
--=================================================================================================
-- Signal declarations
--=================================================================================================


  constant c_LINE_GAP : std_logic_vector(15 downto 0) := x"2000";
  type FSM_STATE is (IDLE,
                     WRITE_REQUESTING,
                     WRITING);
  signal s_state                    : FSM_STATE;
  signal s_frame_valid_dly1         : std_logic;
  signal s_frame_valid_dly2         : std_logic;
  signal s_save_frame_dly1          : std_logic;
  signal s_save_frame_dly2          : std_logic;
  signal s_frame_valid_re           : std_logic;
  signal s_start_dly1               : std_logic;
  signal s_start_dly2               : std_logic;
  signal s_start_fe                 : std_logic;
  signal s_write_req                : std_logic;
  signal s_read_fifo                : std_logic;
  signal s_write_start_addr         : std_logic_vector(g_DDR_AXI_AWIDTH-1 downto 0);
  signal s_counter                  : std_logic_vector(15 downto 0);
  signal s_count_max                : std_logic_vector(15 downto 0);
  signal s_line_counter             : std_logic_vector(23 downto 0);
  signal s_frame_index_processed    : std_logic_vector(3 downto 0);
  signal s_frame_index_process      : std_logic_vector(3 downto 0);
  signal s_frame_index_process_next : std_logic_vector(3 downto 0);
  signal s_frame_index_process_next_next : std_logic_vector(3 downto 0);
  signal s_frame_index_writing      : std_logic_vector(3 downto 0);
  signal s_frame_index_wrote0       : std_logic_vector(3 downto 0);  --newest
  signal s_frame_index_wrote1       : std_logic_vector(3 downto 0);
  signal s_frame_index_wrote2       : std_logic_vector(3 downto 0);  --oldest
begin

--=================================================================================================
-- Top level output port assignments
--=================================================================================================

  write_req_o                                                                       <= s_write_req;
  write_start_addr_o                                                                <= s_write_start_addr;
  write_length_o                                                                    <= s_count_max - '1';
  read_fifo_o                                                                       <= s_read_fifo;
  display_frame_addr_o                                                              <= frame_ddr_addr_i(7 downto 4) & s_frame_index_processed;
  process_frame_addr_o(process_frame_addr_o'left downto process_frame_addr_o'left-7) <= frame_ddr_addr_i(7 downto 4) & s_frame_index_process;
  process_frame_addr_o(process_frame_addr_o'left-8 downto 0)                       <= (others => '0');

  process_next_frame_addr_o(process_frame_addr_o'left downto process_frame_addr_o'left-7) <= frame_ddr_addr_i(7 downto 4) & s_frame_index_process_next;
  process_next_frame_addr_o(process_frame_addr_o'left-8 downto 0)                       <= (others => '0');

  process_next_next_frame_addr_o(process_frame_addr_o'left downto process_frame_addr_o'left-7) <= frame_ddr_addr_i(7 downto 4) & s_frame_index_process_next_next;
  process_next_next_frame_addr_o(process_frame_addr_o'left-8 downto 0)                       <= (others => '0');

--=================================================================================================
-- Generate blocks
--=================================================================================================

--=================================================================================================
-- Asynchronous blocks
--=================================================================================================

  s_frame_valid_re   <= s_frame_valid_dly1 and not(s_frame_valid_dly2);
  s_start_fe         <= s_start_dly2 and not(s_start_dly1);
  s_write_start_addr <= frame_ddr_addr_i(7 downto 4) & s_frame_index_writing & s_line_counter;

--=================================================================================================
-- Synchronous blocks
--=================================================================================================

--------------------------------------------------------------------------
-- Name       : SIGNAL_DELAY
-- Description: Process to delay signal and find rising edge
--------------------------------------------------------------------------
  SIGNAL_DELAY :
  process(SYS_CLK_I, RESET_I)
  begin
    if (RESET_I = '0') then
      s_frame_valid_dly1 <= '0';
      s_frame_valid_dly2 <= '0';
      s_start_dly1       <= '0';
      s_start_dly2       <= '0';
      s_save_frame_dly1   <= '0';
      s_save_frame_dly2   <= '0';
    elsif rising_edge(SYS_CLK_I) then
      s_frame_valid_dly1 <= frame_valid_i;
      s_frame_valid_dly2 <= s_frame_valid_dly1;
      s_start_dly1       <= start_i;
      s_start_dly2       <= s_start_dly1;
      s_save_frame_dly1   <= save_frame_i;
      s_save_frame_dly2   <= s_save_frame_dly1;
    end if;
  end process;

  frame_index_control : process (SYS_CLK_I) is
  begin  -- process frame_index_control
    if rising_edge(SYS_CLK_I) then      -- rising clock edge
      if s_state = IDLE and s_frame_valid_re = '1' then
        s_frame_index_wrote0  <= s_frame_index_writing;
        s_frame_index_writing <= s_frame_index_wrote2;
        s_frame_index_wrote2  <= s_frame_index_wrote1;
        s_frame_index_wrote1  <= s_frame_index_wrote0;
      end if;
      if s_save_frame_dly1 /= s_save_frame_dly2 then
        --can override what happens in the IDLE clause of the
        --above case statement
        s_frame_index_writing           <= s_frame_index_writing;
        s_frame_index_process_next_next <= s_frame_index_wrote0;
        s_frame_index_process_next      <= s_frame_index_process_next_next;
        s_frame_index_process           <= s_frame_index_process_next;
        s_frame_index_processed         <= s_frame_index_process;
        s_frame_index_wrote2          <= s_frame_index_processed;
        s_frame_index_wrote1          <= s_frame_index_wrote2;
        s_frame_index_wrote0          <= s_frame_index_wrote1;
      end if;
      if RESET_I = '0' then
        --This shouldn't happen but the reset sometimes doesn't work properly.
        --also its a nice condition to trigger on in identify.
        -- address is upper 3 bits (set to 7) + the lower 4 bits
        s_frame_index_writing         <= "0111"; -- 0x77
        s_frame_index_process         <= "1000"; -- 0x78
        s_frame_index_process_next_next    <= "1001"; -- 0x79
        s_frame_index_process_next    <= "1010"; -- 0x7A
        s_frame_index_processed       <= "1011"; -- 0x7B
        s_frame_index_wrote0          <= "1100"; -- 0x7C
        s_frame_index_wrote1          <= "1101"; -- 0x7D
        s_frame_index_wrote2          <= "1110"; -- 0x7E
      end if;
    end if;
  end process frame_index_control;
-- purpose: mark one of the frame buffers as frozen so that it is not overwritten
--------------------------------------------------------------------------
-- Name       : CORDIC_FSM_PROC
-- Description: FSM implements cordic operations
--------------------------------------------------------------------------
  CORDIC_FSM_PROC :
  process(SYS_CLK_I, RESET_I)
  begin
    if (RESET_I = '0') then
      s_state        <= IDLE;
      s_write_req    <= '0';
      s_read_fifo    <= '0';
      s_count_max    <= (others => '0');
      s_counter      <= (others => '0');
      s_line_counter <= (others => '0');
    elsif rising_edge(SYS_CLK_I) then
      case s_state is
--------------------
-- IDLE state
--------------------
        when IDLE =>
          s_write_req <= '0';
          s_read_fifo <= '0';
          s_counter   <= (others => '0');
          if s_frame_valid_re = '1' then
            s_line_counter <= (others => '0');
          end if;
          if(s_start_fe = '1' and horiz_resolution_i > x"00FF") then
            s_count_max <= "000" & horiz_resolution_i(15 downto 3);
            s_state     <= WRITE_REQUESTING;
          end if;
--------------------
-- WRITE_REQUESTING state
--------------------
        when WRITE_REQUESTING =>
          if(write_ackn_i = '1') then
            s_write_req <= '0';
            s_state     <= WRITING;
          else
            s_write_req <= '1';
          end if;
--------------------
-- WRITING state
--------------------
        when WRITING =>
          if(write_done_i = '1') then
            s_state        <= IDLE;
            s_line_counter <= s_line_counter + C_LINE_GAP;
          elsif(s_counter >= s_count_max) then
            s_read_fifo <= '0';
          else
            s_counter   <= s_counter + '1';
            s_read_fifo <= '1';
          end if;
--------------------
-- OTHERS state
--------------------
        when others =>
          s_state <= IDLE;
      end case;

    end if;
  end process;


--=================================================================================================
-- Component Instantiations
--=================================================================================================
--NA--
end DDR_write_controller;
