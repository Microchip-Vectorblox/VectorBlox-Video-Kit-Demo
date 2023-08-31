library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;

package draw_assist_pkg is
  ------------------------------------------------------------------------------
  -- Constants
  ------------------------------------------------------------------------------
  constant REGISTER_BITS             : positive                                   := 4;
  constant CONTROL_REGISTER_REG      : std_logic_vector(REGISTER_BITS-1 downto 0) := "0000";  --0x00
  constant INPUT_ADDRESS_REG         : std_logic_vector(REGISTER_BITS-1 downto 0) := "0010";  --0x08
  constant INPUT_COLUMNS_MINUS1_REG  : std_logic_vector(REGISTER_BITS-1 downto 0) := "0100";  --0x10
  constant INPUT_ROWS_REG            : std_logic_vector(REGISTER_BITS-1 downto 0) := "0101";  --0x14
  constant INPUT_STRIDE_REG          : std_logic_vector(REGISTER_BITS-1 downto 0) := "0110";  --0x18
  constant OUTPUT_ADDRESS_REG        : std_logic_vector(REGISTER_BITS-1 downto 0) := "1000";  --0x20
  constant OUTPUT_COLUMNS_MINUS1_REG : std_logic_vector(REGISTER_BITS-1 downto 0) := "1010";  --0x28
  constant OUTPUT_ROWS_REG           : std_logic_vector(REGISTER_BITS-1 downto 0) := "1011";  --0x2C
  constant OUTPUT_STRIDE_REG         : std_logic_vector(REGISTER_BITS-1 downto 0) := "1100";  --0x30

  constant CONTROL_START_BIT   : natural := 0;
  constant CONTROL_FULL_BIT    : natural := 1;
  constant CONTROL_RUNNING_BIT : natural := 2;

  constant STRIDE_FRACTIONAL_BITS : positive := 16;
  constant STRIDE_INTEGER_BITS    : positive := 32-STRIDE_FRACTIONAL_BITS;


  ------------------------------------------------------------------------------
  -- Types
  ------------------------------------------------------------------------------
  type drawing_record is record
    input_address         : unsigned(31 downto 0);
    input_columns_minus1  : unsigned(31 downto 0);
    input_rows            : unsigned(15 downto 0);
    input_stride          : signed(31 downto 0);
    input_is_scalar       : std_logic;
    output_address        : unsigned(31 downto 0);
    output_columns_minus1 : unsigned(31 downto 0);
    output_rows           : unsigned(15 downto 0);
    output_stride         : signed(31 downto 0);
  end record drawing_record;
  constant DRAWING_RECORD_BITS : positive := 225;


  ------------------------------------------------------------------------------
  -- Functions
  ------------------------------------------------------------------------------
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

  function drawing_record_to_slv (
    drawing : drawing_record
    )
    return std_logic_vector;

  function slv_to_drawing_record (
    drawing_slv : std_logic_vector
    )
    return drawing_record;

end package draw_assist_pkg;

package body draw_assist_pkg is

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

  function drawing_record_to_slv (
    drawing : drawing_record
    )
    return std_logic_vector is
    variable drawing_slv : std_logic_vector(DRAWING_RECORD_BITS-1 downto 0);
    variable current_bit : natural;
  begin
    current_bit := 0;

    drawing_slv(current_bit+drawing.input_address'length-1 downto current_bit) :=
      std_logic_vector(drawing.input_address);
    current_bit := current_bit + drawing.input_address'length;
    drawing_slv(current_bit+drawing.input_columns_minus1'length-1 downto current_bit) :=
      std_logic_vector(drawing.input_columns_minus1);
    current_bit := current_bit + drawing.input_columns_minus1'length;
    drawing_slv(current_bit+drawing.input_rows'length-1 downto current_bit) :=
      std_logic_vector(drawing.input_rows);
    current_bit := current_bit + drawing.input_rows'length;
    drawing_slv(current_bit+drawing.input_stride'length-1 downto current_bit) :=
      std_logic_vector(drawing.input_stride);
    current_bit              := current_bit + drawing.input_stride'length;
    drawing_slv(current_bit) := drawing.input_is_scalar;
    current_bit              := current_bit + 1;

    drawing_slv(current_bit+drawing.output_address'length-1 downto current_bit) :=
      std_logic_vector(drawing.output_address);
    current_bit := current_bit + drawing.output_address'length;
    drawing_slv(current_bit+drawing.output_columns_minus1'length-1 downto current_bit) :=
      std_logic_vector(drawing.output_columns_minus1);
    current_bit := current_bit + drawing.output_columns_minus1'length;
    drawing_slv(current_bit+drawing.output_rows'length-1 downto current_bit) :=
      std_logic_vector(drawing.output_rows);
    current_bit := current_bit + drawing.output_rows'length;
    drawing_slv(current_bit+drawing.output_stride'length-1 downto current_bit) :=
      std_logic_vector(drawing.output_stride);
    current_bit := current_bit + drawing.output_stride'length;

    return drawing_slv;
  end function drawing_record_to_slv;

  function slv_to_drawing_record (
    drawing_slv : std_logic_vector
    )
    return drawing_record is
    variable drawing     : drawing_record;
    variable current_bit : natural;
  begin
    current_bit := 0;

    drawing.input_address :=
      unsigned(drawing_slv(current_bit+drawing.input_address'length-1 downto current_bit));
    current_bit := current_bit + drawing.input_address'length;
    drawing.input_columns_minus1 :=
      unsigned(drawing_slv(current_bit+drawing.input_columns_minus1'length-1 downto current_bit));
    current_bit := current_bit + drawing.input_columns_minus1'length;
    drawing.input_rows :=
      unsigned(drawing_slv(current_bit+drawing.input_rows'length-1 downto current_bit));
    current_bit := current_bit + drawing.input_rows'length;
    drawing.input_stride :=
      signed(drawing_slv(current_bit+drawing.input_stride'length-1 downto current_bit));
    current_bit := current_bit + drawing.input_stride'length;
    drawing.input_is_scalar :=
      drawing_slv(current_bit);
    current_bit := current_bit + 1;

    drawing.output_address :=
      unsigned(drawing_slv(current_bit+drawing.output_address'length-1 downto current_bit));
    current_bit := current_bit + drawing.output_address'length;
    drawing.output_columns_minus1 :=
      unsigned(drawing_slv(current_bit+drawing.output_columns_minus1'length-1 downto current_bit));
    current_bit := current_bit + drawing.output_columns_minus1'length;
    drawing.output_rows :=
      unsigned(drawing_slv(current_bit+drawing.output_rows'length-1 downto current_bit));
    current_bit := current_bit + drawing.output_rows'length;
    drawing.output_stride :=
      signed(drawing_slv(current_bit+drawing.output_stride'length-1 downto current_bit));
    current_bit := current_bit + drawing.output_stride'length;

    return drawing;
  end function slv_to_drawing_record;

end draw_assist_pkg;
