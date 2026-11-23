library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

library work;
use work.ddr_dma_pkg.all;

entity ddr_dma_oimm_register is
  generic (
    ADDRESS_WIDTH    : positive;
    DATA_WIDTH       : positive;
    LOG2_BURSTLENGTH : positive := 8;
    REQUEST_REGISTER : request_register_type;
    RETURN_REGISTER  : boolean;

    --Don't connect ID if unused
    ID_BITS : positive := 1
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    register_idle : out std_logic;

    --ORCA-internal memory-mapped target
    target_oimm_address            : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    target_oimm_burstlength        : in  std_logic_vector(LOG2_BURSTLENGTH downto 0)   := (0      => '1', others => '0');
    target_oimm_burstlength_minus1 : in  std_logic_vector(LOG2_BURSTLENGTH-1 downto 0) := (others => '0');
    target_oimm_byteenable         : in  std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    target_oimm_requestvalid       : in  std_logic;
    target_oimm_requestvalid_id    : in  std_logic_vector(ID_BITS-1 downto 0)          := (others => '-');
    target_oimm_readnotwrite       : in  std_logic;
    target_oimm_writedata          : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    target_oimm_writelast          : in  std_logic                                     := '1';
    target_oimm_readdata           : out std_logic_vector(DATA_WIDTH-1 downto 0);
    target_oimm_readdatavalid      : out std_logic;
    target_oimm_readdatavalid_id   : out std_logic_vector(ID_BITS-1 downto 0)          := (others => '-');
    target_oimm_readlast           : out std_logic;
    target_oimm_waitrequest        : out std_logic;

    --ORCA-internal memory-mapped initiator
    initiator_oimm_address            : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    initiator_oimm_burstlength        : out std_logic_vector(LOG2_BURSTLENGTH downto 0);
    initiator_oimm_burstlength_minus1 : out std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    initiator_oimm_byteenable         : out std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    initiator_oimm_requestvalid       : out std_logic;
    initiator_oimm_requestvalid_id    : out std_logic_vector(ID_BITS-1 downto 0) := (others => '-');
    initiator_oimm_readnotwrite       : out std_logic;
    initiator_oimm_writedata          : out std_logic_vector(DATA_WIDTH-1 downto 0);
    initiator_oimm_writelast          : out std_logic;
    initiator_oimm_readdata           : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    initiator_oimm_readdatavalid      : in  std_logic;
    initiator_oimm_readdatavalid_id   : in  std_logic_vector(ID_BITS-1 downto 0) := (others => '-');
    initiator_oimm_readlast           : in  std_logic                            := '-';
    initiator_oimm_waitrequest        : in  std_logic
    );
end entity ddr_dma_oimm_register;

architecture rtl of ddr_dma_oimm_register is
  signal target_oimm_waitrequest_signal     : std_logic;
  signal initiator_oimm_requestvalid_signal : std_logic;
