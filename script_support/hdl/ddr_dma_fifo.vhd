
--=================================================================================================
-- Libraries
--=================================================================================================
library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity ddr_dma_fifo is
  generic(
    ADDRESS_WIDTH          : integer := 12;
    DATA_WIDTH             : integer := 24
    );
  port(
-- Port list
    -- System reset
    wclock_i      : in  std_logic;
    wresetn_i     : in  std_logic;
    wen_i         : in  std_logic;
    wdata_i       : in  std_logic_vector(DATA_WIDTH-1 downto 0);
    wfull_o       : out std_logic;
    
    rclock_i      : in  std_logic;
    rresetn_i     : in  std_logic;
    ren_i         : in  std_logic;
    rdata_o       : out std_logic_vector(DATA_WIDTH-1 downto 0);
    rdata_rdy_o   : out std_logic;
    rempty_o      : out std_logic
    );
end ddr_dma_fifo;

architecture rtl of ddr_dma_fifo is

  constant FIFO_DEPTH : positive := 2**ADDRESS_WIDTH;

  signal rbin   : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal rptr   : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal rwptr1 : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal rwptr2 : std_logic_vector(ADDRESS_WIDTH downto 0);

  signal rempty       : std_logic;
  signal s_ren        : std_logic;
  signal wfull        : std_logic;
  signal wen          : std_logic;
  signal rwbin        : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal wbin         : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal wptr         : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal s_wrptr2_tmp : std_logic_vector(ADDRESS_WIDTH downto 0);

  signal wrptr1      : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal wrptr2      : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal wrbin       : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal raddr       : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal waddr       : std_logic_vector(ADDRESS_WIDTH-1 downto 0);
  signal rbnext      : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal rgnext      : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal wbnext      : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal wgnext      : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal wdiff_bus   : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal rdiff_bus   : std_logic_vector(ADDRESS_WIDTH downto 0);
  signal i           : integer;
  signal j           : integer;

  type ram_array is array (FIFO_DEPTH-1 downto 0) of std_logic_vector(DATA_WIDTH-1 downto 0);
  signal ram : ram_array;
  signal ram_rd_addr : unsigned (ADDRESS_WIDTH-1 downto 0);
  signal ram_wr_addr : unsigned (ADDRESS_WIDTH-1 downto 0);


begin

--=================================================================================================
-- Top level output port assignments
--=================================================================================================
  rdata_rdy_o   <= s_ren;
  wfull_o       <= wfull;
  raddr         <= rbin(ADDRESS_WIDTH - 1 downto 0);
  rbnext        <= rbin + (ren_i and not(rempty));
  rgnext        <= TO_STDLOGICVECTOR(TO_BITVECTOR(rbnext) srl 1) xor rbnext;
  wen           <= '1' when (wen_i = '1') and (wfull = '0') else '0';
  waddr         <= wbin(ADDRESS_WIDTH - 1 downto 0);
  wbnext        <= wbin + (wen_i and not(wfull));
  wgnext        <= TO_STDLOGICVECTOR(TO_BITVECTOR(wbnext) srl 1) xor wbnext;
  rempty_o      <= rempty;

--=================================================================================================
-- Asynchronous blocks
--=================================================================================================
  rdiff_bus    <= (rwbin - rbin);
  wdiff_bus    <= wbin - wrbin;
  s_wrptr2_tmp <= not(wrptr2(ADDRESS_WIDTH downto ADDRESS_WIDTH - 1))
                  & wrptr2(ADDRESS_WIDTH - 2 downto 0);
--------------------------------------------------------------------------
-- Name       : GRAY2BIN_PROC
-- Description: Process converts gray code to binary
--------------------------------------------------------------------------
  GRAY2BIN_PROC :
  process(rwptr2, rwbin)
  begin
    rwbin(ADDRESS_WIDTH) <= rwptr2(ADDRESS_WIDTH);
    for i in 0 to ADDRESS_WIDTH-1 loop
      rwbin(i) <= rwptr2(i) xor rwbin(i+1);
    end loop;
  end process;

--------------------------------------------------------------------------
-- Name       : GRAY2BIN_CONV
-- Description: Process implements gray to binary conversion
--------------------------------------------------------------------------
  GRAY2BIN_CONV :
  process(wrptr2, wrbin)
  begin
    wrbin(ADDRESS_WIDTH) <= wrptr2(ADDRESS_WIDTH);
    for j in 0 to ADDRESS_WIDTH-1 loop
      wrbin(j) <= wrptr2(j) xor wrbin(j+1);
    end loop;
  end process;




