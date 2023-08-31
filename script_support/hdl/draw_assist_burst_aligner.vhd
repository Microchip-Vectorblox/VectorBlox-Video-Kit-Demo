library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.draw_assist_pkg.all;

-------------------------------------------------------------------------------
-- Align OIMM bursts.
-------------------------------------------------------------------------------

entity draw_assist_burst_aligner is
  generic (
    ADDRESS_WIDTH    : positive;
    DATA_WIDTH       : positive;
    LOG2_BURSTLENGTH : positive;

    BURST_ALIGNMENT_WIDTH       : positive;
    MAX_ALIGNED_READS_IN_FLIGHT : positive
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    slave_address            : in  std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    slave_burstlength_minus1 : in  std_logic_vector(imax(1, log2_f((2**LOG2_BURSTLENGTH)-imax(0, (BURST_ALIGNMENT_WIDTH/DATA_WIDTH)-1)))-1 downto 0) := (others => '0');
    slave_requestvalid       : in  std_logic;
    slave_readnotwrite       : in  std_logic;
    slave_byteenable         : in  std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    slave_writelast          : in  std_logic;
    slave_readdatavalid      : out std_logic;
    slave_readcomplete       : out std_logic;
    slave_waitrequest        : out std_logic;

    master_address            : out    std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    master_burstlength_minus1 : buffer std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    master_requestvalid       : out    std_logic;
    master_readnotwrite       : out    std_logic;
    master_byteenable         : out    std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    master_writelast          : buffer std_logic;
    master_readdatavalid      : in     std_logic;
    master_readcomplete       : in     std_logic;
    master_waitrequest        : in     std_logic
    );
end entity draw_assist_burst_aligner;

