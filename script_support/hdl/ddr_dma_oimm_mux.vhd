-------------------------------------------------------------------------------
-- Multiple OIMM targets to one initiator
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
--use work.fabric_inference_accelerator_isa_pkg.all;
--use work.fabric_inference_accelerator_util_pkg.all;
--use work.fabric_inference_accelerator_pkg.all;
use work.ddr_dma_pkg.all;

entity ddr_dma_oimm_mux is
  generic (
    ADDRESS_WIDTH    : positive;
    DATA_WIDTH       : positive;
    LOG2_BURSTLENGTH : natural;

    TARGET_ID_BITS : natural;

    TARGETS : positive range 2 to 32
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    target_address            : in  std_logic_vector((TARGETS*ADDRESS_WIDTH)-1 downto 0);
    target_burstlength_minus1 : in  std_logic_vector((TARGETS*imax(1, LOG2_BURSTLENGTH))-1 downto 0) := (others => '0');
    target_byteenable         : in  std_logic_vector((TARGETS*(DATA_WIDTH/8))-1 downto 0);
    target_requestvalid       : in  std_logic_vector(TARGETS-1 downto 0);
    target_requestvalid_id    : in  std_logic_vector((TARGETS*imax(1, TARGET_ID_BITS))-1 downto 0)   := (others => '-');
    target_readnotwrite       : in  std_logic_vector(TARGETS-1 downto 0);
    target_writedata          : in  std_logic_vector((TARGETS*DATA_WIDTH)-1 downto 0);
    target_writelast          : in  std_logic_vector(TARGETS-1 downto 0);
    target_readdatavalid      : out std_logic_vector(TARGETS-1 downto 0);
    target_readdatavalid_id   : out std_logic_vector(imax(1, TARGET_ID_BITS)-1 downto 0)             := (others => '-');
    target_readdata           : out std_logic_vector(DATA_WIDTH-1 downto 0);
    target_readlast           : out std_logic;
    target_writecomplete      : out std_logic_vector(TARGETS-1 downto 0);
    target_writecomplete_id   : out std_logic_vector(imax(1, TARGET_ID_BITS)-1 downto 0)             := (others => '-');
    target_waitrequest        : out std_logic_vector(TARGETS-1 downto 0);

    initiator_address            : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    initiator_burstlength_minus1 : out std_logic_vector(imax(1, LOG2_BURSTLENGTH)-1 downto 0) := (others => '0');
    initiator_byteenable         : out std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    initiator_requestvalid       : out std_logic;
    initiator_requestvalid_id    : out std_logic_vector(TARGET_ID_BITS+log2(TARGETS)-1 downto 0);
    initiator_readnotwrite       : out std_logic;
    initiator_writedata          : out std_logic_vector(DATA_WIDTH-1 downto 0);
    initiator_writelast          : out std_logic;
    initiator_readdatavalid      : in  std_logic;
    initiator_readdatavalid_id   : in  std_logic_vector(TARGET_ID_BITS+log2(TARGETS)-1 downto 0);
    initiator_readdata           : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    initiator_readlast           : in  std_logic;
    initiator_writecomplete      : in  std_logic;
    initiator_writecomplete_id   : in  std_logic_vector(TARGET_ID_BITS+log2(TARGETS)-1 downto 0);
    initiator_waitrequest        : in  std_logic
    );
end entity ddr_dma_oimm_mux;

architecture rtl of ddr_dma_oimm_mux is
  constant INITIATOR_ID_BITS : positive := initiator_requestvalid_id'length;

  signal initiator_request_in_progress : std_logic;

  type address_vector is array (natural range <>) of std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal target_address_vector            : address_vector(TARGETS-1 downto 0);
  type burstlength_minus1_vector is array (natural range <>) of std_logic_vector(imax(1, LOG2_BURSTLENGTH)-1 downto 0);
  signal target_burstlength_minus1_vector : burstlength_minus1_vector(TARGETS-1 downto 0);
  type byteenable_vector is array (natural range <>) of std_logic_vector((DATA_WIDTH/8)-1 downto 0);
  signal target_byteenable_vector         : byteenable_vector(TARGETS-1 downto 0);
  type data_vector is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal target_writedata_vector          : data_vector(TARGETS-1 downto 0);

  signal target_select    : unsigned(log2(TARGETS)-1 downto 0);
  signal target_select_d1 : unsigned(log2(TARGETS)-1 downto 0);

  signal readdatavalid_select : unsigned(log2(TARGETS)-1 downto 0);
  signal writecomplete_select : unsigned(log2(TARGETS)-1 downto 0);
