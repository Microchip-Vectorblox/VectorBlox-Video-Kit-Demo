library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;

entity ddr_dma_cdc is
  generic (
    DATA_WIDTH                : positive := 32
  );
  port (
    from_clk            : in std_logic;
    from_resetn         : in std_logic;
    from_valid_pulse_i  : in  std_logic;
    from_data_i         : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    
    to_clk              : in std_logic;
    to_resetn           : in std_logic;
    to_valid_pulse_o    : out  std_logic;
    to_data_o           : out  std_logic_vector(DATA_WIDTH-1 downto 0)
  );
end ddr_dma_cdc;

architecture rtl of ddr_dma_cdc is

  signal from_valid_req     : std_logic;
  signal from_valid_ack     : std_logic_vector (1 downto 0);
  signal from_data          : std_logic_vector(DATA_WIDTH-1 downto 0);

  signal to_valid_ack     : std_logic;
  signal to_valid_ack_dly : std_logic;
  signal to_valid_req     : std_logic_vector (1 downto 0);
  
begin 

  process(from_clk)
  begin
    if(rising_edge(from_clk)) then
      if(from_valid_pulse_i = '1') then
        from_data <= from_data_i;
      end if;

      if(from_valid_pulse_i = '1') then
        from_valid_req <= '1';
      elsif  (from_valid_req = '1' and from_valid_ack(1) = '1') then
        from_valid_req <= '0';
      end if;

      from_valid_ack <= (from_valid_ack(0) & to_valid_ack); -- two register syncronizer 

      if(from_resetn = '0') then
        from_valid_req <= '0';
        from_valid_ack <= (others => '0');
      end if;
    end if;
  end process;


  process(to_clk)
  begin
    if(rising_edge(to_clk)) then

      to_valid_req <= (to_valid_req(0) & from_valid_req); -- two register syncronizer
      to_valid_ack_dly <= to_valid_ack;

      if(to_valid_req(1) = '1') then
        to_data_o <= from_data;
      end if;

      if(to_valid_req(1) = '1') then
        to_valid_ack <= '1';
      elsif (to_valid_ack <= '1' and to_valid_req(1) = '0') then
        to_valid_ack <= '0';
      end if;

      if(to_resetn = '0') then
        to_valid_ack <= '0';
        to_valid_req <= (others => '0');
      end if;
    end if;
  end process;

  to_valid_pulse_o <= to_valid_ack and (not to_valid_ack_dly);
  
end rtl;
