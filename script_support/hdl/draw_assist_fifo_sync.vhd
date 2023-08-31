-- FWFT FIFO

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.draw_assist_pkg.all;

entity draw_assist_fifo_sync is
  generic (
    WIDTH           : positive;
    DEPTH           : positive;
    OUTPUT_REGISTER : natural range 0 to 2 := 1
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    remw  : out    unsigned(log2(DEPTH+1)-1 downto 0);
    usedw : buffer unsigned(log2(DEPTH+1)-1 downto 0);

    we      : in  std_logic;
    data_in : in  std_logic_vector(WIDTH-1 downto 0);
    wrfull  : out std_logic;
    wrempty : out std_logic;

    rd       : in  std_logic;
    data_out : out std_logic_vector(WIDTH-1 downto 0);
    rdempty  : out std_logic
    );
end draw_assist_fifo_sync;

architecture rtl of draw_assist_fifo_sync is
  signal rdempty_buffer : std_logic;
begin
  rdempty <= rdempty_buffer;

  one_entry_gen : if DEPTH = 1 generate
    signal write_stall : std_logic;
  begin
    --Single entry has combinational rd-wr paths for now.  Could add
    --registers but at that point it's cheaper to go to distributed
    --RAM based solutions.
    process (clk) is
    begin
      if rising_edge(clk) then
        write_stall <= '0';

        if rd = '1' then
          rdempty_buffer <= '1';
        end if;

        if we = '1' then
          data_out       <= data_in;
          rdempty_buffer <= '0';
        end if;

        if resetn = '0' then
          rdempty_buffer <= '1';
          write_stall    <= '1';
        end if;
      end if;
    end process;
    wrfull   <= write_stall or ((not rdempty_buffer) and (not rd));
    usedw(0) <= not rdempty_buffer;
    remw(0)  <= rdempty_buffer;
    wrempty  <= rdempty_buffer;
  end generate one_entry_gen;
  real_fifo_gen : if DEPTH > 1 generate
    type data_array is array (natural range <>) of std_logic_vector(WIDTH-1 downto 0);
    signal data_ram : data_array(DEPTH-1 downto 0);

    subtype ram_address is unsigned(log2(DEPTH)-1 downto 0);
    signal read_pointer       : ram_address;
    signal write_pointer      : ram_address;
    signal read_pointer_p1    : ram_address;
    signal write_pointer_p1   : ram_address;
    signal next_read_pointer  : ram_address;
    signal next_write_pointer : ram_address;
    signal next_rdempty       : std_logic;
    signal next_wrempty       : std_logic;
    signal next_wrfull        : std_logic;
    signal next_usedw         : unsigned(log2(DEPTH+1)-1 downto 0);
    signal we_rd              : std_logic_vector(1 downto 0);
  begin
    read_pointer_p1  <= read_pointer + to_unsigned(1, read_pointer'length);
    write_pointer_p1 <= write_pointer + to_unsigned(1, write_pointer'length);
    power_of_two_depth_gen : if 2**log2(DEPTH) = DEPTH generate
      next_read_pointer  <= read_pointer  when rd = '0' else read_pointer_p1;
      next_write_pointer <= write_pointer when we = '0' else write_pointer_p1;
    end generate power_of_two_depth_gen;
    non_power_of_two_gen : if 2**log2(DEPTH) /= DEPTH generate
      next_read_pointer <=
        read_pointer                             when rd = '0' else
        to_unsigned(0, next_read_pointer'length) when read_pointer_p1 = to_unsigned(DEPTH, read_pointer_p1'length)
        else read_pointer_p1;
      next_write_pointer <=
        write_pointer                             when we = '0' else
        to_unsigned(0, next_write_pointer'length) when write_pointer_p1 = to_unsigned(DEPTH, write_pointer_p1'length)
        else write_pointer_p1;
    end generate non_power_of_two_gen;

    we_rd <= we & rd;
    with we_rd select
      next_usedw <=
      usedw + to_unsigned(1, usedw'length) when "10",
      usedw - to_unsigned(1, usedw'length) when "01",
      usedw                                when others;
    next_wrfull  <= '1' when next_usedw = to_unsigned(DEPTH, usedw'length) else '0';
    next_wrempty <= '1' when next_usedw = to_unsigned(0, usedw'length)     else '0';

    no_output_register_gen : if OUTPUT_REGISTER = 0 generate
      data_out     <= data_ram(to_integer(read_pointer));
      next_rdempty <= next_wrempty;
    end generate no_output_register_gen;
    one_output_register_gen : if OUTPUT_REGISTER = 1 generate
      process (clk)
      begin
        if rising_edge(clk) then
          data_out <= data_ram(to_integer(next_read_pointer));
        end if;
      end process;
      next_rdempty <= next_wrempty or we when next_read_pointer = write_pointer else '0';
    end generate one_output_register_gen;
    two_output_registers_gen : if OUTPUT_REGISTER = 2 generate
      signal internal_register       : std_logic_vector(WIDTH-1 downto 0);
      signal internal_register_ready : std_logic;
      signal internal_register_valid : std_logic;
      signal next_next_read_pointer  : ram_address;
    begin
      process (clk)
      begin
        if rising_edge(clk) then
          if rd = '1' or rdempty_buffer = '1' then
            data_out                <= internal_register;
            internal_register_valid <= '0';
          end if;

          if rd = '1' or rdempty_buffer = '1' or internal_register_valid = '0' then
            internal_register <= data_ram(to_integer(next_next_read_pointer));
            if next_next_read_pointer /= write_pointer then
              internal_register_valid <= '1';
              next_next_read_pointer  <= next_next_read_pointer + to_unsigned(1, next_next_read_pointer'length);
              if 2**log2(DEPTH) /= DEPTH then
                if next_next_read_pointer = to_unsigned(DEPTH-1, next_next_read_pointer'length) then
                  next_next_read_pointer <= to_unsigned(0, next_next_read_pointer'length);
                end if;
              end if;
            end if;
          end if;

          if resetn = '0' then
            next_next_read_pointer  <= to_unsigned(0, next_next_read_pointer'length);
            internal_register_valid <= '0';
          end if;
        end if;
      end process;
      next_rdempty <= not internal_register_valid when rd = '1' or rdempty_buffer = '1' else '0';
    end generate two_output_registers_gen;

    process (clk)
    begin
      if rising_edge(clk) then
        remw           <= to_unsigned(DEPTH, remw'length) - next_usedw;
        usedw          <= next_usedw;
        rdempty_buffer <= next_rdempty;
        wrempty        <= next_wrempty;
        wrfull         <= next_wrfull;
        read_pointer   <= next_read_pointer;
        write_pointer  <= next_write_pointer;

        if we = '1' then
          data_ram(to_integer(write_pointer)) <= data_in;
        end if;

        if resetn = '0' then
          rdempty_buffer <= '1';
          wrempty        <= '1';
          wrfull         <= '1';
          remw           <= to_unsigned(DEPTH, remw'length);
          usedw          <= to_unsigned(0, usedw'length);
          read_pointer   <= to_unsigned(0, read_pointer'length);
          write_pointer  <= to_unsigned(0, write_pointer'length);
        end if;
      end if;
    end process;
  end generate real_fifo_gen;

  process (clk)
  begin
    if rising_edge(clk) then
      assert not (rd = '1' and we = '0' and usedw = to_unsigned(0, usedw'length)) report
        "FIFO underflow"
        severity failure;
      assert not (rd = '0' and we = '1' and usedw = to_unsigned(DEPTH, usedw'length)) report
        "FIFO overflow"
        severity failure;
    end if;
  end process;

end rtl;
