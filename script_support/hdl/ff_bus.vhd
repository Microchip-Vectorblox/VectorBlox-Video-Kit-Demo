--------------------------------------------------------------------------------
-- Company: <Name>
--
-- File: ff_bus.vhd
-- File history:
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--      <Revision number>: <Date>: <Comments>
--
-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::PolarFire> <Die::MPF300T> <Package::FCG1152>
-- Author: <Name>
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity ff_bus is
  generic (
    BUS_WIDTH : integer := 12);
  port (
    clk : in std_logic;
    
	bus_in : IN  std_logic_vector(BUS_WIDTH-1 downto 0); -- example
    bus_out: OUT std_logic_vector(BUS_WIDTH-1 downto 0)  -- example
);
end ff_bus;
architecture architecture_ff_bus of ff_bus is
   -- signal, component etc. declarations

begin
  process (clk) is
  begin  -- process
    if rising_edge(clk) then            -- rising clock edge
      bus_out <= bus_in;
    end if;
  end process;
   -- architecture body
end architecture_ff_bus;
