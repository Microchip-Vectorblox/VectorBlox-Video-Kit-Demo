library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.draw_assist_pkg.all;

-------------------------------------------------------------------------------
-- Upsize an OIMM interface
--
-- All bursts must be aligned to the larger interface width.
-------------------------------------------------------------------------------

entity draw_assist_upsizer is
  generic (
    ADDRESS_WIDTH          : positive;
    SLAVE_DATA_WIDTH       : positive;
    SLAVE_LOG2_BURSTLENGTH : natural;
    MASTER_DATA_WIDTH      : positive;
    MIN_RETURN_FIFO_DEPTH  : positive;
    ID_BITS                : natural
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    slave_address            : in     std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    slave_burstlength_minus1 : in     std_logic_vector(imax(1, SLAVE_LOG2_BURSTLENGTH)-1 downto 0) := (others => '-');
    slave_byteenable         : in     std_logic_vector((SLAVE_DATA_WIDTH/8)-1 downto 0);
    slave_requestvalid       : in     std_logic;
    slave_requestvalid_id    : in     std_logic_vector(imax(0, ID_BITS-1) downto 0)                := (others => '-');
    slave_readnotwrite       : in     std_logic;
    slave_writedata          : in     std_logic_vector(SLAVE_DATA_WIDTH-1 downto 0);
    slave_writelast          : in     std_logic;
    slave_readdata           : out    std_logic_vector(SLAVE_DATA_WIDTH-1 downto 0);
    slave_readdatavalid      : buffer std_logic;
    slave_readdatavalid_id   : out    std_logic_vector(imax(0, ID_BITS-1) downto 0);
    slave_readcomplete       : out    std_logic;
    slave_waitrequest        : buffer std_logic;

    master_address            : out    std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    master_burstlength_minus1 : out    std_logic_vector(imax(1, (SLAVE_LOG2_BURSTLENGTH-log2(MASTER_DATA_WIDTH/SLAVE_DATA_WIDTH)))-1 downto 0) := (others => '-');
    master_byteenable         : buffer std_logic_vector((MASTER_DATA_WIDTH/8)-1 downto 0);
    master_requestvalid       : buffer std_logic;
    master_requestvalid_id    : out    std_logic_vector(imax(0, ID_BITS-1) downto 0);
    master_readnotwrite       : out    std_logic;
    master_writedata          : buffer std_logic_vector(MASTER_DATA_WIDTH-1 downto 0);
    master_writelast          : out    std_logic;
    master_readdata           : in     std_logic_vector(MASTER_DATA_WIDTH-1 downto 0);
    master_readdatavalid      : in     std_logic;
    master_readdatavalid_id   : in     std_logic_vector(imax(0, ID_BITS-1) downto 0)                                                           := (others => '-');
    master_readcomplete       : in     std_logic;
    master_waitrequest        : in     std_logic
    );
end entity draw_assist_upsizer;

