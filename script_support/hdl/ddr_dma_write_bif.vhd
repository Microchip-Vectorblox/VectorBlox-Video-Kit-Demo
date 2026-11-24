library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.ddr_dma_pkg.all;

entity ddr_dma_write_bif is
  generic (
    DATA_WIDTH          : positive := 8;
    ADDRESS_WIDTH       : positive := 32;
    MAX_BURST_LENGTH    : positive := 256;
    MAX_LINE_SIZE       : positive :=1920;
    STRIDE_ISBYTES      : natural := 0;

    AXI_ADDRESS_WIDTH       : positive := 32;
    AXI_DATA_WIDTH          : positive := 512;
    AXI_ID_WIDTH            : positive := 7
    );
  port (
    -- Video Native Target Intrface
    clk        : in std_logic;
    resetn     : in std_logic;

    config_frame_address_i   : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    --config_frame_size_i      : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    config_line_stride_i     : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    --config_line_size_i       : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);

    target_data_i          : in std_logic_vector(DATA_WIDTH-1 downto 0);
    target_data_valid_i    : in std_logic;
    target_frame_sync_i    : in std_logic;

    --Memory-Mapped Initiators
    -- Write Channel
    aclk            : in std_logic;
    aresetn         : in std_logic;

    AWREADY : in  std_logic;
    AWVALID : out std_logic;
    AWADDR  : out std_logic_vector(AXI_ADDRESS_WIDTH-1 downto 0);
    AWLEN   : out std_logic_vector(7 downto 0);

    WDATA   : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    WVALID  : out std_logic;
    BUSER   : in  std_logic
  );
end entity ddr_dma_write_bif;

architecture rtl of ddr_dma_write_bif is

  signal initiator_address            : std_logic_vector(AXI_ADDRESS_WIDTH-1 downto 0);
  signal initiator_burstlength        : std_logic_vector(7 downto 0);
  signal initiator_byteenable         : std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
  signal initiator_requestvalid       : std_logic;
  signal initiator_waitrequest        : std_logic;
  signal initiator_writedata          : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal initiator_writelast          : std_logic;
  signal initiator_writecomplete      : std_logic;

  signal WREADY : std_logic;
  signal AWVALID_signal : std_logic;
  signal WVALID_signal  : std_logic;
  signal aw_sending     : std_logic;
  signal aw_sent        : std_logic;
  signal w_sending      : std_logic;
  signal w_sent         : std_logic;

begin

  ------------------------------------------------------------------------------------------------
  -- Write Controller
  ------------------------------------------------------------------------------------------------
  ddr_dma_write : entity work.ddr_dma_write
    generic map (
      DATA_WIDTH             => DATA_WIDTH,  
      ADDRESS_WIDTH          => ADDRESS_WIDTH,
      MAX_LINE_SIZE          => MAX_LINE_SIZE,
      MAX_BURST_LENGTH       => MAX_BURST_LENGTH,
      STRIDE_ISBYTES         => STRIDE_ISBYTES,

      MEMORY_ADDRESS_WIDTH   => AXI_ADDRESS_WIDTH,
      MEMORY_DATA_WIDTH      => AXI_DATA_WIDTH
      )
    port map (
      -- Video Native Target Intrface
      clk      => clk,
      resetn   => resetn,
  
      config_frame_address_i  => config_frame_address_i,
      --config_frame_size_i     => config_frame_size_i,
      config_line_stride_i    => config_line_stride_i,
      --config_line_size_i      => config_line_size_i,
  
      target_data_i          => target_data_i,
      target_data_valid_i    => target_data_valid_i,
      target_frame_sync_i    => target_frame_sync_i,
  
      --Memory-Mapped Initiators
      aclk     => aclk,
      aresetn  => aresetn,
      initiator_waitrequest_i        => initiator_waitrequest,
      initiator_requestvalid_o       => initiator_requestvalid,
      initiator_address_o            => initiator_address,
      initiator_burstlength_o        => initiator_burstlength,
      initiator_writedata_o          => initiator_writedata,
      initiator_byteenable_o         => initiator_byteenable,
      initiator_writelast_o          => initiator_writelast,
      initiator_writecomplete_i      => initiator_writecomplete
      );

  ------------------------------------------------------------------------------------------------
   -- DDR Arbiter Write Bus Interface
  ------------------------------------------------------------------------------------------------
  initiator_waitrequest <=  (((not AWREADY) and (not aw_sent) and (initiator_writelast or w_sent)) 
                            or
                            ((not WREADY) and (not w_sent)));

  WREADY <= aw_sent;

  initiator_writecomplete <= BUSER;

  AWVALID        <= AWVALID_signal;
  AWADDR         <= initiator_address;
  AWLEN          <= initiator_burstlength;

  WDATA          <= initiator_writedata;
  WVALID         <= WVALID_signal;

  AWVALID_signal <= initiator_requestvalid and (not aw_sent);

  WVALID_signal  <= initiator_requestvalid and (not w_sent) and aw_sent;
  
  aw_sending <= AWVALID_signal and AWREADY;
  w_sending  <= WVALID_signal and initiator_writelast and WREADY;

  process (aclk) is
  begin
    if rising_edge(aclk) then
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

      if aresetn = '0' then
        aw_sent <= '0';
        w_sent  <= '0';
      end if;
    end if;
  end process;



end architecture rtl;   