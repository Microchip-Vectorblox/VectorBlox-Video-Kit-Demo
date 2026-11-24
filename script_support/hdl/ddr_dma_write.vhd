library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.ddr_dma_pkg.all;

entity ddr_dma_write is
  generic (
    DATA_WIDTH          : positive := 8;
    ADDRESS_WIDTH       : positive := 32;
    MAX_BURST_LENGTH     : positive := 256;
    MAX_LINE_SIZE       : positive :=1920;
    STRIDE_ISBYTES      : natural := 0;

    MEMORY_ADDRESS_WIDTH       : positive := 32;
    MEMORY_DATA_WIDTH          : positive := 512
    );
  port (
    -- Video Native Target Intrface
    clk        : in std_logic;
    resetn     : in std_logic;

    config_frame_address_i   : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    --config_frame_size_i      : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    config_line_stride_i     : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);
    --config_line_size_i       : in std_logic_vector(ADDRESS_WIDTH-1 downto 0);

    target_data_i          : in std_logic_vector(DATA_WIDTH-1 downto 0);
    target_data_valid_i    : in std_logic;
    target_frame_sync_i    : in std_logic;

    --Memory-Mapped Initiators
    aclk            : in std_logic;
    aresetn         : in std_logic;

    initiator_waitrequest_i        : in std_logic;
    initiator_requestvalid_o       : out std_logic;
    initiator_address_o            : out std_logic_vector(MEMORY_ADDRESS_WIDTH-1 downto 0);
    initiator_burstlength_o        : out std_logic_vector(7 downto 0);
    initiator_writedata_o          : out std_logic_vector(MEMORY_DATA_WIDTH-1 downto 0);
    initiator_byteenable_o         : out std_logic_vector(MEMORY_DATA_WIDTH/8-1 downto 0);
    initiator_writelast_o          : out std_logic;
    initiator_writecomplete_i      : in std_logic
  );
end entity ddr_dma_write;

