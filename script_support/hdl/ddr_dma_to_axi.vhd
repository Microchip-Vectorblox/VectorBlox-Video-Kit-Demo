library ieee;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.ddr_dma_pkg.all;

-------------------------------------------------------------------------------
-- AXI initiator from OIMM initiator.
-------------------------------------------------------------------------------

entity ddr_dma_to_axi is
  generic (
    ADDRESS_WIDTH            : positive;
    DATA_WIDTH               : positive;
    LOG2_BURSTLENGTH         : positive;
    MAX_OUTSTANDING_REQUESTS : natural;
    REQUEST_REGISTER         : request_register_type;
    RETURN_REGISTER          : boolean;

    ID_BITS          : positive := 1;
    READ_WRITE_FENCE : boolean  := true
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    oimm_idle : out std_logic;

    --ORCA-internal memory-mapped target
    oimm_address            : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    oimm_burstlength_minus1 : in  std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    oimm_byteenable         : in  std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    oimm_requestvalid       : in  std_logic;
    oimm_requestvalid_id    : in  std_logic_vector(ID_BITS-1 downto 0) := (others => '-');
    oimm_readnotwrite       : in  std_logic;
    oimm_writedata          : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    oimm_writelast          : in  std_logic;
    oimm_readdata           : out std_logic_vector(DATA_WIDTH-1 downto 0);
    oimm_readdatavalid      : out std_logic;
    oimm_readdatavalid_id   : out std_logic_vector(ID_BITS-1 downto 0) := (others => '-');
    oimm_readlast           : out std_logic;
    oimm_writecomplete      : out std_logic;
    oimm_writecomplete_id   : out std_logic_vector(ID_BITS-1 downto 0) := (others => '-');
    oimm_waitrequest        : out std_logic;

    --AXI memory-mapped initiator
    AWID    : out std_logic_vector(ID_BITS-1 downto 0);
    AWADDR  : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    AWLEN   : out std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    AWSIZE  : out std_logic_vector(2 downto 0);
    AWBURST : out std_logic_vector(1 downto 0);
    AWLOCK  : out std_logic_vector(1 downto 0);
    AWCACHE : out std_logic_vector(3 downto 0);
    AWPROT  : out std_logic_vector(2 downto 0);
    AWVALID : out std_logic;
    AWREADY : in  std_logic;

    WSTRB  : out std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    WVALID : out std_logic;
    WLAST  : out std_logic;
    WDATA  : out std_logic_vector(DATA_WIDTH-1 downto 0);
    WREADY : in  std_logic;

    BID    : in  std_logic_vector(ID_BITS-1 downto 0) := (others => '-');
    BRESP  : in  std_logic_vector(1 downto 0);
    BVALID : in  std_logic;
    BREADY : out std_logic;

    ARID    : out std_logic_vector(ID_BITS-1 downto 0);
    ARADDR  : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    ARLEN   : out std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    ARSIZE  : out std_logic_vector(2 downto 0);
    ARBURST : out std_logic_vector(1 downto 0);
    ARLOCK  : out std_logic_vector(1 downto 0);
    ARCACHE : out std_logic_vector(3 downto 0);
    ARPROT  : out std_logic_vector(2 downto 0);
    ARVALID : out std_logic;
    ARREADY : in  std_logic;

    RID    : in  std_logic_vector(ID_BITS-1 downto 0) := (others => '-');
    RDATA  : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    RRESP  : in  std_logic_vector(1 downto 0);
    RLAST  : in  std_logic;
    RVALID : in  std_logic;
    RREADY : out std_logic
    );
end entity ddr_dma_to_axi;

