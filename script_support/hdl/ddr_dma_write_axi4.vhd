library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.ddr_dma_pkg.all;

entity ddr_dma_write_axi4 is
  generic (
    DATA_WIDTH          : positive := 8;
    ADDRESS_WIDTH       : positive := 32;
    MAX_BURST_LENGTH    : positive := 256;
    MAX_LINE_SIZE       : positive := 1920;
    STRIDE_ISBYTES      : natural := 0;

    AXI_ADDRESS_WIDTH       : positive := 32;
    AXI_DATA_WIDTH          : positive := 512;
    AXI_ID_WIDTH            : positive := 1
    );
  port (
    -- Video Native Target Interface
    clk        : in std_logic;
    resetn     : in std_logic;

    -- Configuration for R, G, B Channels
    config_frame_address_r_i   : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    config_frame_address_g_i   : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    config_frame_address_b_i   : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    config_line_stride_i       : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);

    target_data_valid_i    : in std_logic;
    target_frame_sync_i    : in std_logic;
    target_data_r_i          : in std_logic_vector(DATA_WIDTH-1 downto 0);
    target_data_g_i          : in std_logic_vector(DATA_WIDTH-1 downto 0);
    target_data_b_i          : in std_logic_vector(DATA_WIDTH-1 downto 0);

    -- Memory-Mapped Initiators
    aclk            : in std_logic;
    aresetn         : in std_logic;

    AWID    : out std_logic_vector(AXI_ID_WIDTH+2-1 downto 0);
    AWADDR  : out std_logic_vector(AXI_ADDRESS_WIDTH-1 downto 0);
    AWLEN   : out std_logic_vector(7 downto 0);
    AWSIZE  : out std_logic_vector(2 downto 0);
    AWBURST : out std_logic_vector(1 downto 0);
    AWCACHE : out std_logic_vector(3 downto 0);
    AWPROT  : out std_logic_vector(2 downto 0);
    AWVALID : out std_logic;
    AWREADY : in  std_logic;
      
    WSTRB  : out std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
    WVALID : out std_logic;
    WLAST  : out std_logic;
    WDATA  : out std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    WREADY : in  std_logic;
      
    BID    : in  std_logic_vector(AXI_ID_WIDTH+2-1 downto 0) := (others => '-');
    BRESP  : in  std_logic_vector(1 downto 0);
    BVALID : in  std_logic;
    BREADY : out std_logic;
      
    ARID    : out std_logic_vector(AXI_ID_WIDTH+2-1 downto 0);
    ARADDR  : out std_logic_vector(AXI_ADDRESS_WIDTH-1 downto 0);
    ARLEN   : out std_logic_vector(7 downto 0);
    ARSIZE  : out std_logic_vector(2 downto 0);
    ARBURST : out std_logic_vector(1 downto 0);
    ARCACHE : out std_logic_vector(3 downto 0);
    ARPROT  : out std_logic_vector(2 downto 0);
    ARVALID : out std_logic;
    ARREADY : in  std_logic;
      
    RID    : in  std_logic_vector(AXI_ID_WIDTH+2-1 downto 0) := (others => '-');
    RDATA  : in  std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
    RRESP  : in  std_logic_vector(1 downto 0);
    RLAST  : in  std_logic;
    RVALID : in  std_logic;
    RREADY : out std_logic
  );
end entity ddr_dma_write_axi4;