architecture rtl of ddr_dma_write is

  
  constant MEMORY_DATA_BYTES    : positive := MEMORY_DATA_WIDTH/8;
  constant FIFO_DEPTH           : positive := 2**log2((MAX_LINE_SIZE*DATA_WIDTH)/MEMORY_DATA_WIDTH);
  constant DMA_LENGTH_WIDTH     : positive := imax(9,log2(FIFO_DEPTH));
  constant META_DATA_WIDTH      : positive := MEMORY_ADDRESS_WIDTH + 8 + 2*(log2(MEMORY_DATA_WIDTH/8)) + 2;
  constant ADDRLSB              : positive := log2(MEMORY_DATA_WIDTH);
  constant CDC_DATA_WIDTH       : positive := MEMORY_ADDRESS_WIDTH + DMA_LENGTH_WIDTH + log2(MEMORY_DATA_BYTES);
  constant ONE                  : positive := 1;

  type dma_state_type is (IDLE, WRITE_ALIGN, WRITE_REQUEST, WRITE_DATA, WRITE_BURST_COMPLETE, WRITE_COMPLETE);
  subtype memory_address_type is unsigned(MEMORY_ADDRESS_WIDTH-1 downto 0);
  subtype dma_length_type is unsigned(DMA_LENGTH_WIDTH-1 downto 0);
  type data_array_type is array (natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);

  signal target_frame_sync       : std_logic;
  signal target_data_valid       : std_logic;
  signal target_data             : std_logic_vector(DATA_WIDTH-1 downto 0);
  signal target_line_end     : std_logic;
  signal target_line_start   : std_logic;
  signal target_line_end_d   : std_logic_vector(1 downto 0);

  signal data_array : data_array_type(MEMORY_DATA_WIDTH/DATA_WIDTH-1 downto 0);
  signal data_count : unsigned(log2(MEMORY_DATA_WIDTH/DATA_WIDTH)-1 downto 0);
  signal data_byte_count : unsigned(log2(MEMORY_DATA_BYTES)-1 downto 0);

  signal cfg_memory_address                : memory_address_type;
  signal cfg_line_stride                   : memory_address_type;

  signal target_cdc_data       : std_logic_vector(CDC_DATA_WIDTH-1 downto 0);
  signal awrite_cdc_data       : std_logic_vector(CDC_DATA_WIDTH-1 downto 0);
  signal xd_frame_sync         : std_logic_vector(1 downto 0);

  signal fifo_write_resetn        : std_logic;
  signal fifo_write_enable        : std_logic;
  signal fifo_write_count         : dma_length_type;
  signal fifo_write_full          : std_logic;
	signal fifo_write_data          : std_logic_vector(MEMORY_DATA_WIDTH-1 downto 0);

  signal fifo_read_resetn        : std_logic;
  signal fifo_read_enable        : std_logic;
  signal fifo_read_empty         : std_logic;
  signal fifo_read_valid         : std_logic;
	signal fifo_read_data          : std_logic_vector(MEMORY_DATA_WIDTH-1 downto 0);

  signal skid_valid              : std_logic;
  signal skid_ready              : std_logic;
  signal skid_data               : std_logic_vector(MEMORY_DATA_WIDTH-1 downto 0);

  signal awrite_state            : dma_state_type;
  signal awrite_frame_sync       : std_logic;
  signal awrite_start            : std_logic;
  signal awrite_length           : dma_length_type;
  signal awrite_address          : unsigned(MEMORY_ADDRESS_WIDTH-1 downto 0);
  signal awrite_trailing_bytes   : unsigned(log2(MEMORY_DATA_BYTES)-1 downto 0);

  signal awrite_ready             : std_logic;
  signal awrite_valid             : std_logic;
  signal awrite_first             : std_logic;
  signal awrite_last              : std_logic;
  signal awrite_remaining         : dma_length_type;
  signal awrite_leading_zeros     : unsigned(log2(MEMORY_DATA_WIDTH/8)-1 downto 0);
  signal awrite_trailing_zeros    : unsigned(log2(MEMORY_DATA_WIDTH/8)-1 downto 0);

  signal awrite_burst_length            : unsigned(7 downto 0);
  signal awrite_burst_remaining         : dma_length_type;
  signal awrite_burst_address           : memory_address_type;
  signal awrite_burst_leading_zeros     : unsigned(log2(MEMORY_DATA_WIDTH/8)-1 downto 0);
  signal awrite_burst_trailing_zeros    : unsigned(log2(MEMORY_DATA_WIDTH/8)-1 downto 0);

  signal initiator_address            : std_logic_vector(MEMORY_ADDRESS_WIDTH-1 downto 0);
  signal initiator_burstlength        : std_logic_vector(7 downto 0);
  signal initiator_byteenable         : std_logic_vector(MEMORY_DATA_WIDTH/8-1 downto 0);
  signal initiator_requestvalid       : std_logic;
  signal initiator_waitrequest        : std_logic;
  signal initiator_writedata          : std_logic_vector(MEMORY_DATA_WIDTH-1 downto 0);
  signal initiator_writelast          : std_logic;
  signal initiator_writecomplete      : std_logic;

  signal burst_start_alignment     : unsigned(12-log2(MEMORY_DATA_WIDTH/8)-1 downto 0);
  signal burst_boundary            : unsigned(12-log2(MEMORY_DATA_WIDTH/8)-1 downto 0);
  signal length_to_boundary        : unsigned(12-log2(MEMORY_DATA_WIDTH/8)-1 downto 0);
  signal awrite_bytes_this_burst   : memory_address_type;

