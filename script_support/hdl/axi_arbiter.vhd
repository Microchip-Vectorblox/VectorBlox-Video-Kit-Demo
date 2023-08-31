library IEEE;
use IEEE.std_logic_1164.all;


entity axi_arbiter is
  generic (
    DATA_WIDTH : integer := 256;
    ADDR_WIDTH : integer := 32;
    S_ID_WIDTH : integer := 7
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    s_besteffort_awaddr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    s_besteffort_awvalid : in  std_logic;
    s_besteffort_awready : out std_logic;
    s_besteffort_awid    : in  std_logic_vector(S_ID_WIDTH-1 downto 0);
    s_besteffort_awlen   : in  std_logic_vector(7 downto 0);
    s_besteffort_awsize  : in  std_logic_vector(2 downto 0);
    s_besteffort_awburst : in  std_logic_vector(1 downto 0);
    s_besteffort_wdata   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    s_besteffort_wstrb   : in  std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    s_besteffort_wvalid  : in  std_logic;
    s_besteffort_wlast   : in  std_logic;
    s_besteffort_wready  : out std_logic;
    s_besteffort_bready  : in  std_logic;
    s_besteffort_bresp   : out std_logic_vector(1 downto 0);
    s_besteffort_bvalid  : out std_logic;
    s_besteffort_bid     : out std_logic_vector(S_ID_WIDTH-1 downto 0);
    s_besteffort_araddr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    s_besteffort_arvalid : in  std_logic;
    s_besteffort_arready : out std_logic;
    s_besteffort_arid    : in  std_logic_vector(S_ID_WIDTH-1 downto 0);
    s_besteffort_arlen   : in  std_logic_vector(7 downto 0);
    s_besteffort_arsize  : in  std_logic_vector(2 downto 0);
    s_besteffort_arburst : in  std_logic_vector(1 downto 0);
    s_besteffort_rready  : in  std_logic;
    s_besteffort_rdata   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    s_besteffort_rresp   : out std_logic_vector(1 downto 0);
    s_besteffort_rvalid  : out std_logic;
    s_besteffort_rlast   : out std_logic;
    s_besteffort_rid     : out std_logic_vector(S_ID_WIDTH-1 downto 0);

    s_realtime_awaddr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    s_realtime_awvalid : in  std_logic;
    s_realtime_awready : out std_logic;
    s_realtime_awid    : in  std_logic_vector(S_ID_WIDTH-1 downto 0);
    s_realtime_awlen   : in  std_logic_vector(7 downto 0);
    s_realtime_awsize  : in  std_logic_vector(2 downto 0);
    s_realtime_awburst : in  std_logic_vector(1 downto 0);
    s_realtime_wdata   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    s_realtime_wstrb   : in  std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    s_realtime_wvalid  : in  std_logic;
    s_realtime_wlast   : in  std_logic;
    s_realtime_wready  : out std_logic;
    s_realtime_bready  : in  std_logic;
    s_realtime_bresp   : out std_logic_vector(1 downto 0);
    s_realtime_bvalid  : out std_logic;
    s_realtime_bid     : out std_logic_vector(S_ID_WIDTH-1 downto 0);
    s_realtime_araddr  : in  std_logic_vector(ADDR_WIDTH-1 downto 0);
    s_realtime_arvalid : in  std_logic;
    s_realtime_arready : out std_logic;
    s_realtime_arid    : in  std_logic_vector(S_ID_WIDTH-1 downto 0);
    s_realtime_arlen   : in  std_logic_vector(7 downto 0);
    s_realtime_arsize  : in  std_logic_vector(2 downto 0);
    s_realtime_arburst : in  std_logic_vector(1 downto 0);
    s_realtime_rready  : in  std_logic;
    s_realtime_rdata   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    s_realtime_rresp   : out std_logic_vector(1 downto 0);
    s_realtime_rvalid  : out std_logic;
    s_realtime_rlast   : out std_logic;
    s_realtime_rid     : out std_logic_vector(S_ID_WIDTH-1 downto 0);

    m_axi_arready : in  std_logic;
    m_axi_arvalid : out std_logic;
    m_axi_araddr  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    m_axi_arlen   : out std_logic_vector(7 downto 0);
    m_axi_arsize  : out std_logic_vector(2 downto 0);
    m_axi_arburst : out std_logic_vector(1 downto 0);
    m_axi_arprot  : out std_logic_vector(2 downto 0);
    m_axi_arcache : out std_logic_vector(3 downto 0);
    m_axi_arid    : out std_logic_vector(S_ID_WIDTH downto 0);
    m_axi_rready  : out std_logic;
    m_axi_rvalid  : in  std_logic;
    m_axi_rdata   : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    m_axi_rresp   : in  std_logic_vector(1 downto 0);
    m_axi_rlast   : in  std_logic;
    m_axi_rid     : in  std_logic_vector(S_ID_WIDTH downto 0);
    m_axi_awready : in  std_logic;
    m_axi_awvalid : out std_logic;
    m_axi_awaddr  : out std_logic_vector(ADDR_WIDTH-1 downto 0);
    m_axi_awlen   : out std_logic_vector(7 downto 0);
    m_axi_awsize  : out std_logic_vector(2 downto 0);
    m_axi_awburst : out std_logic_vector(1 downto 0);
    m_axi_awprot  : out std_logic_vector(2 downto 0);
    m_axi_awcache : out std_logic_vector(3 downto 0);
    m_axi_awid    : out std_logic_vector(S_ID_WIDTH downto 0);
    m_axi_wready  : in  std_logic;
    m_axi_wvalid  : out std_logic;
    m_axi_wdata   : out std_logic_vector(DATA_WIDTH-1 downto 0);
    m_axi_wstrb   : out std_logic_vector((DATA_WIDTH)/8 - 1 downto 0);
    m_axi_wlast   : out std_logic;
    m_axi_bready  : out std_logic;
    m_axi_bvalid  : in  std_logic;
    m_axi_bresp   : in  std_logic_vector(1 downto 0);
    m_axi_bid     : in  std_logic_vector(S_ID_WIDTH downto 0)
    );