begin
  target_select <= priority_encode_highest(target_requestvalid) when
                   initiator_request_in_progress = '0' else
                   target_select_d1;

  process (clk) is
  begin
    if rising_edge(clk) then
      if initiator_requestvalid = '1' then
        initiator_request_in_progress <= initiator_waitrequest or ((not initiator_readnotwrite) and (not initiator_writelast));
      end if;

      target_select_d1 <= target_select;

      if resetn = '0' then
        initiator_request_in_progress <= '0';
      end if;
    end if;
  end process;

  target_mux_gen : for g_target in TARGETS-1 downto 0 generate
    target_address_vector(g_target) <=
      target_address(((g_target+1)*ADDRESS_WIDTH)-1 downto g_target*ADDRESS_WIDTH);
    target_burstlength_minus1_vector(g_target) <=
      target_burstlength_minus1(((g_target+1)*imax(1, LOG2_BURSTLENGTH))-1 downto g_target*imax(1, LOG2_BURSTLENGTH));
    target_byteenable_vector(g_target) <=
      target_byteenable(((g_target+1)*(DATA_WIDTH/8))-1 downto g_target*(DATA_WIDTH/8));
    target_writedata_vector(g_target) <=
      target_writedata(((g_target+1)*DATA_WIDTH)-1 downto g_target*DATA_WIDTH);
  end generate target_mux_gen;

  initiator_address            <= target_address_vector(to_integer(target_select));
  initiator_burstlength_minus1 <= target_burstlength_minus1_vector(to_integer(target_select));
  target_id_gen : if TARGET_ID_BITS > 0 generate
    type target_id_vector is array (natural range <>) of std_logic_vector(TARGET_ID_BITS-1 downto 0);
    signal target_requestvalid_id_vector : target_id_vector(TARGETS-1 downto 0);
  begin
    target_mux_gen : for g_target in TARGETS-1 downto 0 generate
      target_requestvalid_id_vector(g_target) <=
        target_requestvalid_id(((g_target+1)*TARGET_ID_BITS)-1 downto g_target*TARGET_ID_BITS);
    end generate target_mux_gen;
    initiator_requestvalid_id(TARGET_ID_BITS-1 downto 0) <= target_requestvalid_id_vector(to_integer(target_select));

    target_readdatavalid_id <= initiator_readdatavalid_id(TARGET_ID_BITS-1 downto 0);
    target_writecomplete_id <= initiator_writecomplete_id(TARGET_ID_BITS-1 downto 0);
  end generate target_id_gen;
  initiator_requestvalid_id(INITIATOR_ID_BITS-1 downto TARGET_ID_BITS) <= std_logic_vector(target_select);
  initiator_byteenable                                                 <= target_byteenable_vector(to_integer(target_select));
  initiator_requestvalid                                               <= target_requestvalid(to_integer(target_select));
  initiator_readnotwrite                                               <= target_readnotwrite(to_integer(target_select));
  initiator_writedata                                                  <= target_writedata_vector(to_integer(target_select));
  initiator_writelast                                                  <= target_writelast(to_integer(target_select));

  readdatavalid_select <= unsigned(initiator_readdatavalid_id(INITIATOR_ID_BITS-1 downto TARGET_ID_BITS));
  writecomplete_select <= unsigned(initiator_writecomplete_id(INITIATOR_ID_BITS-1 downto TARGET_ID_BITS));
  target_demux_gen : for g_target in TARGETS-1 downto 0 generate
    target_readdatavalid(g_target) <=
      initiator_readdatavalid when readdatavalid_select = to_unsigned(g_target, readdatavalid_select'length) else '0';
    target_writecomplete(g_target) <=
      initiator_writecomplete when writecomplete_select = to_unsigned(g_target, writecomplete_select'length) else '0';

    target_waitrequest(g_target) <=
      initiator_waitrequest when target_select = to_unsigned(g_target, target_select'length) else '1';
  end generate target_demux_gen;
  target_readdata <= initiator_readdata;
  target_readlast <= initiator_readlast;

end architecture rtl;