architecture rtl of ddr_dma_to_axi is
  constant BURST_INCR : std_logic_vector(1 downto 0) := "01";
  constant CACHE_VAL  : std_logic_vector(3 downto 0) := "0011";
  constant PROT_VAL   : std_logic_vector(2 downto 0) := "000";
  constant LOCK_VAL   : std_logic_vector(1 downto 0) := "00";

  signal register_idle  : std_logic;
  signal throttler_idle : std_logic;

  signal registered_oimm_address            : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal registered_oimm_burstlength_minus1 : std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
  signal registered_oimm_byteenable         : std_logic_vector((DATA_WIDTH/8)-1 downto 0);
  signal registered_oimm_requestvalid       : std_logic;
  signal registered_oimm_requestvalid_id    : std_logic_vector(ID_BITS-1 downto 0);
  signal registered_oimm_readnotwrite       : std_logic;
  signal registered_oimm_writedata          : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal registered_oimm_writelast          : std_logic;
  signal unregistered_oimm_readdata         : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal unregistered_oimm_readdatavalid    : std_logic;
  signal unregistered_oimm_readdatavalid_id : std_logic_vector(ID_BITS-1 downto 0);
  signal unregistered_oimm_readlast         : std_logic;
  signal unregistered_oimm_waitrequest      : std_logic;

  signal unthrottled_oimm_readdatavalid : std_logic;
  signal unthrottled_oimm_readlast      : std_logic;
  signal unthrottled_oimm_writecomplete : std_logic;
  signal unthrottled_oimm_waitrequest   : std_logic;
  signal throttled_oimm_requestvalid    : std_logic;

  signal AWVALID_signal : std_logic;
  signal WVALID_signal  : std_logic;
  signal aw_sending     : std_logic;
  signal aw_sent        : std_logic;
  signal w_sending      : std_logic;
  signal w_sent         : std_logic;