architecture rtl of draw_assist_burst_aligner is
begin
  no_alignment_needed_gen : if BURST_ALIGNMENT_WIDTH <= DATA_WIDTH generate
    master_address            <= slave_address;
    master_burstlength_minus1 <= slave_burstlength_minus1;
    master_requestvalid       <= slave_requestvalid;
    master_readnotwrite       <= slave_readnotwrite;
    master_byteenable         <= slave_byteenable;
    master_writelast          <= slave_writelast;
    slave_readdatavalid       <= master_readdatavalid;
    slave_readcomplete        <= master_readcomplete;
    slave_waitrequest         <= master_waitrequest;
  end generate no_alignment_needed_gen;
  alignment_gen : if BURST_ALIGNMENT_WIDTH > DATA_WIDTH generate
    constant BURST_ALIGNMENT_BYTES : positive := BURST_ALIGNMENT_WIDTH/8;
    constant ALIGNMENT_WORDS       : positive := BURST_ALIGNMENT_WIDTH/DATA_WIDTH;

    signal start_word_alignment     : unsigned(log2(ALIGNMENT_WORDS)-1 downto 0);
    signal aligned_burst_end        : unsigned(LOG2_BURSTLENGTH-1 downto 0);
    signal request_length_unaligned : std_logic;

    signal unaligned_read_in_flight         : std_logic;
    signal return_past_end_of_burst         : std_logic;
    signal return_start_words_to_ignore     : unsigned(log2(ALIGNMENT_WORDS)-1 downto 0);
    signal return_start_words_to_ignore_any : std_logic;

    signal return_wordsleft_minus1 : unsigned(slave_burstlength_minus1'range);
    signal return_wordsleft_one    : std_logic;

    signal aligned_reads_in_flight_any : std_logic;
    signal aligned_reads_in_flight     : unsigned(log2(MAX_ALIGNED_READS_IN_FLIGHT+1)-1 downto 0);
    signal aligned_reads_in_flight_max : std_logic;

    signal master_beat_count  : unsigned(LOG2_BURSTLENGTH-1 downto 0);
    signal slave_beat_address : unsigned(log2(ALIGNMENT_WORDS)-1 downto 0);
    signal write_beat_match   : std_logic;
    signal write_preamble     : std_logic;
    signal write_postamble    : std_logic;
    signal write_padding      : std_logic;
  begin
    master_address(ADDRESS_WIDTH-1 downto log2(BURST_ALIGNMENT_BYTES)) <=
      slave_address(ADDRESS_WIDTH-1 downto log2(BURST_ALIGNMENT_BYTES));
    master_address(log2(BURST_ALIGNMENT_BYTES)-1 downto 0) <= (others => '0');

    start_word_alignment <=
      unsigned(slave_address(log2(DATA_WIDTH/8)+log2(ALIGNMENT_WORDS)-1 downto log2(DATA_WIDTH/8)));
    aligned_burst_end <= resize(start_word_alignment, LOG2_BURSTLENGTH) +
                         resize(unsigned(slave_burstlength_minus1), LOG2_BURSTLENGTH);
    master_burstlength_minus1 <=
      std_logic_vector(aligned_burst_end(LOG2_BURSTLENGTH-1 downto log2(ALIGNMENT_WORDS)) &
                       to_unsigned(ALIGNMENT_WORDS-1, log2(ALIGNMENT_WORDS)));

    request_length_unaligned <= '1' when (resize(unsigned(slave_burstlength_minus1), log2(ALIGNMENT_WORDS)) /=
                                          to_unsigned(ALIGNMENT_WORDS-1, log2(ALIGNMENT_WORDS))) else
                                '0';

    slave_waitrequest <=
      master_waitrequest or unaligned_read_in_flight or aligned_reads_in_flight_max when
      slave_readnotwrite = '1' else
      master_waitrequest or (write_preamble and (not write_beat_match)) or (slave_writelast and (not master_writelast));
    master_requestvalid <=
      slave_requestvalid and (not unaligned_read_in_flight) and (not aligned_reads_in_flight_max) when
      slave_readnotwrite = '1' else
      slave_requestvalid;

    master_readnotwrite <= slave_readnotwrite;


    ------------------------------------------------------------------------------
    -- Read alignment
    ------------------------------------------------------------------------------
    process (clk) is
    begin
      if rising_edge(clk) then
        if (slave_requestvalid = '1' and
            slave_readnotwrite = '1' and
            master_waitrequest = '0' and
            unaligned_read_in_flight = '0' and
            aligned_reads_in_flight_max = '0') then
          if (start_word_alignment /= to_unsigned(0, start_word_alignment'length) or
              request_length_unaligned = '1') then
            unaligned_read_in_flight <= '1';

            return_past_end_of_burst <= '0';

            return_start_words_to_ignore     <= start_word_alignment;
            return_start_words_to_ignore_any <= '1';
            if start_word_alignment = to_unsigned(0, start_word_alignment'length) then
              return_start_words_to_ignore_any <= '0';
            end if;

            return_wordsleft_minus1 <= unsigned(slave_burstlength_minus1);
            return_wordsleft_one    <= '0';
            if unsigned(slave_burstlength_minus1) = to_unsigned(0, slave_burstlength_minus1'length) then
              return_wordsleft_one <= '1';
            end if;
          else
            aligned_reads_in_flight_any <= '1';
            if master_readcomplete = '0' then
              aligned_reads_in_flight <=
                aligned_reads_in_flight + to_unsigned(1, aligned_reads_in_flight'length);
              if (aligned_reads_in_flight =
                  to_unsigned(MAX_ALIGNED_READS_IN_FLIGHT-1, aligned_reads_in_flight'length)) then
                aligned_reads_in_flight_max <= '1';
              end if;
            end if;
          end if;
        else
          if master_readcomplete = '1' then
            aligned_reads_in_flight_max <= '0';
            if aligned_reads_in_flight = to_unsigned(1, aligned_reads_in_flight'length) then
              aligned_reads_in_flight_any <= '0';
            end if;
            if aligned_reads_in_flight_any = '1' then
              aligned_reads_in_flight <= aligned_reads_in_flight -
                                         to_unsigned(1, aligned_reads_in_flight'length);
            end if;
          end if;
        end if;

        if unaligned_read_in_flight = '1' and aligned_reads_in_flight_any = '0' then
          if master_readdatavalid = '1' then
            if return_start_words_to_ignore_any = '1' then
              return_start_words_to_ignore <= return_start_words_to_ignore -
                                              to_unsigned(1, return_start_words_to_ignore'length);
              if return_start_words_to_ignore = to_unsigned(1, return_start_words_to_ignore'length) then
                return_start_words_to_ignore_any <= '0';
              end if;
            else
              if return_past_end_of_burst = '1' then
                if master_readcomplete = '1' then
                  unaligned_read_in_flight <= '0';
                end if;
              else
                if return_wordsleft_one = '1' then
                  return_past_end_of_burst <= '1';
                  if master_readcomplete = '1' then
                    unaligned_read_in_flight <= '0';
                  end if;
                end if;
                return_wordsleft_one <= '0';
                if return_wordsleft_minus1 = to_unsigned(1, return_wordsleft_minus1'length) then
                  return_wordsleft_one <= '1';
                end if;
                return_wordsleft_minus1 <= return_wordsleft_minus1 - to_unsigned(1, return_wordsleft_minus1'length);
              end if;
            end if;
          end if;

          if master_readcomplete = '1' then
            unaligned_read_in_flight <= '0';
          end if;
        end if;

        if resetn = '0' then
          unaligned_read_in_flight    <= '0';
          aligned_reads_in_flight_max <= '0';
          aligned_reads_in_flight_any <= '0';
          aligned_reads_in_flight     <= to_unsigned(0, aligned_reads_in_flight'length);
        end if;
      end if;
    end process;

    slave_readdatavalid <=
      master_readdatavalid when (aligned_reads_in_flight_any = '1' or
                                 (return_start_words_to_ignore_any = '0' and return_past_end_of_burst = '0')) else
      '0';

    slave_readcomplete <=
      master_readcomplete  when aligned_reads_in_flight_any = '1' else
      master_readdatavalid when return_start_words_to_ignore_any = '0' and return_wordsleft_one = '1' else
      '0';


    ------------------------------------------------------------------------------
    -- Write alignment
    ------------------------------------------------------------------------------
    process (clk) is
    begin
      if rising_edge(clk) then
        if slave_requestvalid = '1' and slave_readnotwrite = '0' and master_waitrequest = '0' then
          master_beat_count <= master_beat_count + to_unsigned(1, master_beat_count'length);

          if slave_writelast = '1' and (write_preamble = '0' or write_beat_match = '1') then
            write_postamble <= '1';
          end if;

          if write_beat_match = '1' then
            write_preamble <= '0';
          end if;

          if (master_beat_count =
              unsigned(master_burstlength_minus1) - to_unsigned(1, master_burstlength_minus1'length)) then
            master_writelast <= '1';
          end if;

          if master_writelast = '1' then
            master_beat_count <= to_unsigned(0, master_beat_count'length);
            write_preamble    <= '1';
            write_postamble   <= '0';
            master_writelast  <= '0';
          end if;
        end if;

        if resetn = '0' then
          master_beat_count <= to_unsigned(0, master_beat_count'length);
          write_preamble    <= '1';
          write_postamble   <= '0';
          master_writelast  <= '0';
        end if;
      end if;
    end process;

    slave_beat_address <= unsigned(slave_address(log2(BURST_ALIGNMENT_BYTES)-1 downto log2(DATA_WIDTH/8)));
    write_beat_match   <= '1' when master_beat_count(slave_beat_address'range) = slave_beat_address else '0';
    write_padding      <= (write_preamble and (not write_beat_match)) or write_postamble;

    master_byteenable <=
      slave_byteenable when write_padding = '0' else
      (others => '0');

  end generate alignment_gen;
end architecture rtl;