architecture rtl of ddr_dma_write_axi4 is

  -- Signals for R Channel
  signal initiator_address_r            : std_logic_vector(AXI_ADDRESS_WIDTH-1 downto 0);
  signal initiator_burstlength_r        : std_logic_vector(7 downto 0);
  signal initiator_byteenable_r         : std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
  signal initiator_requestvalid_r       : std_logic;
  signal initiator_waitrequest_r        : std_logic;
  signal initiator_writedata_r          : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal initiator_writelast_r          : std_logic;
  signal initiator_writecomplete_r      : std_logic;

  -- Signals for G Channel
  signal initiator_address_g            : std_logic_vector(AXI_ADDRESS_WIDTH-1 downto 0);
  signal initiator_burstlength_g        : std_logic_vector(7 downto 0);
  signal initiator_byteenable_g         : std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
  signal initiator_requestvalid_g       : std_logic;
  signal initiator_waitrequest_g        : std_logic;
  signal initiator_writedata_g          : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal initiator_writelast_g          : std_logic;
  signal initiator_writecomplete_g      : std_logic;

  -- Signals for B Channel
  signal initiator_address_b            : std_logic_vector(AXI_ADDRESS_WIDTH-1 downto 0);
  signal initiator_burstlength_b        : std_logic_vector(7 downto 0);
  signal initiator_byteenable_b         : std_logic_vector(AXI_DATA_WIDTH/8-1 downto 0);
  signal initiator_requestvalid_b       : std_logic;
  signal initiator_waitrequest_b        : std_logic;
  signal initiator_writedata_b          : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal initiator_writelast_b          : std_logic;
  signal initiator_writecomplete_b      : std_logic;

  -- Signals for OIMM Mux
  signal target_address            : std_logic_vector((3*AXI_ADDRESS_WIDTH)-1 downto 0);
  signal target_burstlength_minus1 : std_logic_vector((3*8)-1 downto 0);
  signal target_byteenable         : std_logic_vector((3*(AXI_DATA_WIDTH/8))-1 downto 0);
  signal target_requestvalid       : std_logic_vector(2 downto 0);
  signal target_requestvalid_id    : std_logic_vector((3*AXI_ID_WIDTH)-1 downto 0);
  signal target_readnotwrite       : std_logic_vector(2 downto 0);
  signal target_writedata          : std_logic_vector((3*AXI_DATA_WIDTH)-1 downto 0);
  signal target_writelast          : std_logic_vector(2 downto 0);
  signal target_readdatavalid      : std_logic_vector(2 downto 0);
  signal target_readdatavalid_id   : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal target_readdata           : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal target_readlast           : std_logic;
  signal target_writecomplete      : std_logic_vector(2 downto 0);
  signal target_writecomplete_id   : std_logic_vector(AXI_ID_WIDTH-1 downto 0);
  signal target_waitrequest        : std_logic_vector(2 downto 0);

  signal initiator_address_mux            : std_logic_vector(AXI_ADDRESS_WIDTH-1 downto 0);
  signal initiator_burstlength_minus1_mux : std_logic_vector(8-1 downto 0);
  signal initiator_byteenable_mux         : std_logic_vector((AXI_DATA_WIDTH/8)-1 downto 0);
  signal initiator_requestvalid_mux       : std_logic;
  signal initiator_requestvalid_id_mux    : std_logic_vector(AXI_ID_WIDTH+log2(3)-1 downto 0);
  signal initiator_readnotwrite_mux       : std_logic;
  signal initiator_writedata_mux          : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal initiator_writelast_mux          : std_logic;
  signal initiator_readdatavalid_mux      : std_logic;
  signal initiator_readdatavalid_id_mux   : std_logic_vector(AXI_ID_WIDTH+log2(3)-1 downto 0);
  signal initiator_readdata_mux           : std_logic_vector(AXI_DATA_WIDTH-1 downto 0);
  signal initiator_readlast_mux           : std_logic;
  signal initiator_writecomplete_mux      : std_logic;
  signal initiator_writecomplete_id_mux   : std_logic_vector(AXI_ID_WIDTH+log2(3)-1 downto 0);
  signal initiator_waitrequest_mux        : std_logic;