--=================================================================================================
-- Synchronous blocks
--=================================================================================================
--------------------------------------------------------------------------
-- Name       : READ_PTR_ASSIGN_PROC
-- Description: Process reads data
--------------------------------------------------------------------------
  DELAY :
  process(rclock_i, rresetn_i)
  begin
    if rresetn_i = '0' then
      s_ren <= '0';
    elsif(rising_edge(rclock_i))then
      s_ren <= ren_i;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : READ_PTR_ASSIGN_PROC
-- Description: Process reads data
--------------------------------------------------------------------------
  READ_PTR_ASSIGN_PROC :
  process(rclock_i, rresetn_i)
  begin
    if rresetn_i = '0' then
      rbin <= (others => '0');
      rptr <= (others => '0');
    elsif(rising_edge(rclock_i))then
      rbin <= rbnext;
      rptr <= rgnext;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : SYNC_WRPTR_RDCLK_PROC
-- Description: Process synchronizes write pointer to read clock domain
--------------------------------------------------------------------------
  SYNC_WRPTR_RDCLK_PROC :
  process(rclock_i, rresetn_i)
  begin
    if rresetn_i = '0' then
      rwptr1 <= (others => '0');
      rwptr2 <= (others => '0');
    elsif(rising_edge(rclock_i))then
      rwptr1 <= wptr;
      rwptr2 <= rwptr1;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : REMPTY_ASSIGN_PROC
-- Description: Process assigns read empty when next rptr equals synchronized wptr
--------------------------------------------------------------------------
  REMPTY_ASSIGN_PROC :
  process(rclock_i, rresetn_i)
  begin
    if rresetn_i = '0' then
      rempty <= '1';
    elsif(rising_edge(rclock_i))then
      if(rgnext = rwptr2)then
        rempty <= '1';
      else
        rempty <= '0';
      end if;
    end if;
  end process;

-------WRITE SECTION----------------------
--------------------------------------------------------------------------
-- Name       : BIN_GRAY_CTR_PROC
-- Description: Process implements binary and gray counters
--------------------------------------------------------------------------
  BIN_GRAY_CTR_PROC :
  process(wclock_i, wresetn_i)
  begin
    if wresetn_i = '0' then
      wbin <= (others => '0');
      wptr <= (others => '0');
    elsif(rising_edge(wclock_i))then
      wbin <= wbnext;
      wptr <= wgnext;
    end if;
  end process;

--------------------------------------------------------------------------
-- Name       : SYNC_READ_PTR
-- Description: Syncronizes read pointer into write clock domain
--------------------------------------------------------------------------
  SYNC_READ_PTR :
  process(wclock_i, wresetn_i)
  begin
    if wresetn_i = '0' then
      wrptr1 <= (others => '0');
      wrptr2 <= (others => '0');
    elsif(rising_edge(wclock_i))then
      wrptr1 <= rptr;
      wrptr2 <= wrptr1;
    end if;
  end process;

  -- FIFO is full when following 3 condition are true
  --1. The wptr and the synchronized rptr MSB's are not equal
  --2. The wptr and the synchronized rptr 2nd MSB's are not equal
  --3. All other wptr and synchronized rptr bits must be equal
--------------------------------------------------------------------------
-- Name       : FIFO_FULL_ASSIGN
-- Description: Synchronizes read pointer into write clock domain
--------------------------------------------------------------------------
  FIFO_FULL_ASSIGN :
  process(wclock_i, wresetn_i)
  begin
    if wresetn_i = '0' then
      wfull <= '0';
    elsif(rising_edge(wclock_i))then
      if(wgnext = s_wrptr2_tmp)then
        wfull <= '1';
      else
        wfull <= '0';
      end if;
    end if;
  end process;

--=================================================================================================
-- Memory
--=================================================================================================
  ram_wr_addr <= unsigned(waddr);
   
  process(wclock_i)
  begin
    if(rising_edge(wclock_i)) then
      if(wen = '1') then
        ram(to_integer(ram_wr_addr)) <= wdata_i;
      end if;
    end if;
  end process;

  process(rclock_i)
  begin
    if(rising_edge(rclock_i)) then
      ram_rd_addr <= unsigned(raddr);
    end if;
  end process;

  rdata_o <= ram(to_integer(ram_rd_addr));

end rtl;
