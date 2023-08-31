library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.draw_assist_pkg.all;

-------------------------------------------------------------------------------
-- Memory-mapped register
-------------------------------------------------------------------------------

entity draw_assist_register is
  generic (
    ADDRESS_WIDTH    : positive;
    DATA_WIDTH       : positive;
    LOG2_BURSTLENGTH : positive;
    RETURN_REGISTER  : boolean
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    slave_address            : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    slave_burstlength_minus1 : in  std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    slave_byteenable         : in  std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    slave_requestvalid       : in  std_logic;
    slave_readnotwrite       : in  std_logic;
    slave_writedata          : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    slave_writelast          : in  std_logic;
    slave_readdata           : out std_logic_vector(DATA_WIDTH-1 downto 0);
    slave_readdatavalid      : out std_logic;
    slave_readcomplete       : out std_logic;
    slave_waitrequest        : out std_logic;

    master_address            : out std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    master_burstlength_minus1 : out std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    master_byteenable         : out std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    master_requestvalid       : out std_logic;
    master_readnotwrite       : out std_logic;
    master_writedata          : out std_logic_vector(DATA_WIDTH-1 downto 0);
    master_writelast          : out std_logic;
    master_readdata           : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    master_readdatavalid      : in  std_logic;
    master_readcomplete       : in  std_logic;
    master_waitrequest        : in  std_logic
    );
end entity draw_assist_register;

architecture rtl of draw_assist_register is
  signal slave_waitrequest_signal   : std_logic;
  signal master_requestvalid_signal : std_logic;

  signal registered_address            : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal registered_burstlength_minus1 : std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
  signal registered_byteenable         : std_logic_vector((DATA_WIDTH/8)-1 downto 0);
  signal registered_requestvalid       : std_logic;
  signal registered_readnotwrite       : std_logic;
  signal registered_writedata          : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal registered_writelast          : std_logic;
begin
  slave_waitrequest   <= slave_waitrequest_signal;
  master_requestvalid <= master_requestvalid_signal;


  -----------------------------------------------------------------------------
  -- Memory Request Register
  -----------------------------------------------------------------------------
  process(clk)
  begin
    if rising_edge(clk) then
      --When coming out of reset, need to put waitrequest down
      if registered_requestvalid = '0' then
        slave_waitrequest_signal <= '0';
      end if;

      if master_waitrequest = '0' then
        master_requestvalid_signal <= '0';
        if registered_requestvalid = '1' then
          master_address             <= registered_address;
          master_burstlength_minus1  <= registered_burstlength_minus1;
          master_byteenable          <= registered_byteenable;
          master_readnotwrite        <= registered_readnotwrite;
          master_requestvalid_signal <= registered_requestvalid;
          master_writedata           <= registered_writedata;
          master_writelast           <= registered_writelast;
          registered_requestvalid    <= '0';
          slave_waitrequest_signal   <= '0';
        else
          master_address             <= slave_address;
          master_burstlength_minus1  <= slave_burstlength_minus1;
          master_byteenable          <= slave_byteenable;
          master_readnotwrite        <= slave_readnotwrite;
          master_requestvalid_signal <= slave_requestvalid and (not slave_waitrequest_signal);
          master_writedata           <= slave_writedata;
          master_writelast           <= slave_writelast;
        end if;
      else
        if slave_waitrequest_signal = '0' then
          if master_requestvalid_signal = '1' then
            registered_address            <= slave_address;
            registered_burstlength_minus1 <= slave_burstlength_minus1;
            registered_byteenable         <= slave_byteenable;
            registered_requestvalid       <= slave_requestvalid;
            registered_readnotwrite       <= slave_readnotwrite;
            registered_writedata          <= slave_writedata;
            registered_writelast          <= slave_writelast;
            slave_waitrequest_signal      <= slave_requestvalid;
          else
            master_address             <= slave_address;
            master_burstlength_minus1  <= slave_burstlength_minus1;
            master_byteenable          <= slave_byteenable;
            master_readnotwrite        <= slave_readnotwrite;
            master_requestvalid_signal <= slave_requestvalid;
            master_writedata           <= slave_writedata;
            master_writelast           <= slave_writelast;
          end if;
        end if;
      end if;

      if resetn = '0' then
        master_requestvalid_signal <= '0';
        registered_requestvalid    <= '0';
        slave_waitrequest_signal   <= '1';
      end if;
    end if;
  end process;


  -----------------------------------------------------------------------------
  -- Optional Data Memory Return Register
  -----------------------------------------------------------------------------
  no_return_register_gen : if not RETURN_REGISTER generate
    slave_readdata      <= master_readdata;
    slave_readdatavalid <= master_readdatavalid;
    slave_readcomplete  <= master_readcomplete;
  end generate no_return_register_gen;
  return_register_gen : if RETURN_REGISTER generate
    process(clk)
    begin
      if rising_edge(clk) then
        slave_readdata      <= master_readdata;
        slave_readdatavalid <= master_readdatavalid;
        slave_readcomplete  <= master_readcomplete;
      end if;
    end process;
  end generate return_register_gen;

end architecture rtl;