begin

  ------------------------------------------------------------------------------------------------
  -- Write Controller for R Channel
  ------------------------------------------------------------------------------------------------
  ddr_dma_write_r : entity work.ddr_dma_write
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
      -- Video Native Target Interface
      clk      => clk,
      resetn   => resetn,
  
      config_frame_address_i  => config_frame_address_r_i,
      config_line_stride_i    => config_line_stride_i,

      target_data_i          => target_data_r_i,
      target_data_valid_i    => target_data_valid_i,
      target_frame_sync_i    => target_frame_sync_i,
  
      -- Memory-Mapped Initiators
      aclk     => aclk,
      aresetn  => aresetn,
      initiator_waitrequest_i        => initiator_waitrequest_r,
      initiator_requestvalid_o       => initiator_requestvalid_r,
      initiator_address_o            => initiator_address_r,
      initiator_burstlength_o        => initiator_burstlength_r,
      initiator_writedata_o          => initiator_writedata_r,
      initiator_byteenable_o         => initiator_byteenable_r,
      initiator_writelast_o          => initiator_writelast_r,
      initiator_writecomplete_i      => initiator_writecomplete_r
      );

  ------------------------------------------------------------------------------------------------
  -- Write Controller for G Channel
  ------------------------------------------------------------------------------------------------
  ddr_dma_write_g : entity work.ddr_dma_write
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
      -- Video Native Target Interface
      clk      => clk,
      resetn   => resetn,

      config_frame_address_i  => config_frame_address_g_i,
      config_line_stride_i    => config_line_stride_i,

      target_data_i          => target_data_g_i,
      target_data_valid_i    => target_data_valid_i,
      target_frame_sync_i    => target_frame_sync_i,

      -- Memory-Mapped Initiators
      aclk     => aclk,
      aresetn  => aresetn,
      initiator_waitrequest_i        => initiator_waitrequest_g,
      initiator_requestvalid_o       => initiator_requestvalid_g,
      initiator_address_o            => initiator_address_g,
      initiator_burstlength_o        => initiator_burstlength_g,
      initiator_writedata_o          => initiator_writedata_g,
      initiator_byteenable_o         => initiator_byteenable_g,
      initiator_writelast_o          => initiator_writelast_g,
      initiator_writecomplete_i      => initiator_writecomplete_g
      );

  ------------------------------------------------------------------------------------------------
  -- Write Controller for B Channel
  ------------------------------------------------------------------------------------------------
  ddr_dma_write_b : entity work.ddr_dma_write
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
      -- Video Native Target Interface
      clk      => clk,
      resetn   => resetn,

      config_frame_address_i  => config_frame_address_b_i,
      config_line_stride_i    => config_line_stride_i,

      target_data_i          => target_data_b_i,
      target_data_valid_i    => target_data_valid_i,
      target_frame_sync_i    => target_frame_sync_i,

      -- Memory-Mapped Initiators
      aclk     => aclk,
      aresetn  => aresetn,
      initiator_waitrequest_i        => initiator_waitrequest_b,
      initiator_requestvalid_o       => initiator_requestvalid_b,
      initiator_address_o            => initiator_address_b,
      initiator_burstlength_o        => initiator_burstlength_b,
      initiator_writedata_o          => initiator_writedata_b,
      initiator_byteenable_o         => initiator_byteenable_b,
      initiator_writelast_o          => initiator_writelast_b,
      initiator_writecomplete_i      => initiator_writecomplete_b
      );

target_address <= initiator_address_r & initiator_address_g & initiator_address_b;
target_burstlength_minus1 <= initiator_burstlength_r & initiator_burstlength_g & initiator_burstlength_b;
target_byteenable <= initiator_byteenable_r & initiator_byteenable_g & initiator_byteenable_b;
target_requestvalid <= initiator_requestvalid_r & initiator_requestvalid_g & initiator_requestvalid_b;

target_requestvalid_id <= (others => '0');
target_readnotwrite <= (others => '0');

target_writedata <= initiator_writedata_r & initiator_writedata_g & initiator_writedata_b;
target_writelast <= initiator_writelast_r & initiator_writelast_g & initiator_writelast_b;