begin
  oimm_idle <= register_idle and throttler_idle;

  -----------------------------------------------------------------------------
  -- Optional OIMM register
  -----------------------------------------------------------------------------
  optional_oimm_register : entity work.ddr_dma_oimm_register
    generic map (
      ADDRESS_WIDTH    => ADDRESS_WIDTH,
      DATA_WIDTH       => DATA_WIDTH,
      LOG2_BURSTLENGTH => LOG2_BURSTLENGTH,
      REQUEST_REGISTER => REQUEST_REGISTER,
      RETURN_REGISTER  => RETURN_REGISTER,

      ID_BITS => ID_BITS
      )
    port map (
      clk    => clk,
      resetn => resetn,

      register_idle => register_idle,

      --ORCA-internal memory-mapped target
      target_oimm_address            => oimm_address,
      target_oimm_burstlength_minus1 => oimm_burstlength_minus1,
      target_oimm_byteenable         => oimm_byteenable,
      target_oimm_requestvalid       => oimm_requestvalid,
      target_oimm_requestvalid_id    => oimm_requestvalid_id,
      target_oimm_readnotwrite       => oimm_readnotwrite,
      target_oimm_writedata          => oimm_writedata,
      target_oimm_writelast          => oimm_writelast,
      target_oimm_readdata           => oimm_readdata,
      target_oimm_readdatavalid      => oimm_readdatavalid,
      target_oimm_readdatavalid_id   => oimm_readdatavalid_id,
      target_oimm_readlast           => oimm_readlast,
      target_oimm_waitrequest        => oimm_waitrequest,

      --ORCA-internal memory-mapped initiator
      initiator_oimm_address            => registered_oimm_address,
      initiator_oimm_burstlength_minus1 => registered_oimm_burstlength_minus1,
      initiator_oimm_byteenable         => registered_oimm_byteenable,
      initiator_oimm_requestvalid       => registered_oimm_requestvalid,
      initiator_oimm_requestvalid_id    => registered_oimm_requestvalid_id,
      initiator_oimm_readnotwrite       => registered_oimm_readnotwrite,
      initiator_oimm_writedata          => registered_oimm_writedata,
      initiator_oimm_writelast          => registered_oimm_writelast,
      initiator_oimm_readdata           => unregistered_oimm_readdata,
      initiator_oimm_readdatavalid      => unregistered_oimm_readdatavalid,
      initiator_oimm_readdatavalid_id   => unregistered_oimm_readdatavalid_id,
      initiator_oimm_readlast           => unregistered_oimm_readlast,
      initiator_oimm_waitrequest        => unregistered_oimm_waitrequest
      );

  -----------------------------------------------------------------------------
  -- Optional OIMM request throttler
  -----------------------------------------------------------------------------
  request_throttler : entity work.ddr_dma_oimm_throttler
    generic map (
      MAX_OUTSTANDING_REQUESTS => MAX_OUTSTANDING_REQUESTS,
      READ_WRITE_FENCE         => READ_WRITE_FENCE  --Note AXI lacks intra-channel ordering
      )
    port map (
      clk    => clk,
      resetn => resetn,

      throttler_idle => throttler_idle,

      --ORCA-internal memory-mapped target
      target_oimm_requestvalid => registered_oimm_requestvalid,
      target_oimm_readnotwrite => registered_oimm_readnotwrite,
      target_oimm_writelast    => registered_oimm_writelast,
      target_oimm_waitrequest  => unregistered_oimm_waitrequest,

      --ORCA-internal memory-mapped initiator
      initiator_oimm_requestvalid  => throttled_oimm_requestvalid,
      initiator_oimm_readdatavalid => unthrottled_oimm_readdatavalid,
      initiator_oimm_readlast      => unthrottled_oimm_readlast,
      initiator_oimm_writecomplete => unthrottled_oimm_writecomplete,
      initiator_oimm_waitrequest   => unthrottled_oimm_waitrequest
      );


  -----------------------------------------------------------------------------
  -- OIMM to AXI logic
  -----------------------------------------------------------------------------
  unthrottled_oimm_readdatavalid <= RVALID;
  unthrottled_oimm_readlast      <= RLAST;
  unthrottled_oimm_writecomplete <= BVALID;
  oimm_writecomplete             <= BVALID;  --Bypass register
  oimm_writecomplete_id          <= BID;

  unregistered_oimm_readdata         <= RDATA;
  unregistered_oimm_readdatavalid    <= RVALID;
  unregistered_oimm_readdatavalid_id <= RID;
  unregistered_oimm_readdatavalid    <= RVALID;
  unregistered_oimm_readlast         <= RLAST;

  unthrottled_oimm_waitrequest <= (not ARREADY) when registered_oimm_readnotwrite = '1' else
                                  (((not AWREADY) and (not aw_sent) and (registered_oimm_writelast or w_sent)) or
                                   ((not WREADY) and (not w_sent)));

  AWID           <= registered_oimm_requestvalid_id;
  AWADDR         <= registered_oimm_address;
  AWLEN          <= registered_oimm_burstlength_minus1;
  AWSIZE         <= std_logic_vector(to_unsigned(log2(DATA_WIDTH/8), 3));
  AWBURST        <= BURST_INCR;
  AWLOCK         <= LOCK_VAL;
  AWCACHE        <= CACHE_VAL;
  AWPROT         <= PROT_VAL;
  AWVALID_signal <= (throttled_oimm_requestvalid and (not registered_oimm_readnotwrite)) and (not aw_sent);
  AWVALID        <= AWVALID_signal;
  WSTRB          <= registered_oimm_byteenable;
  WVALID_signal  <= (throttled_oimm_requestvalid and (not registered_oimm_readnotwrite)) and (not w_sent);
  WVALID         <= WVALID_signal;
  WLAST          <= registered_oimm_writelast;
  WDATA          <= registered_oimm_writedata;
  BREADY         <= '1';

  ARID    <= registered_oimm_requestvalid_id;
  ARADDR  <= registered_oimm_address;
  ARLEN   <= registered_oimm_burstlength_minus1;
  ARSIZE  <= std_logic_vector(to_unsigned(log2(DATA_WIDTH/8), 3));
  ARBURST <= BURST_INCR;
  ARLOCK  <= LOCK_VAL;
  ARCACHE <= CACHE_VAL;
  ARPROT  <= PROT_VAL;
  ARVALID <= registered_oimm_readnotwrite and throttled_oimm_requestvalid;
  RREADY  <= '1';

  aw_sending <= AWVALID_signal and AWREADY;
  w_sending  <= WVALID_signal and registered_oimm_writelast and WREADY;
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
end architecture;
