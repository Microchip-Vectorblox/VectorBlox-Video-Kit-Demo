library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.draw_assist_pkg.all;

entity draw_assist_registers is
  generic (
    ADDRESS_WIDTH : positive;
    DATA_WIDTH    : positive range 32 to 32
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    --AXI4-Lite memory-mapped slave
    s_axi_awready : out std_logic;
    s_axi_awvalid : in  std_logic;
    s_axi_awaddr  : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);

    s_axi_wready : out std_logic;
    s_axi_wvalid : in  std_logic;
    s_axi_wdata  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    s_axi_wstrb  : in  std_logic_vector((DATA_WIDTH/8)-1 downto 0);

    s_axi_bready : in  std_logic;
    s_axi_bvalid : out std_logic;
    s_axi_bresp  : out std_logic_vector(1 downto 0);

    s_axi_arready : out std_logic;
    s_axi_arvalid : in  std_logic;
    s_axi_araddr  : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);

    s_axi_rready : in  std_logic;
    s_axi_rvalid : out std_logic;
    s_axi_rdata  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    s_axi_rresp  : out std_logic_vector(1 downto 0);

    engine_running : in std_logic;

    new_drawing_ready : in  std_logic;
    new_drawing_valid : out std_logic;
    new_drawing       : out drawing_record
    );
end entity draw_assist_registers;

architecture rtl of draw_assist_registers is
  signal control_full    : std_logic;
  signal control_running : std_logic;

  alias write_register_select : std_logic_vector(REGISTER_BITS-1 downto 0) is s_axi_awaddr(REGISTER_BITS+1 downto 2);
  alias read_register_select  : std_logic_vector(REGISTER_BITS-1 downto 0) is s_axi_araddr(REGISTER_BITS+1 downto 2);

  signal write_in_flight : std_logic;
  signal read_in_flight  : std_logic;

  signal s_axi_drawing : drawing_record;

  signal da_fifo_we       : std_logic;
  signal da_fifo_data_in  : std_logic_vector(DRAWING_RECORD_BITS-1 downto 0);
  signal da_fifo_wrfull   : std_logic;
  signal da_fifo_wrempty  : std_logic;
  signal da_fifo_rd       : std_logic;
  signal da_fifo_data_out : std_logic_vector(DRAWING_RECORD_BITS-1 downto 0);
  signal da_fifo_rdempty  : std_logic;
begin
  control_full    <= da_fifo_wrfull;
  control_running <= (not da_fifo_wrempty) or engine_running;


  ------------------------------------------------------------------------------
  -- AXI4-Lite Slave
  ------------------------------------------------------------------------------
  s_axi_awready <= (not write_in_flight) and s_axi_wvalid;
  s_axi_wready  <= (not write_in_flight) and s_axi_awvalid;
  s_axi_arready <= (not read_in_flight);
  process (clk) is
  begin
    if rising_edge(clk) then
      if s_axi_bready = '1' then
        write_in_flight <= '0';
      end if;
      if s_axi_rready = '1' then
        read_in_flight <= '0';
      end if;

      if s_axi_awvalid = '1' and s_axi_wvalid = '1' and write_in_flight = '0' then
        write_in_flight <= '1';
        if or_slv(s_axi_wstrb) = '1' then
          case write_register_select is
            when INPUT_ADDRESS_REG =>
              s_axi_drawing.input_address <= unsigned(s_axi_wdata);
            when INPUT_COLUMNS_MINUS1_REG =>
              s_axi_drawing.input_columns_minus1 <= unsigned(s_axi_wdata);
            when INPUT_ROWS_REG =>
              s_axi_drawing.input_rows      <= unsigned(s_axi_wdata(15 downto 0));
              if s_axi_wdata(15 downto 0) = std_logic_vector(to_unsigned(0, 16)) then
                s_axi_drawing.input_is_scalar <= '1';
              else
                s_axi_drawing.input_is_scalar <= '0';
              end if;
            when INPUT_STRIDE_REG =>
              s_axi_drawing.input_stride <= signed(s_axi_wdata);
            when OUTPUT_ADDRESS_REG =>
              s_axi_drawing.output_address <= unsigned(s_axi_wdata);
            when OUTPUT_COLUMNS_MINUS1_REG =>
              s_axi_drawing.output_columns_minus1 <= unsigned(s_axi_wdata);
            when OUTPUT_ROWS_REG =>
              s_axi_drawing.output_rows <= unsigned(s_axi_wdata(15 downto 0));
            when OUTPUT_STRIDE_REG =>
              s_axi_drawing.output_stride <= signed(s_axi_wdata);
            when others => null;
          end case;
        end if;
      end if;

      if s_axi_arvalid = '1' and read_in_flight = '0' then
        read_in_flight                   <= '1';
        s_axi_rdata                      <= (others => '0');
        s_axi_rdata(CONTROL_FULL_BIT)    <= control_full;
        s_axi_rdata(CONTROL_RUNNING_BIT) <= control_running;
      end if;

      if resetn = '0' then
        write_in_flight <= '0';
        read_in_flight  <= '0';
      end if;
    end if;
  end process;
  s_axi_bvalid <= write_in_flight;
  s_axi_bresp  <= (others => '0');
  s_axi_rvalid <= read_in_flight;
  s_axi_rresp  <= (others => '0');


  ------------------------------------------------------------------------------
  -- Drawing FIFO
  ------------------------------------------------------------------------------
  da_fifo_we <=
    s_axi_awvalid and s_axi_wvalid and (not write_in_flight) and s_axi_wdata(CONTROL_START_BIT)
    when write_register_select = CONTROL_REGISTER_REG else
    '0';
  da_fifo_data_in <= drawing_record_to_slv(s_axi_drawing);
  da_fifo : entity work.draw_assist_fifo_sync
    generic map (
      WIDTH => DRAWING_RECORD_BITS,
      DEPTH => 64                       --uSRAM
      )
    port map (
      clk    => clk,
      resetn => resetn,

      we      => da_fifo_we,
      data_in => da_fifo_data_in,
      wrfull  => da_fifo_wrfull,
      wrempty => da_fifo_wrempty,

      rd       => da_fifo_rd,
      data_out => da_fifo_data_out,
      rdempty  => da_fifo_rdempty
      );
  da_fifo_rd        <= new_drawing_ready and (not da_fifo_rdempty);
  new_drawing_valid <= not da_fifo_rdempty;
  new_drawing       <= slv_to_drawing_record(da_fifo_data_out);

end architecture rtl;