begin

  ------------------------------------------------------------------------------------------------
  -- Memory Address Update
  ------------------------------------------------------------------------------------------------
  process (clk) is
    begin
      if rising_edge(clk) then
        if (target_frame_sync = '1') then
          cfg_memory_address <= resize(unsigned(config_frame_address_i), MEMORY_ADDRESS_WIDTH);
          cfg_line_stride    <= resize(unsigned(config_line_stride_i), MEMORY_ADDRESS_WIDTH) when  (STRIDE_ISBYTES = 1) else 
                                resize(unsigned(config_line_stride_i) * to_unsigned(DATA_WIDTH/8, MEMORY_ADDRESS_WIDTH), MEMORY_ADDRESS_WIDTH);
        elsif (target_line_end_d(1) = '1') then
          cfg_memory_address <= cfg_memory_address + cfg_line_stride;
        end if;
      end if;
    end process;


  ------------------------------------------------------------------------------------------------
  -- Input register and Data Packer
  ------------------------------------------------------------------------------------------------
  process (clk) is
  begin
    if rising_edge(clk) then
      target_frame_sync <= target_frame_sync_i;
      target_data_valid <= target_data_valid_i;
      target_data       <= target_data_i;
      target_line_end_d <= (target_line_end_d(0), target_line_end);

      if target_line_start = '1' then
        fifo_write_count <= (others => '0');
        data_count <= unsigned(cfg_memory_address(log2(MEMORY_DATA_WIDTH/DATA_WIDTH)-1 downto 0));
        data_byte_count <= unsigned(cfg_memory_address(log2(MEMORY_DATA_WIDTH/8)-1 downto 0));
      elsif target_data_valid = '1' then
        data_count <= data_count + to_unsigned(1, data_count'length);
        data_byte_count <= data_byte_count + to_unsigned(DATA_WIDTH/8, data_byte_count'length);
      end if;

      fifo_write_enable <= '0';
      if (target_data_valid = '1' and data_count = to_unsigned(MEMORY_DATA_WIDTH/DATA_WIDTH-1, data_count'length)) or (target_line_end = '1') then
        fifo_write_enable <= '1';
        fifo_write_count <= fifo_write_count + to_unsigned(1, fifo_write_count'length);
      end if;
  
      if resetn = '0' then
        target_frame_sync <= '0';
        target_data_valid <= '0';
        data_count  <= (others => '0');
        data_byte_count  <= (others => '0');
        fifo_write_enable <= '0';
        target_line_end_d <= (others => '0');
      end if;
    end if;
  end process;

  target_line_start <= (target_data_valid_i) and (not target_data_valid);
  target_line_end <= (not target_data_valid_i) and target_data_valid;

  gen_data_packer : for gdata in 0 to MEMORY_DATA_WIDTH/DATA_WIDTH-1 generate
    process (clk) is
    begin
      if rising_edge(clk) then
        if target_data_valid = '1' and (data_count = to_unsigned(gdata, data_count'length)) then
            data_array(gdata) <= target_data;
        end if;
      end if;
    end process;

    fifo_write_data((gdata+1)*DATA_WIDTH-1 downto gdata*DATA_WIDTH) <= data_array(gdata);
  end generate gen_data_packer;

  ------------------------------------------------------------------------------------------------
  -- Data FIFO
  ------------------------------------------------------------------------------------------------
  process (clk) is
  begin
    if rising_edge(clk) then
      fifo_write_resetn <= '1';
      if (target_frame_sync = '1') then
        fifo_write_resetn <= '0';
      end if;
      if (resetn = '0') then
        fifo_write_resetn <= '0';
      end if;
    end if;
  end process;

  process (aclk) is
  begin
    if rising_edge(aclk) then
      fifo_read_resetn <= '1';
      if (awrite_frame_sync = '1') then
        fifo_read_resetn <= '0';
      end if;
      if (aresetn = '0') then
        fifo_read_resetn <= '0';
      end if;
    end if;
  end process;

  ddr_dma_fifo : entity work.ddr_dma_fifo
    generic map (
      ADDRESS_WIDTH => log2(FIFO_DEPTH),
      DATA_WIDTH    => MEMORY_DATA_WIDTH
      )
    port map (
      wclock_i         => clk,
      wresetn_i        => fifo_write_resetn,
      wen_i            => fifo_write_enable,
      wdata_i          => fifo_write_data,
      wfull_o          => fifo_write_full,
	    
      rclock_i         => aclk,
	    rresetn_i        => fifo_read_resetn,
	    ren_i            => fifo_read_enable,
	    rdata_o          => fifo_read_data,
	    rempty_o         => fifo_read_empty,
      rdata_rdy_o      => fifo_read_valid
    );

  ddr_dma_skid_buffer :  entity work.ddr_dma_skid_buffer
    generic map (
      DATA_WIDTH  => MEMORY_DATA_WIDTH
    )
    port map(
      clk            => aclk,
      resetn         => aresetn,
    
      valid_i        => fifo_read_valid,
      data_i         => fifo_read_data,
      ready_o        => open,
        
      valid_o        => open,
      data_o         => skid_data,
      ready_i        => awrite_ready
    );

  ------------------------------------------------------------------------------------------------
  -- Clock Domain Crossing
  ------------------------------------------------------------------------------------------------
  target_cdc_data <= (std_logic_vector(data_byte_count), 
                      std_logic_vector(fifo_write_count), 
                      std_logic_vector(cfg_memory_address));

  -- Hand shake and hold clock domain crossing
  ddr_dma_cdc : entity work.ddr_dma_cdc
    generic map(
      DATA_WIDTH => CDC_DATA_WIDTH
    )
    port map(
      from_clk            => clk,
      from_resetn         => resetn,
      from_valid_pulse_i  => target_line_end_d(0),
      from_data_i         => target_cdc_data,
      
      to_clk              => aclk,
      to_resetn           => aresetn,
      to_valid_pulse_o    => awrite_start,
      to_data_o           => awrite_cdc_data
    );

  (awrite_trailing_bytes,
   awrite_length,
   awrite_address) <= unsigned(awrite_cdc_data);

  process (aclk) is
  begin
    if rising_edge(aclk) then
      xd_frame_sync <= (xd_frame_sync(0) & target_frame_sync); --2 register clock sync
    end if;
  end process;
    
  awrite_frame_sync <= xd_frame_sync(1);

  ------------------------------------------------------------------------------------------------
  -- Write Controller
  ------------------------------------------------------------------------------------------------
  -- Check for 4k Boundary crossing
  burst_boundary <= (others => '1');
  burst_start_alignment <= unsigned(awrite_burst_address(11 downto log2(MEMORY_DATA_WIDTH/8)));
  length_to_boundary <= burst_boundary - burst_start_alignment;
  
  process (aclk) is
  begin
    if rising_edge(aclk) then
      if awrite_frame_sync = '1' then
        awrite_state <= IDLE;
      else
        case awrite_state is
          when IDLE =>
            awrite_valid <= '0';
            awrite_first <= '0';
            awrite_last  <= '0';

            if awrite_start = '1' then
              awrite_burst_address(log2(MEMORY_DATA_WIDTH/8)-1 downto 0)  <= (others => '0');
              awrite_burst_address(MEMORY_ADDRESS_WIDTH-1 downto log2(MEMORY_DATA_WIDTH/8))  <= awrite_address(MEMORY_ADDRESS_WIDTH-1 downto log2(MEMORY_DATA_WIDTH/8));
              awrite_remaining      <= awrite_length;
              awrite_leading_zeros  <= awrite_address(log2(MEMORY_DATA_WIDTH/8)-1 downto 0);
              awrite_burst_leading_zeros  <= awrite_address(log2(MEMORY_DATA_WIDTH/8)-1 downto 0);
              awrite_trailing_zeros <= to_unsigned((MEMORY_DATA_WIDTH/8),log2(MEMORY_DATA_WIDTH/8)) - awrite_trailing_bytes;
              awrite_state  <= WRITE_REQUEST;
            end if;
          when WRITE_REQUEST =>
            awrite_valid <= '1';
            awrite_first <= '1';

            if awrite_remaining > resize(length_to_boundary, DMA_LENGTH_WIDTH) then
              awrite_remaining             <= awrite_remaining - (resize(length_to_boundary, DMA_LENGTH_WIDTH) + to_unsigned(1, DMA_LENGTH_WIDTH));
              awrite_burst_remaining       <= resize(length_to_boundary, DMA_LENGTH_WIDTH) + to_unsigned(1, DMA_LENGTH_WIDTH);
              awrite_burst_length          <= resize(length_to_boundary, 8);
              awrite_burst_trailing_zeros  <= (others => '0');
              if resize(length_to_boundary, DMA_LENGTH_WIDTH) = to_unsigned(0, DMA_LENGTH_WIDTH)then
                awrite_last  <= '1';
              end if;
            elsif awrite_remaining > to_unsigned(MAX_BURST_LENGTH, DMA_LENGTH_WIDTH) then
              awrite_remaining   <= awrite_remaining - to_unsigned(MAX_BURST_LENGTH, DMA_LENGTH_WIDTH);
              awrite_burst_remaining <= to_unsigned(MAX_BURST_LENGTH, DMA_LENGTH_WIDTH);
              awrite_burst_length     <= to_unsigned(MAX_BURST_LENGTH-1, 8);
              awrite_burst_trailing_zeros  <= (others => '0');
              if MAX_BURST_LENGTH = ONE then
                awrite_last  <= '1';
              end if;
            else
              awrite_remaining <= to_unsigned(0, DMA_LENGTH_WIDTH);
              awrite_burst_remaining <=  awrite_remaining;
              awrite_burst_length <= resize(awrite_remaining, 8) - to_unsigned(1, 8);
              awrite_burst_trailing_zeros <= awrite_trailing_zeros;
              if awrite_remaining = to_unsigned(1, awrite_remaining'length)then
                awrite_last  <= '1';
              end if;
            end if;

            awrite_state  <= WRITE_DATA;
          when WRITE_DATA =>
            if(awrite_ready) then
              awrite_first <= '0';
              awrite_burst_remaining <= awrite_burst_remaining - to_unsigned(1, DMA_LENGTH_WIDTH);
              awrite_bytes_this_burst <= (resize(awrite_burst_length, MEMORY_ADDRESS_WIDTH) + to_unsigned(1, MEMORY_ADDRESS_WIDTH)) sll log2(MEMORY_DATA_BYTES);

              if awrite_burst_remaining = to_unsigned(2, DMA_LENGTH_WIDTH) then
                awrite_last  <= '1';
              end if;
              if awrite_last = '1' then
                awrite_last  <= '0';
                awrite_valid <= '0';
                awrite_state <= WRITE_COMPLETE;
              end if;
            end if;
          when WRITE_COMPLETE =>
            if initiator_writecomplete = '1' then
              if awrite_remaining > to_unsigned(0, DMA_LENGTH_WIDTH) then
                awrite_burst_leading_zeros  <= (others => '0');
                awrite_burst_address <= awrite_burst_address + awrite_bytes_this_burst;
                awrite_state  <= WRITE_REQUEST;
              else
                awrite_state  <= IDLE;
              end if;
            end if;
          when others =>
            report "DDR Write Bad State" severity failure;
        end case;
      end if;

      if aresetn = '0' then
        awrite_valid <= '0';
        awrite_first <= '0';
        awrite_last  <= '0';
        awrite_state <= IDLE;
      end if;
    end if;
  end process;

  fifo_read_enable  <= awrite_valid and awrite_ready;
  awrite_ready <= (not initiator_waitrequest) or (not initiator_requestvalid);

  initiator_writedata    <= skid_data;

  process (aclk) is
  begin
    if rising_edge(aclk) then
      if awrite_ready = '1' then 
        initiator_requestvalid <= awrite_valid;
        initiator_address      <= std_logic_vector(awrite_burst_address);
        initiator_burstlength  <= std_logic_vector(awrite_burst_length);
        initiator_byteenable   <= decode_enables(awrite_first, awrite_last, awrite_burst_leading_zeros, awrite_burst_trailing_zeros);
        initiator_writelast    <= awrite_last;
      end if;

      if(aresetn = '0') then
        initiator_requestvalid <= '0';
      end if;
    end if;
  end process;

  -- IO's
  initiator_waitrequest   <= initiator_waitrequest_i;
  initiator_writecomplete <= initiator_writecomplete_i;
  initiator_requestvalid_o <= initiator_requestvalid;
  initiator_address_o      <= initiator_address;
  initiator_burstlength_o  <= initiator_burstlength;
  initiator_writedata_o    <= initiator_writedata;
  initiator_byteenable_o   <= initiator_byteenable;
  initiator_writelast_o    <= initiator_writelast;

end architecture rtl;   