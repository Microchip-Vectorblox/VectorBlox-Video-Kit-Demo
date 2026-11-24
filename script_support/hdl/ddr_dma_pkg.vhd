library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;

package ddr_dma_pkg is
  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  

  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------
  type request_register_type is (OFF, LIGHT, FULL);

  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------
  function to_std_logic (
    input_boolean : boolean
    )
    return std_logic;

  function to_std_logic_vector (
    sl : std_logic
    )
    return std_logic_vector;

  function decode_enables (
    first          : std_logic;
    last           : std_logic;
    leading_zeros  : unsigned;
    trailing_zeros : unsigned
    )
    return std_logic_vector;
  
  function imax (
    constant M : integer;
    constant N : integer
    )
    return integer;

  function imin (
    constant M : integer;
    constant N : integer
    )
    return integer;

  function log2(
    constant N : integer
    )
    return integer;

  function log2_f(
    constant N : integer
    )
    return integer;

  function or_slv (
    data_in : std_logic_vector
    )
    return std_logic;

  function and_slv (
    data_in : std_logic_vector
    )
    return std_logic;

  function ternary (
    return_true_value : boolean;
    true_value        : integer;
    false_value       : integer
    )
    return integer;

  function priority_encode_highest (
    input_vector : std_logic_vector
    )
    return unsigned;

end package ddr_dma_pkg;

package body ddr_dma_pkg is

  function to_std_logic (
    input_boolean : boolean
    )
    return std_logic is
  begin
    if input_boolean then
      return '1';
    end if;

    return '0';
  end function to_std_logic;

  function to_std_logic_vector (
    sl : std_logic
    )
    return std_logic_vector is
    variable slv : std_logic_vector(0 downto 0);
  begin
    slv(0) := sl;

    return slv;
  end function to_std_logic_vector;

  function decode_enables (
    first          : std_logic;
    last           : std_logic;
    leading_zeros  : unsigned;
    trailing_zeros : unsigned
    )
    return std_logic_vector is
    variable leading_enable  : std_logic_vector((2**leading_zeros'length)-1 downto 0);
    variable trailing_enable : std_logic_vector((2**trailing_zeros'length)-1 downto 0);
  begin
    leading_enable := (others => '1');
    if first = '1' then
      for i_bit in leading_enable'range loop
        if to_unsigned(i_bit, leading_zeros'length) < leading_zeros then
          leading_enable(i_bit) := '0';
        end if;
      end loop;
    end if;

    trailing_enable := (others => '1');
    if last = '1' then
      for i_bit in trailing_enable'range loop
        if to_unsigned(i_bit, trailing_zeros'length) < trailing_zeros then
          trailing_enable(trailing_enable'left-i_bit) := '0';
        end if;
      end loop;
    end if;

    return leading_enable and trailing_enable;
  end function decode_enables;
  
  function imax(
    constant M : integer;
    constant N : integer
    )
    return integer is
  begin
    if M < N then
      return N;
    end if;

    return M;
  end imax;

  function imin(
    constant M : integer;
    constant N : integer
    )
    return integer is
  begin
    if M < N then
      return M;
    end if;

    return N;
  end imin;

  function log2(
    constant N : integer
    )
    return integer is
    variable i : integer := 0;
  begin
    while (2**i < n) loop
      i := i + 1;
    end loop;
    return i;
  end log2;

  function log2_f(
    constant N : integer
    )
    return integer is
    variable i : integer := 0;
  begin
    while (2**i <= n) loop
      i := i + 1;
    end loop;
    return i-1;
  end log2_f;

  function or_slv (
    data_in : std_logic_vector
    )
    return std_logic is
    variable data_in_copy : std_logic_vector(data_in'length-1 downto 0);
    variable reduced_or   : std_logic;
  begin
    data_in_copy := data_in;            --Fix alignment/ordering
    reduced_or   := '0';
    for i in data_in_copy'left downto 0 loop
      reduced_or := reduced_or or data_in_copy(i);
    end loop;  -- i

    return reduced_or;
  end or_slv;

  function and_slv (
    data_in : std_logic_vector
    )
    return std_logic is
    variable data_in_copy : std_logic_vector(data_in'length-1 downto 0);
    variable reduced_and  : std_logic;
  begin
    data_in_copy := data_in;            --Fix alignment/ordering
    reduced_and  := '1';
    for i in data_in_copy'left downto 0 loop
      reduced_and := reduced_and and data_in_copy(i);
    end loop;  -- i

    return reduced_and;
  end and_slv;

  function ternary (
    return_true_value : boolean;
    true_value        : integer;
    false_value       : integer
    )
    return integer is
  begin  -- function ternary
    if return_true_value then
      return true_value;
    end if;

    return false_value;
  end function ternary;


  function priority_encode_highest (
    input_vector : std_logic_vector
    )
    return unsigned is
    variable highest_bit : unsigned(log2(input_vector'length)-1 downto 0);
  begin
    highest_bit := to_unsigned(input_vector'length-1, highest_bit'length);

    for ibit in 0 to input_vector'length-1 loop
      if input_vector(input_vector'low+ibit) = '1' then
        highest_bit := to_unsigned(ibit, highest_bit'length);
      end if;
    end loop;  -- ibit

    return highest_bit;
  end function priority_encode_highest;

end ddr_dma_pkg;