initiator_waitrequest_r <= target_waitrequest(2);
initiator_waitrequest_g <= target_waitrequest(1);
initiator_waitrequest_b <= target_waitrequest(0);
initiator_writecomplete_r <= target_writecomplete(2);
initiator_writecomplete_g <= target_writecomplete(1);
initiator_writecomplete_b <= target_writecomplete(0);
  ------------------------------------------------------------------------------------------------
  -- OIMM Mux Instance
  ------------------------------------------------------------------------------------------------
  oimm_mux_inst : entity work.ddr_dma_oimm_mux
    generic map (
      ADDRESS_WIDTH    => AXI_ADDRESS_WIDTH,
      DATA_WIDTH       => AXI_DATA_WIDTH,
      LOG2_BURSTLENGTH => 8,  -- Assuming burst length is 256 (log2(256) = 8)

      TARGET_ID_BITS => AXI_ID_WIDTH,

      TARGETS => 3  -- Three targets: R, G, B
      )
    port map (
      clk    => aclk,
      resetn => aresetn,

      target_address            => target_address,
      target_burstlength_minus1 => target_burstlength_minus1,
      target_byteenable         => target_byteenable,
      target_requestvalid       => target_requestvalid,
      target_requestvalid_id    => target_requestvalid_id,
      target_readnotwrite       => target_readnotwrite,
      target_writedata          => target_writedata,
      target_writelast          => target_writelast,
      target_readdatavalid      => open,
      target_readdatavalid_id   => open,
      target_readdata           => open,
      target_readlast           => open,
      target_writecomplete      => target_writecomplete,
      target_writecomplete_id   => open,
      target_waitrequest        => target_waitrequest,

      initiator_address            => initiator_address_mux,
      initiator_burstlength_minus1 => initiator_burstlength_minus1_mux,
      initiator_byteenable         => initiator_byteenable_mux,
      initiator_requestvalid       => initiator_requestvalid_mux,
      initiator_requestvalid_id    => initiator_requestvalid_id_mux,
      initiator_readnotwrite       => initiator_readnotwrite_mux,
      initiator_writedata          => initiator_writedata_mux,
      initiator_writelast          => initiator_writelast_mux,
      initiator_readdatavalid      => initiator_readdatavalid_mux,
      initiator_readdatavalid_id   => initiator_readdatavalid_id_mux,
      initiator_readdata           => initiator_readdata_mux,
      initiator_readlast           => initiator_readlast_mux,
      initiator_writecomplete      => initiator_writecomplete_mux,
      initiator_writecomplete_id   => initiator_writecomplete_id_mux,
      initiator_waitrequest        => initiator_waitrequest_mux
      );

  ------------------------------------------------------------------------------------------------
   -- AXI Converter
  ------------------------------------------------------------------------------------------------
  ddr_dma_to_axi : entity work.ddr_dma_to_axi
    generic map(
      ADDRESS_WIDTH            => AXI_ADDRESS_WIDTH,
      DATA_WIDTH               => AXI_DATA_WIDTH,
      LOG2_BURSTLENGTH         => 8,
      MAX_OUTSTANDING_REQUESTS => 0,
      REQUEST_REGISTER         => OFF,
      RETURN_REGISTER          => FALSE,
      ID_BITS                  => AXI_ID_WIDTH+log2(3), --AXI_ID_WIDTH,
      READ_WRITE_FENCE         => FALSE
      )
    port map(
      clk    => aclk,
      resetn => aresetn,

      oimm_address            => initiator_address_mux,
      oimm_burstlength_minus1 => initiator_burstlength_minus1_mux,
      oimm_byteenable         => initiator_byteenable_mux,
      oimm_requestvalid       => initiator_requestvalid_mux,
      oimm_requestvalid_id    => initiator_requestvalid_id_mux,
      oimm_readnotwrite       => initiator_readnotwrite_mux,
      oimm_waitrequest        => initiator_waitrequest_mux,

      oimm_writedata          => initiator_writedata_mux,
      oimm_writelast          => initiator_writelast_mux,
      oimm_writecomplete      => initiator_writecomplete_mux,
      oimm_writecomplete_id   => initiator_writecomplete_id_mux,

      oimm_readdata           => open,
      oimm_readdatavalid      => open,
      oimm_readdatavalid_id   => open,
      oimm_readlast           => open,

      -- AXI memory-mapped initiator
      AWID    => AWID,
      AWADDR  => AWADDR,
      AWLEN   => AWLEN,
      AWSIZE  => AWSIZE,
      AWBURST => AWBURST,
      AWCACHE => AWCACHE,
      AWPROT  => AWPROT,
      AWVALID => AWVALID,
      AWREADY => AWREADY,

      WSTRB  => WSTRB,
      WVALID => WVALID,
      WLAST  => WLAST,
      WDATA  => WDATA,
      WREADY => WREADY,

      BID    => BID,
      BRESP  => BRESP,
      BVALID => BVALID,
      BREADY => BREADY,

      ARID    => ARID,
      ARADDR  => ARADDR,
      ARLEN   => ARLEN,
      ARSIZE  => ARSIZE,
      ARBURST => ARBURST,
      ARCACHE => ARCACHE,
      ARPROT  => ARPROT,
      ARVALID => ARVALID,
      ARREADY => ARREADY,

      RID    => RID,
      RDATA  => RDATA,
      RRESP  => RRESP,
      RLAST  => RLAST,
      RVALID => RVALID,
      RREADY => RREADY
      );

end architecture rtl;
