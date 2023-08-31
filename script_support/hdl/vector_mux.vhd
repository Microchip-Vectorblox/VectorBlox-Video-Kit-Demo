--------------------------------------------------------------------------------
-- Company: Microchip
--
-- File: vector_mux.vhd
-- File history:

-- Description: 
--
-- <Description here>
--
-- Targeted device: <Family::PolarFire> <Die::MPF300T> <Package::FCG1152>
-- Author: Joel Vandergriendt joel.vandergriendt@microchip.com
--
--------------------------------------------------------------------------------

library IEEE;

use IEEE.std_logic_1164.all;

entity vector_mux is
  generic (
    VEC_LENGTH : integer := 8);
port (
	sel : in  std_logic; -- example
    in_vec0 : in  std_logic_vector(VEC_LENGTH-1 downto 0);
    in_vec1 : in  std_logic_vector(VEC_LENGTH-1 downto 0);
    out_vec : out std_logic_vector(VEC_LENGTH-1 downto 0) 
);
end vector_mux;
architecture architecture_vector_mux of vector_mux is

begin
 out_vec <= in_vec0 when sel = '0' else in_vec1;
   -- architecture body
end architecture_vector_mux;