architecture rtl of draw_assist_upsizer is
begin
  passthrough_gen : if MASTER_DATA_WIDTH = SLAVE_DATA_WIDTH generate
    master_address            <= slave_address;
    master_burstlength_minus1 <= slave_burstlength_minus1;
    master_byteenable         <= slave_byteenable;
    master_requestvalid       <= slave_requestvalid;
    master_requestvalid_id    <= slave_requestvalid_id;
    master_readnotwrite       <= slave_readnotwrite;
    master_writedata          <= slave_writedata;
    master_writelast          <= slave_writelast;
    slave_readdata            <= master_readdata;
    slave_readdatavalid       <= master_readdatavalid;
    slave_readdatavalid_id    <= master_readdatavalid_id;
    slave_readcomplete        <= master_readcomplete;
    slave_waitrequest         <= master_waitrequest;
  end generate passthrough_gen;
  upsize_gen : if MASTER_DATA_WIDTH > SLAVE_DATA_WIDTH generate
    constant SUB_BEATS    : positive := MASTER_DATA_WIDTH/SLAVE_DATA_WIDTH;
    signal write_sub_beat : unsigned(log2(SUB_BEATS)-1 downto 0);

    constant MASTER_LOG2_BURSTLENGTH : natural  := SLAVE_LOG2_BURSTLENGTH-log2(SUB_BEATS);
    constant RETURN_FIFO_DEPTH       : positive := imax(MIN_RETURN_FIFO_DEPTH, 2**MASTER_LOG2_BURSTLENGTH);
    constant RETURN_FIFO_WIDTH       : positive := ID_BITS+1+MASTER_DATA_WIDTH;

    signal max_reads_outstanding : std_logic;
    signal slave_remw_minus1     : signed(log2(RETURN_FIFO_DEPTH*SUB_BEATS) downto 0);

    signal return_fifo_remw     : unsigned(log2(RETURN_FIFO_DEPTH+1)-1 downto 0);
    signal return_fifo_write    : std_logic;
    signal return_fifo_data_in  : std_logic_vector(RETURN_FIFO_WIDTH-1 downto 0);
    signal return_fifo_wrfull   : std_logic;
    signal return_fifo_read     : std_logic;
    signal return_fifo_data_out : std_logic_vector(RETURN_FIFO_WIDTH-1 downto 0);
    signal return_fifo_rdempty  : std_logic;

    signal return_fifo_readdata_out         : std_logic_vector(MASTER_DATA_WIDTH-1 downto 0);
    signal return_fifo_readcomplete_out     : std_logic;
    signal return_fifo_readdatavalid_id_out : std_logic_vector(imax(0, ID_BITS-1) downto 0);

    signal return_shifter_ready      : std_logic;
    signal return_shifter_data       : std_logic_vector(MASTER_DATA_WIDTH-1 downto 0);
    signal return_sub_beat           : unsigned(log2(SUB_BEATS)-1 downto 0);
    signal return_readcomplete_burst : std_logic;
  begin
    slave_waitrequest <= (slave_readnotwrite and max_reads_outstanding) or
                         (master_requestvalid and master_waitrequest);

    nonzero_master_burstlength_minus1 : if MASTER_LOG2_BURSTLENGTH > 0 generate
      process (clk) is
      begin
        if rising_edge(clk) then
          if slave_requestvalid = '1' and slave_waitrequest = '0' then
            master_burstlength_minus1 <=
              slave_burstlength_minus1(slave_burstlength_minus1'left downto log2(MASTER_DATA_WIDTH/SLAVE_DATA_WIDTH));
          end if;
        end if;
      end process;
    end generate nonzero_master_burstlength_minus1;

    process (clk) is
    begin
      if rising_edge(clk) then
        if master_waitrequest = '0' then
          master_requestvalid <= '0';
        end if;

        if slave_requestvalid = '1' and slave_waitrequest = '0' then
          master_address(ADDRESS_WIDTH-1 downto log2(MASTER_DATA_WIDTH/8)) <=
            slave_address(ADDRESS_WIDTH-1 downto log2(MASTER_DATA_WIDTH/8));
          master_address(log2(MASTER_DATA_WIDTH/8)-1 downto 0) <= (others => '0');

          master_readnotwrite    <= slave_readnotwrite;
          master_requestvalid_id <= slave_requestvalid_id;

          if slave_readnotwrite = '1' then
            master_requestvalid <= '1';
          else
            if write_sub_beat = to_unsigned(SUB_BEATS-1, write_sub_beat'length) then
              master_requestvalid <= '1';
            end if;
            write_sub_beat <= write_sub_beat + to_unsigned(1, write_sub_beat'length);
          end if;

          master_writedata(master_writedata'left-SLAVE_DATA_WIDTH downto 0) <=
            master_writedata(master_writedata'left downto SLAVE_DATA_WIDTH);
          master_writedata(master_writedata'left downto master_writedata'length-SLAVE_DATA_WIDTH) <=
            slave_writedata;
          master_byteenable(master_byteenable'left-(SLAVE_DATA_WIDTH/8) downto 0) <=
            master_byteenable(master_byteenable'left downto SLAVE_DATA_WIDTH/8);
          master_byteenable(master_byteenable'left downto master_byteenable'length-(SLAVE_DATA_WIDTH/8)) <=
            slave_byteenable;

          master_writelast <= slave_writelast;
        end if;

        if resetn = '0' then
          write_sub_beat      <= to_unsigned(0, write_sub_beat'length);
          master_requestvalid <= '0';
        end if;
      end if;
    end process;


    ------------------------------------------------------------------------------
    -- Return room tracking
    ------------------------------------------------------------------------------
    max_reads_outstanding <=
      '1' when slave_remw_minus1 < signed(resize(unsigned(slave_burstlength_minus1), slave_remw_minus1'length)) else
      '0';

    process (clk) is
    begin
      if rising_edge(clk) then
        if slave_requestvalid = '1' and slave_waitrequest = '0' and slave_readnotwrite = '1' then
          if slave_readdatavalid = '1' then
            slave_remw_minus1 <= slave_remw_minus1 -
                                 signed(resize(unsigned(slave_burstlength_minus1), slave_remw_minus1'length));
          else
            slave_remw_minus1 <= slave_remw_minus1 -
                                 (signed(resize(unsigned(slave_burstlength_minus1), slave_remw_minus1'length)) +
                                  to_signed(1, slave_remw_minus1'length));
          end if;
        elsif slave_readdatavalid = '1' then
          slave_remw_minus1 <= slave_remw_minus1 + to_signed(1, slave_remw_minus1'length);
        end if;

        if resetn = '0' then
          slave_remw_minus1 <= to_signed((RETURN_FIFO_DEPTH*SUB_BEATS)-1, slave_remw_minus1'length);
        end if;
      end if;
    end process;


    ------------------------------------------------------------------------------
    -- Return FIFO
    ------------------------------------------------------------------------------
    return_fifo_write                                 <= master_readdatavalid;
    return_fifo_data_in(MASTER_DATA_WIDTH-1 downto 0) <= master_readdata;
    return_fifo_data_in(MASTER_DATA_WIDTH)            <= master_readcomplete;
    write_id_bits_gen : if ID_BITS > 0 generate
      return_fifo_data_in(MASTER_DATA_WIDTH+ID_BITS downto MASTER_DATA_WIDTH+1) <=
        master_readdatavalid_id;
    end generate write_id_bits_gen;

    return_fifo : entity work.draw_assist_fifo_sync
      generic map (
        WIDTH => RETURN_FIFO_WIDTH,
        DEPTH => RETURN_FIFO_DEPTH
        )
      port map (
        clk    => clk,
        resetn => resetn,

        remw => return_fifo_remw,

        we      => return_fifo_write,
        data_in => return_fifo_data_in,
        wrfull  => return_fifo_wrfull,

        rd       => return_fifo_read,
        data_out => return_fifo_data_out,
        rdempty  => return_fifo_rdempty
        );

    return_fifo_readdata_out     <= return_fifo_data_out(MASTER_DATA_WIDTH-1 downto 0);
    return_fifo_readcomplete_out <= return_fifo_data_out(MASTER_DATA_WIDTH);
    read_id_bits_gen : if ID_BITS > 0 generate
      return_fifo_readdatavalid_id_out <=
        return_fifo_data_out(MASTER_DATA_WIDTH+ID_BITS downto MASTER_DATA_WIDTH+1);
    end generate read_id_bits_gen;
    return_fifo_read <= (not return_fifo_rdempty) and return_shifter_ready;


    ------------------------------------------------------------------------------
    -- Return shifter
    ------------------------------------------------------------------------------
    process (clk) is
    begin
      if rising_edge(clk) then
        return_shifter_data(return_shifter_data'left-SLAVE_DATA_WIDTH downto 0) <=
          return_shifter_data(return_shifter_data'left downto SLAVE_DATA_WIDTH);

        slave_readcomplete <= '0';
        if slave_readdatavalid = '1' then
          if return_sub_beat = to_unsigned(SUB_BEATS-2, return_sub_beat'length) then
            return_shifter_ready <= '1';
            slave_readcomplete   <= return_readcomplete_burst;
          end if;
          if return_sub_beat = to_unsigned(SUB_BEATS-1, return_sub_beat'length) then
            slave_readdatavalid <= '0';
          end if;
          return_sub_beat <= return_sub_beat + to_unsigned(1, return_sub_beat'length);
        end if;

        if return_fifo_read = '1' then
          return_shifter_data       <= return_fifo_readdata_out;
          slave_readdatavalid_id    <= return_fifo_readdatavalid_id_out;
          return_readcomplete_burst <= return_fifo_readcomplete_out;
          return_shifter_ready      <= '0';
          slave_readdatavalid       <= '1';
        end if;

        if resetn = '0' then
          return_sub_beat      <= to_unsigned(0, return_sub_beat'length);
          return_shifter_ready <= '1';
          slave_readdatavalid  <= '0';
          slave_readcomplete   <= '0';
        end if;
      end if;
    end process;
    slave_readdata <= return_shifter_data(slave_readdata'range);
  end generate upsize_gen;

end architecture rtl;
