library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.draw_assist_pkg.all;

-------------------------------------------------------------------------------
-- Write burst buffer
--
-- Buffers writedata until a full burst is available to send out.  Currently
-- only set up for write-only interface.
-------------------------------------------------------------------------------

entity draw_assist_write_burst_buffer is
  generic (
    ADDRESS_WIDTH    : positive;
    DATA_WIDTH       : positive;
    LOG2_BURSTLENGTH : natural
    );
  port (
    clk    : in std_logic;
    resetn : in std_logic;

    slave_address            : in     std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    slave_burstlength_minus1 : in     std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    slave_byteenable         : in     std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    slave_requestvalid       : in     std_logic;
    slave_writedata          : in     std_logic_vector(DATA_WIDTH-1 downto 0);
    slave_writelast          : in     std_logic;
    slave_waitrequest        : buffer std_logic;

    master_address            : out    std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    master_burstlength_minus1 : out    std_logic_vector(LOG2_BURSTLENGTH-1 downto 0);
    master_byteenable         : out    std_logic_vector((DATA_WIDTH/8)-1 downto 0);
    master_requestvalid       : buffer std_logic;
    master_writedata          : out    std_logic_vector(DATA_WIDTH-1 downto 0);
    master_writelast          : buffer std_logic;
    master_waitrequest        : in     std_logic
    );
end entity draw_assist_write_burst_buffer;

architecture rtl of draw_assist_write_burst_buffer is
  constant BEAT_FIFO_WIDTH  : positive := 1+(DATA_WIDTH/8)+DATA_WIDTH;
  signal beat_fifo_we       : std_logic;
  signal beat_fifo_data_in  : std_logic_vector(BEAT_FIFO_WIDTH-1 downto 0);
  signal beat_fifo_wrfull   : std_logic;
  signal beat_fifo_rd       : std_logic;
  signal beat_fifo_data_out : std_logic_vector(BEAT_FIFO_WIDTH-1 downto 0);
  signal beat_fifo_rdempty  : std_logic;

  constant BURST_FIFO_WIDTH  : positive := LOG2_BURSTLENGTH+ADDRESS_WIDTH;
  signal burst_fifo_we       : std_logic;
  signal burst_fifo_data_in  : std_logic_vector(BURST_FIFO_WIDTH-1 downto 0);
  signal burst_fifo_wrfull   : std_logic;
  signal burst_fifo_rd       : std_logic;
  signal burst_fifo_data_out : std_logic_vector(BURST_FIFO_WIDTH-1 downto 0);
  signal burst_fifo_rdempty  : std_logic;
begin
  ------------------------------------------------------------------------------
  -- Beat FIFO
  ------------------------------------------------------------------------------
  slave_waitrequest <= beat_fifo_wrfull;

  beat_fifo_data_in <= slave_writelast & slave_byteenable & slave_writedata;
  beat_fifo_we      <= slave_requestvalid and (not slave_waitrequest);
  da_beat_fifo : entity work.draw_assist_fifo_sync
    generic map (
      WIDTH => BEAT_FIFO_WIDTH,
      DEPTH => 2**LOG2_BURSTLENGTH
      )
    port map (
      clk    => clk,
      resetn => resetn,

      we      => beat_fifo_we,
      data_in => beat_fifo_data_in,
      wrfull  => beat_fifo_wrfull,

      rd       => beat_fifo_rd,
      data_out => beat_fifo_data_out,
      rdempty  => beat_fifo_rdempty
      );
  beat_fifo_rd      <= master_requestvalid and (not master_waitrequest);
  master_writedata  <= beat_fifo_data_out(DATA_WIDTH-1 downto 0);
  master_byteenable <= beat_fifo_data_out(DATA_WIDTH+(DATA_WIDTH/8)-1 downto DATA_WIDTH);
  master_writelast  <= beat_fifo_data_out(DATA_WIDTH+(DATA_WIDTH/8));


  ------------------------------------------------------------------------------
  -- Burst FIFO
  ------------------------------------------------------------------------------
  burst_fifo_data_in <= slave_burstlength_minus1 & slave_address;
  burst_fifo_we      <= slave_requestvalid and slave_writelast and (not slave_waitrequest);
  da_burst_fifo : entity work.draw_assist_fifo_sync
    generic map (
      WIDTH => BURST_FIFO_WIDTH,
      DEPTH => 2**LOG2_BURSTLENGTH
      )
    port map (
      clk    => clk,
      resetn => resetn,

      we      => burst_fifo_we,
      data_in => burst_fifo_data_in,
      wrfull  => burst_fifo_wrfull,

      rd       => burst_fifo_rd,
      data_out => burst_fifo_data_out,
      rdempty  => burst_fifo_rdempty
      );
  burst_fifo_rd             <= master_requestvalid and master_writelast and (not master_waitrequest);
  master_address            <= burst_fifo_data_out(ADDRESS_WIDTH-1 downto 0);
  master_burstlength_minus1 <= burst_fifo_data_out(ADDRESS_WIDTH+LOG2_BURSTLENGTH-1 downto ADDRESS_WIDTH);

  master_requestvalid <= not burst_fifo_rdempty;

end architecture rtl;