begin
  target_oimm_waitrequest     <= target_oimm_waitrequest_signal;
  initiator_oimm_requestvalid <= initiator_oimm_requestvalid_signal;
  -----------------------------------------------------------------------------
  -- Optional Memory Request Register
  -----------------------------------------------------------------------------

  --Passthrough, lowest fmax but no extra resources or added latency.
  no_request_register_gen : if REQUEST_REGISTER = OFF generate
    initiator_oimm_address             <= target_oimm_address;
    initiator_oimm_burstlength         <= target_oimm_burstlength;
    initiator_oimm_burstlength_minus1  <= target_oimm_burstlength_minus1;
    initiator_oimm_byteenable          <= target_oimm_byteenable;
    initiator_oimm_requestvalid_signal <= target_oimm_requestvalid;
    initiator_oimm_requestvalid_id     <= target_oimm_requestvalid_id;
    initiator_oimm_readnotwrite        <= target_oimm_readnotwrite;
    initiator_oimm_writedata           <= target_oimm_writedata;
    initiator_oimm_writelast           <= target_oimm_writelast;

    target_oimm_waitrequest_signal <= initiator_oimm_waitrequest;

    register_idle <= '1';               --idle is state-only
  end generate no_request_register_gen;

  --Light register; breaks waitrequest/stall combinational path but does not break
  --address/etc. path.  Does not add latency if target is not asserting
  --waitrequest, but will reduce throughput if the target does.
  light_request_register_gen : if REQUEST_REGISTER = LIGHT generate
    signal target_oimm_address_held            : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    signal target_oimm_burstlength_held        : std_logic_vector(LOG2_BURSTLENGTH downto 0);
    signal target_oimm_burstlength_minus1_held : std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    signal target_oimm_byteenable_held         : std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    signal target_oimm_requestvalid_held       : std_logic;
    signal target_oimm_requestvalid_id_held    : std_logic_vector(ID_BITS-1 downto 0);
    signal target_oimm_readnotwrite_held       : std_logic;
    signal target_oimm_writedata_held          : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal target_oimm_writelast_held          : std_logic;
  begin
    initiator_oimm_address             <= target_oimm_address_held            when target_oimm_waitrequest_signal = '1' else target_oimm_address;
    initiator_oimm_burstlength         <= target_oimm_burstlength_held        when target_oimm_waitrequest_signal = '1' else target_oimm_burstlength;
    initiator_oimm_burstlength_minus1  <= target_oimm_burstlength_minus1_held when target_oimm_waitrequest_signal = '1' else target_oimm_burstlength_minus1;
    initiator_oimm_byteenable          <= target_oimm_byteenable_held         when target_oimm_waitrequest_signal = '1' else target_oimm_byteenable;
    initiator_oimm_requestvalid_signal <= target_oimm_requestvalid_held       when target_oimm_waitrequest_signal = '1' else target_oimm_requestvalid;
    initiator_oimm_requestvalid_id     <= target_oimm_requestvalid_id_held    when target_oimm_waitrequest_signal = '1' else target_oimm_requestvalid_id;
    initiator_oimm_readnotwrite        <= target_oimm_readnotwrite_held       when target_oimm_waitrequest_signal = '1' else target_oimm_readnotwrite;
    initiator_oimm_writedata           <= target_oimm_writedata_held          when target_oimm_waitrequest_signal = '1' else target_oimm_writedata;
    initiator_oimm_writelast           <= target_oimm_writelast_held          when target_oimm_waitrequest_signal = '1' else target_oimm_writelast;

    process(clk)
    begin
      if rising_edge(clk) then
        --When coming out of reset, need to put waitrequest down
        if target_oimm_requestvalid_held = '0' then
          target_oimm_waitrequest_signal <= '0';
        end if;

        if initiator_oimm_waitrequest = '0' then
          target_oimm_waitrequest_signal <= '0';
        end if;

        if target_oimm_waitrequest_signal = '0' then
          target_oimm_address_held            <= target_oimm_address;
          target_oimm_burstlength_held        <= target_oimm_burstlength;
          target_oimm_burstlength_minus1_held <= target_oimm_burstlength_minus1;
          target_oimm_byteenable_held         <= target_oimm_byteenable;
          target_oimm_requestvalid_held       <= target_oimm_requestvalid;
          target_oimm_requestvalid_id_held    <= target_oimm_requestvalid_id;
          target_oimm_readnotwrite_held       <= target_oimm_readnotwrite;
          target_oimm_writedata_held          <= target_oimm_writedata;
          target_oimm_writelast_held          <= target_oimm_writelast;
          target_oimm_waitrequest_signal      <= initiator_oimm_waitrequest and target_oimm_requestvalid;
        end if;

        if resetn = '0' then
          target_oimm_requestvalid_held  <= '0';
          target_oimm_waitrequest_signal <= '1';
        end if;
      end if;
    end process;

    register_idle <= not target_oimm_waitrequest_signal;  --idle is state-only
  end generate light_request_register_gen;

  --Full register; breaks waitrequest/stall combinational path and address/etc.
  --path. Always adds one cycle of latency but does not reduce throughput.
  full_request_register_gen : if REQUEST_REGISTER = FULL generate
    signal registered_oimm_address            : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    signal registered_oimm_burstlength        : std_logic_vector(LOG2_BURSTLENGTH downto 0);
    signal registered_oimm_burstlength_minus1 : std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    signal registered_oimm_byteenable         : std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    signal registered_oimm_requestvalid       : std_logic;
    signal registered_oimm_requestvalid_id    : std_logic_vector(ID_BITS-1 downto 0);
    signal registered_oimm_readnotwrite       : std_logic;
    signal registered_oimm_writedata          : std_logic_vector(DATA_WIDTH-1 downto 0);
    signal registered_oimm_writelast          : std_logic;
  begin
    process(clk)
    begin
      if rising_edge(clk) then
        --When coming out of reset, need to put waitrequest down
        if registered_oimm_requestvalid = '0' then
          target_oimm_waitrequest_signal <= '0';
        end if;

        if initiator_oimm_waitrequest = '0' then
          initiator_oimm_requestvalid_signal <= '0';
          if registered_oimm_requestvalid = '1' then
            initiator_oimm_address             <= registered_oimm_address;
            initiator_oimm_burstlength         <= registered_oimm_burstlength;
            initiator_oimm_burstlength_minus1  <= registered_oimm_burstlength_minus1;
            initiator_oimm_byteenable          <= registered_oimm_byteenable;
            initiator_oimm_readnotwrite        <= registered_oimm_readnotwrite;
            initiator_oimm_requestvalid_signal <= registered_oimm_requestvalid;
            initiator_oimm_requestvalid_id     <= registered_oimm_requestvalid_id;
            initiator_oimm_writedata           <= registered_oimm_writedata;
            initiator_oimm_writelast           <= registered_oimm_writelast;
            registered_oimm_requestvalid       <= '0';
            target_oimm_waitrequest_signal     <= '0';
          else
            initiator_oimm_address             <= target_oimm_address;
            initiator_oimm_burstlength         <= target_oimm_burstlength;
            initiator_oimm_burstlength_minus1  <= target_oimm_burstlength_minus1;
            initiator_oimm_byteenable          <= target_oimm_byteenable;
            initiator_oimm_readnotwrite        <= target_oimm_readnotwrite;
            initiator_oimm_requestvalid_signal <= target_oimm_requestvalid and (not target_oimm_waitrequest_signal);
            initiator_oimm_requestvalid_id     <= target_oimm_requestvalid_id;
            initiator_oimm_writedata           <= target_oimm_writedata;
            initiator_oimm_writelast           <= target_oimm_writelast;
          end if;
        else
          if target_oimm_waitrequest_signal = '0' then
            if initiator_oimm_requestvalid_signal = '1' then
              registered_oimm_address            <= target_oimm_address;
              registered_oimm_burstlength        <= target_oimm_burstlength;
              registered_oimm_burstlength_minus1 <= target_oimm_burstlength_minus1;
              registered_oimm_byteenable         <= target_oimm_byteenable;
              registered_oimm_requestvalid       <= target_oimm_requestvalid;
              registered_oimm_requestvalid_id    <= target_oimm_requestvalid_id;
              registered_oimm_readnotwrite       <= target_oimm_readnotwrite;
              registered_oimm_writedata          <= target_oimm_writedata;
              registered_oimm_writelast          <= target_oimm_writelast;
              target_oimm_waitrequest_signal     <= target_oimm_requestvalid;
            else
              initiator_oimm_address             <= target_oimm_address;
              initiator_oimm_burstlength         <= target_oimm_burstlength;
              initiator_oimm_burstlength_minus1  <= target_oimm_burstlength_minus1;
              initiator_oimm_byteenable          <= target_oimm_byteenable;
              initiator_oimm_readnotwrite        <= target_oimm_readnotwrite;
              initiator_oimm_requestvalid_signal <= target_oimm_requestvalid;
              initiator_oimm_requestvalid_id     <= target_oimm_requestvalid_id;
              initiator_oimm_writedata           <= target_oimm_writedata;
              initiator_oimm_writelast           <= target_oimm_writelast;
            end if;
          end if;
        end if;

        if resetn = '0' then
          initiator_oimm_requestvalid_signal <= '0';
          registered_oimm_requestvalid       <= '0';
          target_oimm_waitrequest_signal     <= '1';
        end if;
      end if;
    end process;

    register_idle <= not initiator_oimm_requestvalid_signal;  --idle is state-only
  end generate full_request_register_gen;

  -----------------------------------------------------------------------------
  -- Optional Data Memory Return Register
  -----------------------------------------------------------------------------
  no_return_register_gen : if not RETURN_REGISTER generate
    target_oimm_readdata         <= initiator_oimm_readdata;
    target_oimm_readdatavalid    <= initiator_oimm_readdatavalid;
    target_oimm_readdatavalid_id <= initiator_oimm_readdatavalid_id;
    target_oimm_readlast         <= initiator_oimm_readlast;
  end generate no_return_register_gen;
  return_register_gen : if RETURN_REGISTER generate
    process(clk)
    begin
      if rising_edge(clk) then
        target_oimm_readdata         <= initiator_oimm_readdata;
        target_oimm_readdatavalid    <= initiator_oimm_readdatavalid;
        target_oimm_readdatavalid_id <= initiator_oimm_readdatavalid_id;
        target_oimm_readlast         <= initiator_oimm_readlast;
      end if;
    end process;
  end generate return_register_gen;

end architecture rtl;
