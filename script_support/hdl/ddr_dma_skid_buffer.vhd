library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;

entity ddr_dma_skid_buffer is
  generic (
    DATA_WIDTH                : positive := 32
  );
  port (
    clk            : in std_logic;
    resetn         : in std_logic;

    valid_i        : in  std_logic;
    data_i         : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    ready_o        : out std_logic;
    
    valid_o        : out  std_logic;
    data_o         : out  std_logic_vector(DATA_WIDTH-1 downto 0);
    ready_i        : in std_logic
  );
end ddr_dma_skid_buffer;

architecture rtl of ddr_dma_skid_buffer is

  signal data          : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal ready         : std_logic;
  signal bypass        : std_logic;

begin 

  process(clk)
  begin
    if(rising_edge(clk)) then
      if(bypass = '1') then
        ready <= '1';
        if(ready_i = '0' and valid_i = '1' and ready = '1') then
            ready <= '0';
            bypass <= '0';
            data <= data_i;
        end if;
      else
        if(ready_i = '1') then
          ready <= '1';
          bypass <= '1';
        end if;
      end if;

      if(resetn = '0') then
        ready <= '0';
        bypass <= '1';
      end if;
    end if;
  end process;


  ready_o <= ready;
  valid_o <= (valid_i and ready) when bypass else '1';
  data_o <= data_i when bypass else data;

end rtl;