end entity axi_arbiter;

architecture rtl of axi_arbiter is
  signal m_axi_arvalid_buffer : std_logic;
  signal m_axi_awvalid_buffer : std_logic;
  signal m_axi_wvalid_buffer  : std_logic;
  signal m_axi_wlast_buffer   : std_logic;

  signal besteffort_request : std_logic;
  signal realtime_request   : std_logic;

  signal ar_besteffort_select : std_logic;
  signal ar_realtime_select   : std_logic;
  signal mid_ar               : std_logic;

  signal waw_besteffort_select : std_logic;
  signal waw_realtime_select   : std_logic;
  signal mid_waw               : std_logic;
  signal w_done                : std_logic;
  signal aw_done               : std_logic;
begin
  m_axi_arvalid <= m_axi_arvalid_buffer;
  m_axi_awvalid <= m_axi_awvalid_buffer;
  m_axi_wvalid  <= m_axi_wvalid_buffer;
  m_axi_wlast   <= m_axi_wlast_buffer;

  besteffort_request <=
    s_besteffort_arvalid or
    s_besteffort_awvalid or
    s_besteffort_wvalid or
    (mid_ar and
     ar_besteffort_select and
     (not (m_axi_arvalid_buffer and m_axi_arready))) or
    (mid_waw and
     waw_besteffort_select and
     (not ((aw_done or (m_axi_awvalid_buffer and m_axi_awready)) and
           (w_done or (m_axi_wvalid_buffer and m_axi_wlast_buffer and m_axi_wready)))));
  realtime_request <=
    s_realtime_arvalid or
    s_realtime_awvalid or
    s_realtime_wvalid or
    (mid_ar and
     ar_realtime_select and
     (not (m_axi_arvalid_buffer and m_axi_arready))) or
    (mid_waw and
     waw_realtime_select and
     (not ((aw_done or (m_axi_awvalid_buffer and m_axi_awready)) and
           (w_done or (m_axi_wvalid_buffer and m_axi_wlast_buffer and m_axi_wready)))));

  m_axi_arvalid_buffer <= ((ar_realtime_select and s_realtime_arvalid) or
                           (ar_besteffort_select and s_besteffort_arvalid));
  s_besteffort_arready <= ar_besteffort_select and m_axi_arready;
  s_realtime_arready   <= ar_realtime_select and m_axi_arready;

  m_axi_awvalid_buffer <= (not aw_done) and ((waw_realtime_select and s_realtime_awvalid) or
                                             (waw_besteffort_select and s_besteffort_awvalid))
                          when mid_waw = '1' else
                          ((waw_realtime_select and s_realtime_awvalid) or
                           (waw_besteffort_select and s_besteffort_awvalid));
  s_besteffort_awready <= waw_besteffort_select and (not aw_done) and m_axi_awready when mid_waw = '1' else
                          waw_besteffort_select and m_axi_awready;
  s_realtime_awready <= waw_realtime_select and (not aw_done) and m_axi_awready when mid_waw = '1' else
                        waw_realtime_select and m_axi_awready;
  m_axi_wvalid_buffer <= (not w_done) and ((waw_realtime_select and s_realtime_wvalid) or
                                           (waw_besteffort_select and s_besteffort_wvalid))
                         when mid_waw = '1' else
                         ((waw_realtime_select and s_realtime_wvalid) or
                          (waw_besteffort_select and s_besteffort_wvalid));
  s_besteffort_wready <= waw_besteffort_select and (not w_done) and m_axi_wready when mid_waw = '1' else
                         waw_besteffort_select and m_axi_wready;
  s_realtime_wready <= waw_realtime_select and (not w_done) and m_axi_wready when mid_waw = '1' else
                       waw_realtime_select and m_axi_wready;


  process (clk) is
  begin
    if rising_edge(clk) then
      if m_axi_arvalid_buffer = '1' then
        mid_ar <= '1';
        if m_axi_arready = '1' then
          mid_ar               <= '0';
          ar_besteffort_select <= not (realtime_request or (not besteffort_request));
          ar_realtime_select   <= realtime_request or (not besteffort_request);
        end if;
      end if;

      if mid_ar = '0' and m_axi_arvalid_buffer = '0' then
        ar_besteffort_select <= not (realtime_request or (not besteffort_request));
        ar_realtime_select   <= realtime_request or (not besteffort_request);
      end if;

      if m_axi_awvalid_buffer = '1' then
        mid_waw <= '1';

        aw_done <= '0';
        if m_axi_awready = '1' then
          aw_done <= '1';
        end if;
      end if;

      if m_axi_wvalid_buffer = '1' then
        mid_waw <= '1';

        w_done <= '0';
        if m_axi_wlast_buffer = '1' and m_axi_wready = '1' then
          w_done <= '1';
        end if;
      end if;

      if (((w_done = '1') or (m_axi_wvalid_buffer = '1' and m_axi_wlast_buffer = '1' and m_axi_wready = '1')) and
          ((aw_done = '1') or (m_axi_awvalid_buffer = '1' and m_axi_awready = '1'))) then
        mid_waw               <= '0';
        w_done                <= '0';
        aw_done               <= '0';
        waw_besteffort_select <= not (realtime_request or (not besteffort_request));
        waw_realtime_select   <= realtime_request or (not besteffort_request);
      end if;

      if mid_waw = '0' and m_axi_wvalid_buffer = '0' and m_axi_awvalid_buffer = '0' then
        waw_besteffort_select <= not (realtime_request or (not besteffort_request));
        waw_realtime_select   <= realtime_request or (not besteffort_request);
      end if;

      if resetn = '0' then
        mid_ar                <= '0';
        mid_waw               <= '0';
        w_done                <= '0';
        aw_done               <= '0';
        ar_besteffort_select  <= '0';
        ar_realtime_select    <= '0';
        waw_besteffort_select <= '0';
        waw_realtime_select   <= '0';
      end if;
    end if;
  end process;

  m_axi_awaddr                      <= s_realtime_awaddr  when waw_realtime_select = '1'   else s_besteffort_awaddr;
  m_axi_awid(S_ID_WIDTH)            <= waw_realtime_select;
  m_axi_awid(S_ID_WIDTH-1 downto 0) <= s_realtime_awid    when waw_realtime_select = '1'   else s_besteffort_awid;
  m_axi_awlen                       <= s_realtime_awlen   when waw_realtime_select = '1'   else s_besteffort_awlen;
  m_axi_awsize                      <= s_realtime_awsize  when waw_realtime_select = '1'   else s_besteffort_awsize;
  m_axi_awburst                     <= s_realtime_awburst when waw_realtime_select = '1'   else s_besteffort_awburst;
  m_axi_wdata                       <= s_realtime_wdata   when waw_realtime_select = '1'   else s_besteffort_wdata;
  m_axi_wstrb                       <= s_realtime_wstrb   when waw_realtime_select = '1'   else s_besteffort_wstrb;
  m_axi_wlast_buffer                <= s_realtime_wlast   when waw_realtime_select = '1'   else s_besteffort_wlast;
  m_axi_bready                      <= s_realtime_bready  when m_axi_bid(S_ID_WIDTH) = '1' else s_besteffort_bready;
  s_besteffort_bresp                <= m_axi_bresp;
  s_realtime_bresp                  <= m_axi_bresp;
  s_besteffort_bvalid               <= m_axi_bvalid and (not m_axi_bid(S_ID_WIDTH));
  s_realtime_bvalid                 <= m_axi_bvalid and m_axi_bid(S_ID_WIDTH);
  s_besteffort_bid                  <= m_axi_bid(S_ID_WIDTH-1 downto 0);
  s_realtime_bid                    <= m_axi_bid(S_ID_WIDTH-1 downto 0);
  m_axi_araddr                      <= s_realtime_araddr  when ar_realtime_select = '1'    else s_besteffort_araddr;
  m_axi_arid(S_ID_WIDTH)            <= ar_realtime_select;
  m_axi_arid(S_ID_WIDTH-1 downto 0) <= s_realtime_arid    when ar_realtime_select = '1'    else s_besteffort_arid;
  m_axi_arlen                       <= s_realtime_arlen   when ar_realtime_select = '1'    else s_besteffort_arlen;
  m_axi_arsize                      <= s_realtime_arsize  when ar_realtime_select = '1'    else s_besteffort_arsize;
  m_axi_arburst                     <= s_realtime_arburst when ar_realtime_select = '1'    else s_besteffort_arburst;
  m_axi_rready                      <= s_realtime_rready  when m_axi_rid(S_ID_WIDTH) = '1' else s_besteffort_rready;
  s_besteffort_rdata                <= m_axi_rdata;
  s_realtime_rdata                  <= m_axi_rdata;
  s_besteffort_rresp                <= m_axi_rresp;
  s_realtime_rresp                  <= m_axi_rresp;
  s_besteffort_rvalid               <= m_axi_rvalid and (not m_axi_rid(S_ID_WIDTH));
  s_realtime_rvalid                 <= m_axi_rvalid and m_axi_rid(S_ID_WIDTH);
  s_besteffort_rlast                <= m_axi_rlast;
  s_realtime_rlast                  <= m_axi_rlast;
  s_besteffort_rid                  <= m_axi_rid(S_ID_WIDTH-1 downto 0);
  s_realtime_rid                    <= m_axi_rid(S_ID_WIDTH-1 downto 0);
end architecture rtl;
