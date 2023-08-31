library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.draw_assist_pkg.all;

entity draw_assist is
  generic (
    MAX_LOG2_BURSTLENGTH : positive range 1 to 8 := 6;  --uSRAM buffers
    M_AXI_DATA_WIDTH     : positive              := 256
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    m_axi_arready : in  std_logic;
    m_axi_arvalid : out std_logic;
    m_axi_arid    : out std_logic_vector(1 downto 0);
    m_axi_araddr  : out std_logic_vector(32-1 downto 0);
    m_axi_arlen   : out std_logic_vector(7 downto 0);
    m_axi_arsize  : out std_logic_vector(2 downto 0);
    m_axi_arburst : out std_logic_vector(1 downto 0);
    m_axi_arprot  : out std_logic_vector(2 downto 0);
    m_axi_arcache : out std_logic_vector(3 downto 0);
    m_axi_rready  : out std_logic;
    m_axi_rvalid  : in  std_logic;
    m_axi_rid     : in  std_logic_vector(1 downto 0);
    m_axi_rdata   : in  std_logic_vector(M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_rresp   : in  std_logic_vector(1 downto 0);
    m_axi_rlast   : in  std_logic;
    m_axi_awready : in  std_logic;
    m_axi_awvalid : out std_logic;
    m_axi_awid    : out std_logic_vector(1 downto 0);
    m_axi_awaddr  : out std_logic_vector(32-1 downto 0);
    m_axi_awlen   : out std_logic_vector(7 downto 0);
    m_axi_awsize  : out std_logic_vector(2 downto 0);
    m_axi_awburst : out std_logic_vector(1 downto 0);
    m_axi_awprot  : out std_logic_vector(2 downto 0);
    m_axi_awcache : out std_logic_vector(3 downto 0);
    m_axi_wready  : in  std_logic;
    m_axi_wvalid  : out std_logic;
    m_axi_wdata   : out std_logic_vector(M_AXI_DATA_WIDTH-1 downto 0);
    m_axi_wstrb   : out std_logic_vector((M_AXI_DATA_WIDTH/8)-1 downto 0);
    m_axi_wlast   : out std_logic;
    m_axi_bready  : out std_logic;
    m_axi_bvalid  : in  std_logic;
    m_axi_bid     : in  std_logic_vector(1 downto 0);
    m_axi_bresp   : in  std_logic_vector(1 downto 0);

    s_axi_awaddr  : in  std_logic_vector(12-1 downto 0);
    s_axi_awvalid : in  std_logic;
    s_axi_awready : out std_logic;
    s_axi_wdata   : in  std_logic_vector(32-1 downto 0);
    s_axi_wstrb   : in  std_logic_vector((32/8)-1 downto 0);
    s_axi_wvalid  : in  std_logic;
    s_axi_wready  : out std_logic;
    s_axi_bready  : in  std_logic;
    s_axi_bresp   : out std_logic_vector(1 downto 0);
    s_axi_bvalid  : out std_logic;
    s_axi_araddr  : in  std_logic_vector(12-1 downto 0);
    s_axi_arvalid : in  std_logic;
    s_axi_arready : out std_logic;
    s_axi_rready  : in  std_logic;
    s_axi_rdata   : out std_logic_vector(32-1 downto 0);
    s_axi_rresp   : out std_logic_vector(1 downto 0);
    s_axi_rvalid  : out std_logic
    );
end entity draw_assist;

architecture rtl of draw_assist is
  constant S_AXI_ADDRESS_WIDTH : positive := 12;

  constant MAX_OUTSTANDING_READS  : positive := 7;
  constant MAX_OUTSTANDING_WRITES : positive := 7;

  constant M_AXI_LOG2_BURSTLENGTH    : positive := 8;
  constant M_OIMM_LOG2_BURSTLENGTH   : positive := imin(MAX_LOG2_BURSTLENGTH, log2((4096*8)/M_AXI_DATA_WIDTH));
  constant ALIGNED_LOG2_BURSTLENGTH  : positive := M_OIMM_LOG2_BURSTLENGTH+log2(M_AXI_DATA_WIDTH/32);
  constant INTERNAL_LOG2_BURSTLENGTH : positive := imax(1, log2_f((2**ALIGNED_LOG2_BURSTLENGTH)-imax(0, (M_AXI_DATA_WIDTH/32)-1)));
  constant READDATA_FIFO_DEPTH       : positive := 2**(INTERNAL_LOG2_BURSTLENGTH+1);

  signal engine_running : std_logic;

  signal new_drawing_ready : std_logic;
  signal new_drawing_valid : std_logic;
  signal new_drawing       : drawing_record;

  signal input_drawing_ready : std_logic;
  signal input_drawing_valid : std_logic;
  signal input_drawing_done  : std_logic;
  signal input_drawing       : drawing_record;

  signal da_readdata_fifo_remw     : unsigned(log2(READDATA_FIFO_DEPTH+1)-1 downto 0);
  signal da_readdata_fifo_usedw    : unsigned(log2(READDATA_FIFO_DEPTH+1)-1 downto 0);
  signal da_readdata_fifo_we       : std_logic;
  signal da_readdata_fifo_data_in  : std_logic_vector(32-1 downto 0);
  signal da_readdata_fifo_wrfull   : std_logic;
  signal da_readdata_fifo_rd       : std_logic;
  signal da_readdata_fifo_data_out : std_logic_vector(32-1 downto 0);
  signal da_readdata_fifo_rdempty  : std_logic;

  signal output_drawing_ready : std_logic;
  signal output_drawing_done  : std_logic;
  signal output_drawing       : drawing_record;

  signal input_read_columns_minus1           : unsigned(31 downto 0);
  signal input_read_end_address_minus4       : unsigned(31 downto 0);
  signal input_read_beat_address             : unsigned(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal input_read_end_beat_address_minus1  : unsigned(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal input_read_burst_address            : unsigned(31-(INTERNAL_LOG2_BURSTLENGTH+2) downto 0);
  signal input_read_end_burst_address_minus1 : unsigned(31-(INTERNAL_LOG2_BURSTLENGTH+2) downto 0);
  signal input_read_last_burst               : std_logic;
  signal input_read_stride_fraction          : unsigned(STRIDE_FRACTIONAL_BITS downto 0);

  signal input_read_address            : unsigned(31 downto 0);
  signal input_read_burstlength_minus1 : unsigned(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal input_read_requestvalid       : std_logic;
  signal input_read_readdata           : std_logic_vector(32-1 downto 0);
  signal input_read_readdatavalid      : std_logic;
  signal input_read_waitrequest        : std_logic;

  signal output_write_columns_minus1           : unsigned(31 downto 0);
  signal output_write_end_address_minus4       : unsigned(31 downto 0);
  signal output_write_beat_address             : unsigned(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_end_beat_address_minus1  : unsigned(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_burst_address            : unsigned(31-(INTERNAL_LOG2_BURSTLENGTH+2) downto 0);
  signal output_write_end_burst_address_minus1 : unsigned(31-(INTERNAL_LOG2_BURSTLENGTH+2) downto 0);
  signal output_write_last_burst               : std_logic;
  signal output_write_writefirst               : std_logic;
  signal output_write_beat                     : unsigned(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_stride_fraction          : unsigned(STRIDE_FRACTIONAL_BITS downto 0);

  signal output_write_address            : unsigned(31 downto 0);
  signal output_write_burstlength_minus1 : unsigned(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_requestvalid       : std_logic;
  signal output_write_writedata          : std_logic_vector(32-1 downto 0);
  signal output_write_byteenable         : std_logic_vector((32/8)-1 downto 0);
  signal output_write_writelast          : std_logic;
  signal output_write_waitrequest        : std_logic;

  signal input_read_throttler_idle               : std_logic;
  signal input_read_throttler_address            : std_logic_vector(31 downto 0);
  signal input_read_throttler_burstlength_minus1 : std_logic_vector(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal input_read_throttler_requestvalid       : std_logic;
  signal input_read_throttler_readdata           : std_logic_vector(32-1 downto 0);
  signal input_read_throttler_readdatavalid      : std_logic;
  signal input_read_throttler_readcomplete       : std_logic;
  signal input_read_throttler_waitrequest        : std_logic;

  signal output_write_throttler_idle               : std_logic;
  signal output_write_throttler_burstlength_minus1 : std_logic_vector(INTERNAL_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_throttler_address            : std_logic_vector(31 downto 0);
  signal output_write_throttler_requestvalid       : std_logic;
  signal output_write_throttler_writedata          : std_logic_vector(32-1 downto 0);
  signal output_write_throttler_byteenable         : std_logic_vector((32/8)-1 downto 0);
  signal output_write_throttler_writelast          : std_logic;
  signal output_write_throttler_writecomplete      : std_logic;
  signal output_write_throttler_waitrequest        : std_logic;

  signal input_read_aligned_address            : std_logic_vector(31 downto 0);
  signal input_read_aligned_burstlength_minus1 : std_logic_vector(ALIGNED_LOG2_BURSTLENGTH-1 downto 0);
  signal input_read_aligned_requestvalid       : std_logic;
  signal input_read_aligned_readdata           : std_logic_vector(32-1 downto 0);
  signal input_read_aligned_readdatavalid      : std_logic;
  signal input_read_aligned_readcomplete       : std_logic;
  signal input_read_aligned_waitrequest        : std_logic;

  signal output_write_aligned_burstlength_minus1 : std_logic_vector(ALIGNED_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_aligned_address            : std_logic_vector(31 downto 0);
  signal output_write_aligned_requestvalid       : std_logic;
  signal output_write_aligned_writedata          : std_logic_vector(32-1 downto 0);
  signal output_write_aligned_byteenable         : std_logic_vector((32/8)-1 downto 0);
  signal output_write_aligned_writelast          : std_logic;
  signal output_write_aligned_writecomplete      : std_logic;
  signal output_write_aligned_waitrequest        : std_logic;

  signal input_read_registered_address            : std_logic_vector(31 downto 0);
  signal input_read_registered_burstlength_minus1 : std_logic_vector(ALIGNED_LOG2_BURSTLENGTH-1 downto 0);
  signal input_read_registered_requestvalid       : std_logic;
  signal input_read_registered_readdata           : std_logic_vector(32-1 downto 0);
  signal input_read_registered_readdatavalid      : std_logic;
  signal input_read_registered_readcomplete       : std_logic;
  signal input_read_registered_waitrequest        : std_logic;

  signal output_write_registered_burstlength_minus1 : std_logic_vector(ALIGNED_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_registered_address            : std_logic_vector(31 downto 0);
  signal output_write_registered_requestvalid       : std_logic;
  signal output_write_registered_writedata          : std_logic_vector(32-1 downto 0);
  signal output_write_registered_byteenable         : std_logic_vector((32/8)-1 downto 0);
  signal output_write_registered_writelast          : std_logic;
  signal output_write_registered_writecomplete      : std_logic;
  signal output_write_registered_waitrequest        : std_logic;

  signal input_read_upsized_address            : std_logic_vector(31 downto 0);
  signal input_read_upsized_burstlength_minus1 : std_logic_vector(M_OIMM_LOG2_BURSTLENGTH-1 downto 0);
  signal input_read_upsized_requestvalid       : std_logic;
  signal input_read_upsized_readdata           : std_logic_vector(M_AXI_DATA_WIDTH-1 downto 0);
  signal input_read_upsized_readdatavalid      : std_logic;
  signal input_read_upsized_readcomplete       : std_logic;
  signal input_read_upsized_waitrequest        : std_logic;

  signal output_write_upsized_burstlength_minus1 : std_logic_vector(M_OIMM_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_upsized_address            : std_logic_vector(31 downto 0);
  signal output_write_upsized_requestvalid       : std_logic;
  signal output_write_upsized_writedata          : std_logic_vector(M_AXI_DATA_WIDTH-1 downto 0);
  signal output_write_upsized_byteenable         : std_logic_vector((M_AXI_DATA_WIDTH/8)-1 downto 0);
  signal output_write_upsized_writelast          : std_logic;
  signal output_write_upsized_writecomplete      : std_logic;
  signal output_write_upsized_waitrequest        : std_logic;

  signal output_write_buffered_burstlength_minus1 : std_logic_vector(M_OIMM_LOG2_BURSTLENGTH-1 downto 0);
  signal output_write_buffered_address            : std_logic_vector(31 downto 0);
  signal output_write_buffered_requestvalid       : std_logic;
  signal output_write_buffered_writedata          : std_logic_vector(M_AXI_DATA_WIDTH-1 downto 0);
  signal output_write_buffered_byteenable         : std_logic_vector((M_AXI_DATA_WIDTH/8)-1 downto 0);
  signal output_write_buffered_writelast          : std_logic;
  signal output_write_buffered_writecomplete      : std_logic;
  signal output_write_buffered_waitrequest        : std_logic;

  signal m_axi_awvalid_signal : std_logic;
  signal m_axi_wvalid_signal  : std_logic;
  signal aw_sending           : std_logic;
  signal aw_sent              : std_logic;
  signal w_sending            : std_logic;
  signal w_sent               : std_logic;
begin
  ------------------------------------------------------------------------------
  -- External AXI4-Lite slave control registers
  ------------------------------------------------------------------------------
  da_registers : entity work.draw_assist_registers
    generic map (
      ADDRESS_WIDTH => 12,
      DATA_WIDTH    => 32
      )
    port map (
      clk    => clk,
      resetn => resetn,

      --AXI4-Lite memory-mapped slave
      s_axi_awready => s_axi_awready,
      s_axi_awvalid => s_axi_awvalid,
      s_axi_awaddr  => s_axi_awaddr,

      s_axi_wready => s_axi_wready,
      s_axi_wvalid => s_axi_wvalid,
      s_axi_wdata  => s_axi_wdata,
      s_axi_wstrb  => s_axi_wstrb,

      s_axi_bready => s_axi_bready,
      s_axi_bvalid => s_axi_bvalid,
      s_axi_bresp  => s_axi_bresp,

      s_axi_arready => s_axi_arready,
      s_axi_arvalid => s_axi_arvalid,
      s_axi_araddr  => s_axi_araddr,

      s_axi_rready => s_axi_rready,
      s_axi_rvalid => s_axi_rvalid,
      s_axi_rdata  => s_axi_rdata,
      s_axi_rresp  => s_axi_rresp,

      engine_running => engine_running,

      new_drawing_ready => new_drawing_ready,
      new_drawing_valid => new_drawing_valid,
      new_drawing       => new_drawing
      );
  engine_running <=
    input_drawing_valid or
    (not input_drawing_done) or (not output_drawing_done) or
    (not input_read_throttler_idle) or (not output_write_throttler_idle);


  ------------------------------------------------------------------------------
  -- Input Reading State Machine
  ------------------------------------------------------------------------------
  new_drawing_ready <= (not input_drawing_valid) and input_drawing_done;
  process (clk) is
  begin
    if rising_edge(clk) then
      if new_drawing_ready = '1' and new_drawing_valid = '1' then
        input_drawing_valid             <= '1';
        input_drawing_done              <= '0';
        input_drawing                   <= new_drawing;
        input_read_columns_minus1       <= new_drawing.input_columns_minus1;
        input_read_address(31 downto 2) <= new_drawing.input_address(31 downto 2);
        input_read_end_address_minus4(31 downto 2) <=
          new_drawing.input_address(31 downto 2) +
          resize(new_drawing.input_columns_minus1, new_drawing.input_address'length-2);
        if new_drawing.input_is_scalar = '0' then
          input_drawing.input_address <=
            new_drawing.input_address +
            unsigned((resize(new_drawing.input_stride(new_drawing.input_stride'left downto
                                                      STRIDE_FRACTIONAL_BITS),
                             input_drawing.input_address'length-2) & "00"));
        end if;
        input_read_stride_fraction <=
          resize(unsigned(new_drawing.input_stride(STRIDE_FRACTIONAL_BITS-1 downto 0)),
                 input_read_stride_fraction'length) +
          resize(unsigned(new_drawing.input_stride(STRIDE_FRACTIONAL_BITS-1 downto 0)),
                 input_read_stride_fraction'length);
      end if;

      if input_drawing_ready = '1' and input_drawing_valid = '1' then
        input_drawing_valid <= '0';
      end if;

      if input_drawing_done = '0' then
        if input_drawing.input_is_scalar = '1' then
          if input_read_throttler_idle = '1' and da_readdata_fifo_wrfull = '0' then
            input_read_columns_minus1 <=
              input_read_columns_minus1 -
              (resize(input_read_burstlength_minus1, input_read_columns_minus1'length) +
               to_unsigned(1, input_read_columns_minus1'length));
            if (input_read_columns_minus1 =
                resize(input_read_burstlength_minus1, input_read_columns_minus1'length)) then
              input_drawing_done <= '1';
            end if;
          end if;
        else
          if input_read_requestvalid = '1' and input_read_waitrequest = '0' then
            input_read_columns_minus1 <=
              input_read_columns_minus1 -
              (resize(input_read_burstlength_minus1, input_read_columns_minus1'length) +
               to_unsigned(1, input_read_columns_minus1'length));
            input_read_address(31 downto 2) <=
              input_read_address(31 downto 2) +
              resize(input_read_burstlength_minus1, input_read_address'length-2) +
              to_unsigned(1, input_read_address'length-2);

            if (input_read_columns_minus1 =
                resize(input_read_burstlength_minus1, input_read_columns_minus1'length)) then
              input_read_columns_minus1       <= input_drawing.input_columns_minus1;
              input_read_address(31 downto 2) <= input_drawing.input_address(31 downto 2);
              input_read_end_address_minus4(31 downto 2) <=
                input_drawing.input_address(31 downto 2) +
                resize(input_drawing.input_columns_minus1, input_drawing.input_address'length-2);
              if input_read_stride_fraction(input_read_stride_fraction'left) = '1' then
                input_drawing.input_address <=
                  input_drawing.input_address +
                  unsigned((resize(input_drawing.input_stride(input_drawing.input_stride'left downto
                                                              STRIDE_FRACTIONAL_BITS),
                                   input_drawing.input_address'length-2) & "00")) +
                  to_unsigned(4, input_drawing.input_address'length);
              else
                input_drawing.input_address <=
                  input_drawing.input_address +
                  unsigned((resize(input_drawing.input_stride(input_drawing.input_stride'left downto
                                                              STRIDE_FRACTIONAL_BITS),
                                   input_drawing.input_address'length-2) & "00"));
              end if;
              input_read_stride_fraction <=
                resize(input_read_stride_fraction(STRIDE_FRACTIONAL_BITS-1 downto 0),
                       input_read_stride_fraction'length) +
                resize(unsigned(input_drawing.input_stride(STRIDE_FRACTIONAL_BITS-1 downto 0)),
                       input_read_stride_fraction'length);

              if input_drawing.input_rows = to_unsigned(1, input_drawing.input_rows'length) then
                input_drawing_done <= '1';
              end if;
              input_drawing.input_rows <= input_drawing.input_rows - to_unsigned(1, input_drawing.input_rows'length);
            end if;
          end if;
        end if;
      end if;

      if resetn = '0' then
        input_drawing_valid <= '0';
        input_drawing_done  <= '1';
      end if;
    end if;
  end process;
  input_read_address(1 downto 0)            <= (others => '0');
  input_read_end_address_minus4(1 downto 0) <= (others => '0');
  input_read_beat_address                   <= input_read_address(INTERNAL_LOG2_BURSTLENGTH+1 downto 2);
  input_read_end_beat_address_minus1        <= input_read_end_address_minus4(INTERNAL_LOG2_BURSTLENGTH+1 downto 2);
  input_read_burst_address                  <= input_read_address(31 downto INTERNAL_LOG2_BURSTLENGTH+2);
  input_read_end_burst_address_minus1       <= input_read_end_address_minus4(31 downto INTERNAL_LOG2_BURSTLENGTH+2);
  input_read_last_burst <=
    '1' when input_read_burst_address = input_read_end_burst_address_minus1 else
    '0';
  input_read_burstlength_minus1 <=
    to_unsigned(0, input_read_burstlength_minus1'length)         when input_drawing.input_is_scalar = '1' else
    input_read_end_beat_address_minus1 - input_read_beat_address when input_read_last_burst = '1' else
    not input_read_address(INTERNAL_LOG2_BURSTLENGTH+1 downto 2);

  input_read_requestvalid <=
    '0' when input_drawing_done = '1' or input_drawing.input_is_scalar = '1' else
    '1' when da_readdata_fifo_remw > resize(input_read_burstlength_minus1, da_readdata_fifo_remw'length) else
    '0';


  ------------------------------------------------------------------------------
  -- Return Data FIFO
  ------------------------------------------------------------------------------
  da_readdata_fifo_we <= input_read_readdatavalid or (input_read_throttler_idle and
                                                      (not da_readdata_fifo_wrfull) and
                                                      (not input_drawing_done) and
                                                      input_drawing.input_is_scalar);
  da_readdata_fifo_data_in <= input_read_readdata when input_read_throttler_idle = '0' else
                              std_logic_vector(input_drawing.input_address);
  da_readdata_fifo : entity work.draw_assist_fifo_sync
    generic map (
      WIDTH => 32,
      DEPTH => READDATA_FIFO_DEPTH
      )
    port map (
      clk    => clk,
      resetn => resetn,

      usedw => da_readdata_fifo_usedw,

      we      => da_readdata_fifo_we,
      data_in => da_readdata_fifo_data_in,
      wrfull  => da_readdata_fifo_wrfull,

      rd       => da_readdata_fifo_rd,
      data_out => da_readdata_fifo_data_out,
      rdempty  => da_readdata_fifo_rdempty
      );
  process (clk) is
  begin
    if rising_edge(clk) then
      if input_read_requestvalid = '1' and input_read_waitrequest = '0' then
        if da_readdata_fifo_rd = '1' then
          da_readdata_fifo_remw <=
            da_readdata_fifo_remw - resize(unsigned(input_read_burstlength_minus1), da_readdata_fifo_remw'length);
        else
          da_readdata_fifo_remw <=
            da_readdata_fifo_remw - (resize(unsigned(input_read_burstlength_minus1), da_readdata_fifo_remw'length) +
                                     to_unsigned(1, da_readdata_fifo_remw'length));
        end if;
      elsif (input_read_throttler_idle = '1' and
             da_readdata_fifo_wrfull = '0' and
             input_drawing_done = '0' and
             input_drawing.input_is_scalar = '1') then
        if da_readdata_fifo_rd = '0' then
          da_readdata_fifo_remw <=
            da_readdata_fifo_remw - to_unsigned(1, da_readdata_fifo_remw'length);
        end if;
      elsif da_readdata_fifo_rd = '1' then
        da_readdata_fifo_remw <=
          da_readdata_fifo_remw + to_unsigned(1, da_readdata_fifo_remw'length);
      end if;

      if resetn = '0' then
        da_readdata_fifo_remw <= to_unsigned(READDATA_FIFO_DEPTH, da_readdata_fifo_remw'length);
      end if;
    end if;
  end process;

  output_write_writedata  <= da_readdata_fifo_data_out;
  output_write_byteenable <= (others => '1');
  da_readdata_fifo_rd     <= output_write_requestvalid and (not output_write_waitrequest);


  ------------------------------------------------------------------------------
  -- Output Writing State Machine
  ------------------------------------------------------------------------------
  input_drawing_ready <= output_drawing_done;
  process (clk) is
  begin
    if rising_edge(clk) then
      if input_drawing_ready = '1' and input_drawing_valid = '1' then
        output_drawing_done               <= '0';
        output_drawing                    <= input_drawing;
        output_write_columns_minus1       <= input_drawing.output_columns_minus1;
        output_write_address(31 downto 2) <= input_drawing.output_address(31 downto 2);
        output_write_end_address_minus4(31 downto 2) <=
          input_drawing.output_address(31 downto 2) +
          resize(input_drawing.output_columns_minus1, input_drawing.output_address'length-2);
        output_drawing.output_address <=
          input_drawing.output_address +
          unsigned((resize(input_drawing.output_stride(input_drawing.output_stride'left downto
                                                       STRIDE_FRACTIONAL_BITS),
                           input_drawing.output_address'length-2) & "00"));
        output_write_stride_fraction <=
          resize(unsigned(input_drawing.output_stride(STRIDE_FRACTIONAL_BITS-1 downto 0)),
                 output_write_stride_fraction'length) +
          resize(unsigned(input_drawing.output_stride(STRIDE_FRACTIONAL_BITS-1 downto 0)),
                 output_write_stride_fraction'length);
      end if;

      if output_drawing_done = '0' then
        if output_write_requestvalid = '1' and output_write_waitrequest = '0' and output_write_writelast = '1' then
          output_write_columns_minus1 <=
            output_write_columns_minus1 -
            (resize(output_write_burstlength_minus1, output_write_columns_minus1'length) +
             to_unsigned(1, output_write_columns_minus1'length));
          output_write_address(31 downto 2) <=
            output_write_address(31 downto 2) +
            resize(output_write_burstlength_minus1, output_write_address'length-2) +
            to_unsigned(1, output_write_address'length-2);

          if (output_write_columns_minus1 =
              resize(output_write_burstlength_minus1, output_write_columns_minus1'length)) then
            output_write_columns_minus1 <= output_drawing.output_columns_minus1;

            output_write_address(31 downto 2) <= output_drawing.output_address(31 downto 2);
            output_write_end_address_minus4(31 downto 2) <=
              output_drawing.output_address(31 downto 2) +
              resize(output_drawing.output_columns_minus1, output_drawing.output_address'length-2);
            if output_write_stride_fraction(output_write_stride_fraction'left) = '1' then
              output_drawing.output_address <=
                output_drawing.output_address +
                unsigned((resize(output_drawing.output_stride(output_drawing.output_stride'left downto
                                                              STRIDE_FRACTIONAL_BITS),
                                 output_drawing.output_address'length-2) & "00")) +
                to_unsigned(4, output_drawing.output_address'length);
            else
              output_drawing.output_address <=
                output_drawing.output_address +
                unsigned((resize(output_drawing.output_stride(output_drawing.output_stride'left downto
                                                              STRIDE_FRACTIONAL_BITS),
                                 output_drawing.output_address'length-2) & "00"));
            end if;
            output_write_stride_fraction <=
              resize(output_write_stride_fraction(STRIDE_FRACTIONAL_BITS-1 downto 0),
                     output_write_stride_fraction'length) +
              resize(unsigned(output_drawing.output_stride(STRIDE_FRACTIONAL_BITS-1 downto 0)),
                     output_write_stride_fraction'length);

            if output_drawing.output_rows = to_unsigned(1, output_drawing.output_rows'length) then
              output_drawing_done <= '1';
            end if;
            output_drawing.output_rows <= output_drawing.output_rows -
                                          to_unsigned(1, output_drawing.output_rows'length);
          end if;
        end if;
      end if;

      if resetn = '0' then
        output_drawing_done <= '1';
      end if;
    end if;
  end process;
  output_write_address(1 downto 0)            <= (others => '0');
  output_write_end_address_minus4(1 downto 0) <= (others => '0');
  output_write_beat_address                   <= output_write_address(INTERNAL_LOG2_BURSTLENGTH+1 downto 2);
  output_write_end_beat_address_minus1        <= output_write_end_address_minus4(INTERNAL_LOG2_BURSTLENGTH+1 downto 2);
  output_write_burst_address                  <= output_write_address(31 downto INTERNAL_LOG2_BURSTLENGTH+2);
  output_write_end_burst_address_minus1       <= output_write_end_address_minus4(31 downto INTERNAL_LOG2_BURSTLENGTH+2);
  output_write_last_burst <=
    '1' when output_write_burst_address = output_write_end_burst_address_minus1 else
    '0';
  output_write_burstlength_minus1 <=
    output_write_end_beat_address_minus1 - output_write_beat_address when output_write_last_burst = '1' else
    not output_write_address(INTERNAL_LOG2_BURSTLENGTH+1 downto 2);

  output_write_requestvalid <=
    (not da_readdata_fifo_rdempty) and (not output_drawing_done) when
    (da_readdata_fifo_usedw > resize(output_write_burstlength_minus1, da_readdata_fifo_usedw'length) or
     output_write_writefirst = '0') else
    '0';

  --Track write beats
  process (clk) is
  begin
    if rising_edge(clk) then
      if output_write_requestvalid = '1' and output_write_waitrequest = '0' then
        output_write_writefirst <= output_write_writelast;
        output_write_beat       <= output_write_beat + to_unsigned(1, output_write_beat'length);
        if output_write_writelast = '1' then
          output_write_beat <= to_unsigned(0, output_write_beat'length);
        end if;
      end if;

      if resetn = '0' then
        output_write_writefirst <= '1';
        output_write_beat       <= to_unsigned(0, output_write_beat'length);
      end if;
    end if;
  end process;
  output_write_writelast <= '1' when output_write_beat = output_write_burstlength_minus1 else '0';


  ------------------------------------------------------------------------------
  -- Throttlers
  ------------------------------------------------------------------------------
  da_input_read_throttler : entity work.draw_assist_throttler
    generic map (
      MAX_OUTSTANDING_REQUESTS => MAX_OUTSTANDING_READS,
      HYSTERESIS_LEVEL         => 1,
      READ_WRITE_FENCE         => false
      )
    port map (
      clk    => clk,
      resetn => resetn,

      throttler_idle => input_read_throttler_idle,

      --ORCA-internal memory-mapped slave
      slave_oimm_requestvalid => input_read_requestvalid,
      slave_oimm_readnotwrite => '1',
      slave_oimm_writelast    => '0',
      slave_oimm_waitrequest  => input_read_waitrequest,

      --ORCA-internal memory-mapped master
      master_oimm_requestvalid  => input_read_throttler_requestvalid,
      master_oimm_readcomplete  => input_read_throttler_readcomplete,
      master_oimm_writecomplete => '0',
      master_oimm_waitrequest   => input_read_throttler_waitrequest
      );
  input_read_throttler_address            <= std_logic_vector(input_read_address);
  input_read_throttler_burstlength_minus1 <= std_logic_vector(input_read_burstlength_minus1);
  input_read_readdatavalid                <= input_read_throttler_readdatavalid;
  input_read_readdata                     <= input_read_throttler_readdata;

  da_output_write_throttler : entity work.draw_assist_throttler
    generic map (
      MAX_OUTSTANDING_REQUESTS => MAX_OUTSTANDING_WRITES,
      HYSTERESIS_LEVEL         => 1,
      READ_WRITE_FENCE         => false
      )
    port map (
      clk    => clk,
      resetn => resetn,

      throttler_idle => output_write_throttler_idle,

      --ORCA-internal memory-mapped slave
      slave_oimm_requestvalid => output_write_requestvalid,
      slave_oimm_readnotwrite => '0',
      slave_oimm_writelast    => output_write_writelast,
      slave_oimm_waitrequest  => output_write_waitrequest,

      --ORCA-internal memory-mapped master
      master_oimm_requestvalid  => output_write_throttler_requestvalid,
      master_oimm_readcomplete  => '0',
      master_oimm_writecomplete => output_write_throttler_writecomplete,
      master_oimm_waitrequest   => output_write_throttler_waitrequest
      );
  output_write_throttler_address            <= std_logic_vector(output_write_address);
  output_write_throttler_burstlength_minus1 <= std_logic_vector(output_write_burstlength_minus1);
  output_write_throttler_writedata          <= output_write_writedata;
  output_write_throttler_byteenable         <= output_write_byteenable;
  output_write_throttler_writelast          <= output_write_writelast;


  ------------------------------------------------------------------------------
  -- Burst Aligners
  ------------------------------------------------------------------------------
  da_input_read_burst_aligner : entity work.draw_assist_burst_aligner
    generic map (
      ADDRESS_WIDTH    => 32,
      DATA_WIDTH       => 32,
      LOG2_BURSTLENGTH => ALIGNED_LOG2_BURSTLENGTH,

      BURST_ALIGNMENT_WIDTH       => M_AXI_DATA_WIDTH,
      MAX_ALIGNED_READS_IN_FLIGHT => MAX_OUTSTANDING_READS
      )
    port map (
      clk    => clk,
      resetn => resetn,

      slave_address            => input_read_throttler_address,
      slave_burstlength_minus1 => input_read_throttler_burstlength_minus1,
      slave_requestvalid       => input_read_throttler_requestvalid,
      slave_readnotwrite       => '1',
      slave_byteenable         => (others => '-'),
      slave_writelast          => '-',
      slave_readdatavalid      => input_read_throttler_readdatavalid,
      slave_readcomplete       => input_read_throttler_readcomplete,
      slave_waitrequest        => input_read_throttler_waitrequest,

      master_address            => input_read_aligned_address,
      master_burstlength_minus1 => input_read_aligned_burstlength_minus1,
      master_requestvalid       => input_read_aligned_requestvalid,
      master_readnotwrite       => open,
      master_byteenable         => open,
      master_writelast          => open,
      master_readdatavalid      => input_read_aligned_readdatavalid,
      master_readcomplete       => input_read_aligned_readcomplete,
      master_waitrequest        => input_read_aligned_waitrequest
      );
  input_read_throttler_readdata <= input_read_aligned_readdata;

  da_output_write_burst_aligner : entity work.draw_assist_burst_aligner
    generic map (
      ADDRESS_WIDTH    => 32,
      DATA_WIDTH       => 32,
      LOG2_BURSTLENGTH => ALIGNED_LOG2_BURSTLENGTH,

      BURST_ALIGNMENT_WIDTH       => M_AXI_DATA_WIDTH,
      MAX_ALIGNED_READS_IN_FLIGHT => MAX_OUTSTANDING_READS
      )
    port map (
      clk    => clk,
      resetn => resetn,

      slave_address            => output_write_throttler_address,
      slave_burstlength_minus1 => output_write_throttler_burstlength_minus1,
      slave_requestvalid       => output_write_throttler_requestvalid,
      slave_readnotwrite       => '0',
      slave_byteenable         => output_write_throttler_byteenable,
      slave_writelast          => output_write_throttler_writelast,
      slave_readdatavalid      => open,
      slave_readcomplete       => open,
      slave_waitrequest        => output_write_throttler_waitrequest,

      master_address            => output_write_aligned_address,
      master_burstlength_minus1 => output_write_aligned_burstlength_minus1,
      master_requestvalid       => output_write_aligned_requestvalid,
      master_readnotwrite       => open,
      master_byteenable         => output_write_aligned_byteenable,
      master_writelast          => output_write_aligned_writelast,
      master_readdatavalid      => '0',
      master_readcomplete       => '0',
      master_waitrequest        => output_write_aligned_waitrequest
      );
  output_write_aligned_writedata       <= output_write_throttler_writedata;
  output_write_throttler_writecomplete <= output_write_aligned_writecomplete;


  ------------------------------------------------------------------------------
  -- Registers (for timing)
  ------------------------------------------------------------------------------
  da_input_read_register : entity work.draw_assist_register
    generic map (
      ADDRESS_WIDTH    => 32,
      DATA_WIDTH       => 32,
      LOG2_BURSTLENGTH => ALIGNED_LOG2_BURSTLENGTH,
      RETURN_REGISTER  => false
      )
    port map (
      clk    => clk,
      resetn => resetn,

      slave_address            => input_read_aligned_address,
      slave_burstlength_minus1 => input_read_aligned_burstlength_minus1,
      slave_byteenable         => (others => '-'),
      slave_requestvalid       => input_read_aligned_requestvalid,
      slave_readnotwrite       => '1',
      slave_writedata          => (others => '-'),
      slave_writelast          => '-',
      slave_readdata           => input_read_aligned_readdata,
      slave_readdatavalid      => input_read_aligned_readdatavalid,
      slave_readcomplete       => input_read_aligned_readcomplete,
      slave_waitrequest        => input_read_aligned_waitrequest,

      master_address            => input_read_registered_address,
      master_burstlength_minus1 => input_read_registered_burstlength_minus1,
      master_byteenable         => open,
      master_requestvalid       => input_read_registered_requestvalid,
      master_readnotwrite       => open,
      master_writedata          => open,
      master_writelast          => open,
      master_readdata           => input_read_registered_readdata,
      master_readdatavalid      => input_read_registered_readdatavalid,
      master_readcomplete       => input_read_registered_readcomplete,
      master_waitrequest        => input_read_registered_waitrequest
      );

  da_output_write_register : entity work.draw_assist_register
    generic map (
      ADDRESS_WIDTH    => 32,
      DATA_WIDTH       => 32,
      LOG2_BURSTLENGTH => ALIGNED_LOG2_BURSTLENGTH,
      RETURN_REGISTER  => false
      )
    port map (
      clk    => clk,
      resetn => resetn,

      slave_address            => output_write_aligned_address,
      slave_burstlength_minus1 => output_write_aligned_burstlength_minus1,
      slave_byteenable         => output_write_aligned_byteenable,
      slave_requestvalid       => output_write_aligned_requestvalid,
      slave_readnotwrite       => '0',
      slave_writedata          => output_write_aligned_writedata,
      slave_writelast          => output_write_aligned_writelast,
      slave_readdata           => open,
      slave_readdatavalid      => open,
      slave_readcomplete       => open,
      slave_waitrequest        => output_write_aligned_waitrequest,

      master_address            => output_write_registered_address,
      master_burstlength_minus1 => output_write_registered_burstlength_minus1,
      master_byteenable         => output_write_registered_byteenable,
      master_requestvalid       => output_write_registered_requestvalid,
      master_readnotwrite       => open,
      master_writedata          => output_write_registered_writedata,
      master_writelast          => output_write_registered_writelast,
      master_readdata           => (others => '-'),
      master_readdatavalid      => '0',
      master_readcomplete       => '0',
      master_waitrequest        => output_write_registered_waitrequest
      );
  output_write_aligned_writecomplete <= output_write_registered_writecomplete;


  ------------------------------------------------------------------------------
  -- Upsizers
  ------------------------------------------------------------------------------
  da_input_read_upsizer : entity work.draw_assist_upsizer
    generic map (
      ADDRESS_WIDTH          => 32,
      SLAVE_DATA_WIDTH       => 32,
      SLAVE_LOG2_BURSTLENGTH => ALIGNED_LOG2_BURSTLENGTH,
      MASTER_DATA_WIDTH      => M_AXI_DATA_WIDTH,
      MIN_RETURN_FIFO_DEPTH  => 64,
      ID_BITS                => 0
      )
    port map (
      clk    => clk,
      resetn => resetn,

      slave_address            => input_read_registered_address,
      slave_burstlength_minus1 => input_read_registered_burstlength_minus1,
      slave_byteenable         => (others => '-'),
      slave_requestvalid       => input_read_registered_requestvalid,
      slave_readnotwrite       => '1',
      slave_writedata          => (others => '-'),
      slave_writelast          => '-',
      slave_readdata           => input_read_registered_readdata,
      slave_readdatavalid      => input_read_registered_readdatavalid,
      slave_readcomplete       => input_read_registered_readcomplete,
      slave_waitrequest        => input_read_registered_waitrequest,

      master_address            => input_read_upsized_address,
      master_burstlength_minus1 => input_read_upsized_burstlength_minus1,
      master_byteenable         => open,
      master_requestvalid       => input_read_upsized_requestvalid,
      master_readnotwrite       => open,
      master_writedata          => open,
      master_writelast          => open,
      master_readdata           => input_read_upsized_readdata,
      master_readdatavalid      => input_read_upsized_readdatavalid,
      master_readcomplete       => input_read_upsized_readcomplete,
      master_waitrequest        => input_read_upsized_waitrequest
      );

  da_output_write_upsizer : entity work.draw_assist_upsizer
    generic map (
      ADDRESS_WIDTH          => 32,
      SLAVE_DATA_WIDTH       => 32,
      SLAVE_LOG2_BURSTLENGTH => ALIGNED_LOG2_BURSTLENGTH,
      MASTER_DATA_WIDTH      => M_AXI_DATA_WIDTH,
      MIN_RETURN_FIFO_DEPTH  => 64,
      ID_BITS                => 0
      )
    port map (
      clk    => clk,
      resetn => resetn,

      slave_address            => output_write_registered_address,
      slave_burstlength_minus1 => output_write_registered_burstlength_minus1,
      slave_byteenable         => output_write_registered_byteenable,
      slave_requestvalid       => output_write_registered_requestvalid,
      slave_readnotwrite       => '0',
      slave_writedata          => output_write_registered_writedata,
      slave_writelast          => output_write_registered_writelast,
      slave_readdata           => open,
      slave_readdatavalid      => open,
      slave_readcomplete       => open,
      slave_waitrequest        => output_write_registered_waitrequest,

      master_address            => output_write_upsized_address,
      master_burstlength_minus1 => output_write_upsized_burstlength_minus1,
      master_byteenable         => output_write_upsized_byteenable,
      master_requestvalid       => output_write_upsized_requestvalid,
      master_readnotwrite       => open,
      master_writedata          => output_write_upsized_writedata,
      master_writelast          => output_write_upsized_writelast,
      master_readdata           => (others => '-'),
      master_readdatavalid      => '0',
      master_readcomplete       => '0',
      master_waitrequest        => output_write_upsized_waitrequest
      );
  output_write_registered_writecomplete <= output_write_upsized_writecomplete;


  ------------------------------------------------------------------------------
  -- Write Burst Buffer
  ------------------------------------------------------------------------------
  da_output_write_write_burst_buffer : entity work.draw_assist_write_burst_buffer
    generic map (
      ADDRESS_WIDTH    => 32,
      DATA_WIDTH       => M_AXI_DATA_WIDTH,
      LOG2_BURSTLENGTH => M_OIMM_LOG2_BURSTLENGTH
      )
    port map (
      clk    => clk,
      resetn => resetn,

      slave_address            => output_write_upsized_address,
      slave_burstlength_minus1 => output_write_upsized_burstlength_minus1,
      slave_byteenable         => output_write_upsized_byteenable,
      slave_requestvalid       => output_write_upsized_requestvalid,
      slave_writedata          => output_write_upsized_writedata,
      slave_writelast          => output_write_upsized_writelast,
      slave_waitrequest        => output_write_upsized_waitrequest,

      master_address            => output_write_buffered_address,
      master_burstlength_minus1 => output_write_buffered_burstlength_minus1,
      master_byteenable         => output_write_buffered_byteenable,
      master_requestvalid       => output_write_buffered_requestvalid,
      master_writedata          => output_write_buffered_writedata,
      master_writelast          => output_write_buffered_writelast,
      master_waitrequest        => output_write_buffered_waitrequest
      );
  output_write_upsized_writecomplete <= output_write_buffered_writecomplete;


  ------------------------------------------------------------------------------
  -- AXI Conversion
  ------------------------------------------------------------------------------
  input_read_upsized_waitrequest <= not m_axi_arready;
  m_axi_arvalid                  <= input_read_upsized_requestvalid;
  m_axi_arid                     <= (others => '0');
  m_axi_araddr                   <= input_read_upsized_address;
  m_axi_arlen                    <= std_logic_vector(resize(unsigned(input_read_upsized_burstlength_minus1), M_AXI_LOG2_BURSTLENGTH));
  m_axi_arsize                   <= std_logic_vector(to_unsigned(log2(M_AXI_DATA_WIDTH/8), 3));
  m_axi_arburst                  <= "01";
  m_axi_arcache                  <= "0011";
  m_axi_arprot                   <= "000";

  m_axi_rready                     <= '1';
  input_read_upsized_readdatavalid <= m_axi_rvalid;
  input_read_upsized_readdata      <= m_axi_rdata;
  input_read_upsized_readcomplete  <= m_axi_rvalid and m_axi_rlast;

  output_write_buffered_waitrequest <=
    ((not m_axi_awready) and (not aw_sent) and (output_write_buffered_writelast or w_sent)) or
    ((not m_axi_wready) and (not w_sent));
  m_axi_awvalid_signal <= output_write_buffered_requestvalid and (not aw_sent);
  m_axi_awvalid        <= m_axi_awvalid_signal;
  m_axi_awid           <= (others => '0');
  m_axi_awaddr         <= output_write_buffered_address;
  m_axi_awlen          <= std_logic_vector(resize(unsigned(output_write_buffered_burstlength_minus1), M_AXI_LOG2_BURSTLENGTH));
  m_axi_awsize         <= std_logic_vector(to_unsigned(log2(M_AXI_DATA_WIDTH/8), 3));
  m_axi_awburst        <= "01";
  m_axi_awcache        <= "0011";
  m_axi_awprot         <= "000";

  m_axi_wvalid_signal <= output_write_buffered_requestvalid and (not w_sent);
  m_axi_wvalid        <= m_axi_wvalid_signal;
  m_axi_wdata         <= output_write_buffered_writedata;
  m_axi_wstrb         <= output_write_buffered_byteenable;
  m_axi_wlast         <= output_write_buffered_writelast;

  m_axi_bready                        <= '1';
  output_write_buffered_writecomplete <= m_axi_bvalid;

  --Track aw/w channel sent signals to decouple dependencies between channels
  aw_sending <= m_axi_awvalid_signal and m_axi_awready;
  w_sending  <= m_axi_wvalid_signal and output_write_buffered_writelast and m_axi_wready;
  process (clk) is
  begin
    if rising_edge(clk) then
      if aw_sending = '1' then
        if w_sent = '1' or w_sending = '1' then
          aw_sent <= '0';
          w_sent  <= '0';
        else
          aw_sent <= '1';
        end if;
      end if;
      if w_sending = '1' then
        if aw_sent = '1' or aw_sending = '1' then
          w_sent  <= '0';
          aw_sent <= '0';
        else
          w_sent <= '1';
        end if;
      end if;

      if resetn = '0' then
        aw_sent <= '0';
        w_sent  <= '0';
      end if;
    end if;
  end process;

end architecture rtl;
