library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pixel_average is

  generic (
    PIXELS_PER_CLOCK   : integer := 4;
    PIXEL_BITS         : integer := 8;
    LOG2_PIXELS_TO_AVG : integer := 21);

  port (
    clk          : in  std_logic;
    resetn       : in  std_logic;
    red_i        : in  std_logic_vector(PIXELS_PER_CLOCK*PIXEL_BITS-1 downto 0);
    green_i      : in  std_logic_vector(PIXELS_PER_CLOCK*PIXEL_BITS-1 downto 0);
    blue_i       : in  std_logic_vector(PIXELS_PER_CLOCK*PIXEL_BITS-1 downto 0);
    pix_valid_i  : in  std_logic;
    red_mean_o   : out std_logic_vector(31 downto 0);
    green_mean_o : out std_logic_vector(31 downto 0);
    blue_mean_o  : out std_logic_vector(31 downto 0);
    red_var_o    : out std_logic_vector(31 downto 0);
    green_var_o  : out std_logic_vector(31 downto 0);
    blue_var_o   : out std_logic_vector(31 downto 0));


end entity pixel_average;



architecture rtl of pixel_average is
  signal red_sum_s    : unsigned(31 downto 0);
  signal green_sum_s  : unsigned(31 downto 0);
  signal blue_sum_s   : unsigned(31 downto 0);
  signal red_mean_s   : unsigned(31 downto 0);
  signal green_mean_s : unsigned(31 downto 0);
  signal blue_mean_s  : unsigned(31 downto 0);

  signal num_pixels_s         : unsigned(LOG2_PIXELS_TO_AVG-1 downto 0);
  signal red_mean_absdiff_s   : unsigned(31 downto 0);
  signal green_mean_absdiff_s : unsigned(31 downto 0);
  signal blue_mean_absdiff_s  : unsigned(31 downto 0);
  signal pixel_zero_count     : std_logic;
  signal pixel_zero_count_re  : std_logic;
  function sum_of_clock (
    pixels : std_logic_vector(PIXELS_PER_CLOCK*PIXEL_BITS-1 downto 0))
    return unsigned is
    variable sum : unsigned(31 downto 0);
    variable pix : unsigned(PIXEL_BITS-1 downto 0);
  begin  -- function sum_of_clock
    sum := (others => '0');
    for p in 0 to PIXELS_PER_CLOCK-1 loop
      pix := unsigned(pixels((p+1)*PIXEL_BITS -1 downto p*PIXEL_BITS));
      sum := sum + pix;
    end loop;  -- p
    return sum;
  end function sum_of_clock;
  function sumabsdiff_of_clock (
    pixels : std_logic_vector(PIXELS_PER_CLOCK*PIXEL_BITS-1 downto 0);
    mean   : unsigned(31 downto 0))
    return unsigned is
    variable diff    : unsigned(31 downto 0);
    variable absdiff : unsigned(31 downto 0);
    variable sum     : unsigned(31 downto 0);
    variable pix     : unsigned(PIXEL_BITS-1 downto 0);
  begin  -- function sum_of_clock
    sum := (others => '0');
    for p in 0 to PIXELS_PER_CLOCK-1 loop
      pix  := unsigned(pixels((p+1)*PIXEL_BITS -1 downto p*PIXEL_BITS));
      diff := mean - pix;
      if signed(diff) < 0 then
        absdiff := 0-diff;
      else
        absdiff := diff;
      end if;
      sum := sum+ absdiff;
    end loop;  -- p
    return sum;
  end function sumabsdiff_of_clock;


begin  -- architecture rtl

  process (clk) is
  begin  -- process
    if rising_edge(clk) then            -- rising clock edge
      if pix_valid_i = '1' then
        red_sum_s            <= red_sum_s + sum_of_clock(red_i);
        green_sum_s          <= green_sum_s + sum_of_clock(green_i);
        blue_sum_s           <= blue_sum_s + sum_of_clock(blue_i);
        red_mean_absdiff_s   <= red_mean_absdiff_s + sumabsdiff_of_clock(red_i, red_mean_s);
        green_mean_absdiff_s <= green_mean_absdiff_s + sumabsdiff_of_clock(green_i, green_mean_s);
        blue_mean_absdiff_s  <= blue_mean_absdiff_s + sumabsdiff_of_clock(blue_i, blue_mean_s);
        num_pixels_s         <= num_pixels_s + PIXELS_PER_CLOCK;
      end if;
      pixel_zero_count_re <= '0';
      pixel_zero_count    <= '0';
      if num_pixels_s = 0 then
        pixel_zero_count <= '1';
      end if;
      if num_pixels_s = 0 and pixel_zero_count = '0' then
        pixel_zero_count_re <= '1';
      end if;
      if pixel_zero_count_re = '1' then

        red_mean_s   <= shift_right(red_sum_s, LOG2_PIXELS_TO_AVG);
        green_mean_s <= shift_right(green_sum_s, LOG2_PIXELS_TO_AVG);
        blue_mean_s  <= shift_right(blue_sum_s, LOG2_PIXELS_TO_AVG);
        red_var_o    <= std_logic_vector(shift_right(red_mean_absdiff_s,  LOG2_PIXELS_TO_AVG));
        green_var_o  <= std_logic_vector(shift_right(green_mean_absdiff_s,LOG2_PIXELS_TO_AVG));
        blue_var_o   <= std_logic_vector(shift_right(blue_mean_absdiff_s, LOG2_PIXELS_TO_AVG));

        red_sum_s            <= (others => '0');
        green_sum_s          <= (others => '0');
        blue_sum_s           <= (others => '0');
        red_mean_absdiff_s   <= (others => '0');
        green_mean_absdiff_s <= (others => '0');
        blue_mean_absdiff_s  <= (others => '0');
      end if;
      if resetn = '0' then
        num_pixels_s <= to_unsigned(0, num_pixels_s'length)-PIXELS_PER_CLOCK;
        red_mean_s   <= (others => '0');
        green_mean_s <= (others => '0');
        blue_mean_s  <= (others => '0');
        red_var_o    <= (others => '0');
        green_var_o  <= (others => '0');
        blue_var_o   <= (others => '0');

        red_sum_s            <= (others => '0');
        green_sum_s          <= (others => '0');
        blue_sum_s           <= (others => '0');
        red_mean_absdiff_s   <= (others => '0');
        green_mean_absdiff_s <= (others => '0');
        blue_mean_absdiff_s  <= (others => '0');

      end if;

    end if;
  end process;
  red_mean_o   <= std_logic_vector(red_mean_s);
  green_mean_o <= std_logic_vector(green_mean_s);
  blue_mean_o  <= std_logic_vector(blue_mean_s);

end architecture rtl;
