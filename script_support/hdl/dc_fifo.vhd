--=================================================================================================
-- File Name                           : video_fifo.vhd


-- Targeted device                     : Microsemi-SoC
-- Author                              : India Solutions Team
--
-- COPYRIGHT 2019 BY MICROSEMI
-- THE INFORMATION CONTAINED IN THIS DOCUMENT IS SUBJECT TO LICENSING RESTRICTIONS FROM MICROSEMI
-- CORP. IF YOU ARE NOT IN POSSESSION OF WRITTEN AUTHORIZATION FROM MICROSEMI FOR USE OF THIS
-- FILE, THEN THE FILE SHOULD BE IMMEDIATELY DESTROYED AND NO BACK-UP OF THE FILE SHOULD BE MADE.
--
--=================================================================================================

--=================================================================================================
-- Libraries
--=================================================================================================
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
--USE IEEE.STD_LOGIC_ARITH.ALL;

--=================================================================================================
-- video_fifo entity declaration
--=================================================================================================
ENTITY video_fifo IS
GENERIC(
-- Generic list
    -- Video format selection
    g_VIDEO_FIFO_AWIDTH                	: INTEGER := 12;
    g_INPUT_VIDEO_DATA_BIT_WIDTH       	: INTEGER := 24;
    g_HALF_EMPTY_THRESHOLD            	: INTEGER := 1280
);
PORT(
-- Port list
    -- System reset
    wclock_i                            : IN STD_LOGIC;
    wresetn_i                           : IN STD_LOGIC;
    wen_i                           	: IN STD_LOGIC;
    wdata_i                           	: IN STD_LOGIC_VECTOR(g_INPUT_VIDEO_DATA_BIT_WIDTH-1 DOWNTO 0);
    wfull_o                           	: OUT STD_LOGIC;
	wafull_o							: OUT STD_LOGIC;
	wdata_count_o						: OUT STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH-1 DOWNTO 0);
	rclock_i							: IN STD_LOGIC;
	rresetn_i							: IN STD_LOGIC;
	ren_i								: IN STD_LOGIC;
	rdata_o								: OUT STD_LOGIC_VECTOR(g_INPUT_VIDEO_DATA_BIT_WIDTH-1 DOWNTO 0);
	rdata_rdy_o							: OUT STD_LOGIC;
	rempty_o							: OUT STD_LOGIC;
	raempty_o							: OUT STD_LOGIC;
	rhempty_o							: OUT STD_LOGIC;
	rdata_count_o						: OUT STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH-1 DOWNTO 0)
);
END video_fifo;

--=================================================================================================
-- video_fifo architecture body
--=================================================================================================

ARCHITECTURE video_fifo OF video_fifo IS

--=================================================================================================
-- Component declarations
--=================================================================================================
COMPONENT ram2port
    GENERIC(
            g_BUFF_AWIDTH   : INTEGER := 9;
            g_DWIDTH    	: INTEGER	:= 32
);
        PORT (
			wr_data_i	   	: IN STD_LOGIC_VECTOR(g_DWIDTH-1 DOWNTO 0);
			rd_addr_i      	: IN STD_LOGIC_VECTOR(g_BUFF_AWIDTH-1 DOWNTO 0);
			wr_addr_i      	: IN STD_LOGIC_VECTOR(g_BUFF_AWIDTH-1 DOWNTO 0);
			we_i       		: IN STD_LOGIC;
			wclock_i       	: IN STD_LOGIC;
			rclock_i       	: IN STD_LOGIC;
			rd_data_o       : OUT STD_LOGIC_VECTOR(g_DWIDTH-1 DOWNTO 0)
        );
END COMPONENT;
--=================================================================================================
-- Synthesis Attributes
--=================================================================================================
--NA--
--=================================================================================================
-- Signal declarations
--=================================================================================================
CONSTANT AFULL_THRESHOLD	: INTEGER := 5900;
CONSTANT AEMPTY_THRESHOLD	: INTEGER := 10;

TYPE matrix IS ARRAY (g_VIDEO_FIFO_AWIDTH-1 TO 0) OF STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);

SIGNAL rbin			: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL rptr			: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL rwptr1		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL rwptr2		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);

SIGNAL rempty		: STD_LOGIC;
SIGNAL s_ren		: STD_LOGIC;
SIGNAL raempty		: STD_LOGIC;
SIGNAL wfull		: STD_LOGIC;
SIGNAL wafull		: STD_LOGIC;
SIGNAL fifo_hempty	: STD_LOGIC;
SIGNAL wen			: STD_LOGIC;
SIGNAL rwbin		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL rdata_count 	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL wbin		 	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL wptr		 	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL s_wrptr2_tmp 	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);

SIGNAL wrptr1	 	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL wrptr2	 	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL wrbin	 	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL wdata_count 	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL raddr 		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH-1 DOWNTO 0);
SIGNAL waddr 		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH-1 DOWNTO 0);
SIGNAL rbnext 		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL rgnext 		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL wbnext 		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL wgnext 		: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL wdiff_bus	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL rdiff_bus	: STD_LOGIC_VECTOR(g_VIDEO_FIFO_AWIDTH DOWNTO 0);
SIGNAL i			: INTEGER;
SIGNAL j 			: INTEGER;
BEGIN

--=================================================================================================
-- Top level output port assignments
--=================================================================================================
rdata_rdy_o		<= s_ren;
rdata_count_o	<= rdata_count(g_VIDEO_FIFO_AWIDTH-1 DOWNTO 0);
wfull_o			<= wfull;
wafull_o <= wafull;
rhempty_o <= fifo_hempty;
wdata_count_o <= wdata_count((g_VIDEO_FIFO_AWIDTH - 1) DOWNTO 0);
  --/* Memory read address pointer */
raddr <= rbin(g_VIDEO_FIFO_AWIDTH - 1 DOWNTO 0);
--  /* Increment binary counter */
rbnext <= rbin + (ren_i AND NOT(rempty));
--  /* Binary to Gray conversion */
rgnext <= TO_STDLOGICVECTOR(TO_BITVECTOR(rbnext) SRL 1) XOR rbnext;
--  /* Write to memory only when FIFO is not full */
wen	<= '1' WHEN (wen_i = '1') AND (wfull = '0') ELSE
		'0';
--  /* Read from memory only when FIFO is not empty */
--//  assign ren = ((ren_i == 1'b1) && (rempty == 1'b0)) ? 1'b1 : 1'b0;
--  /* Memory write address pointer */
waddr <= wbin(g_VIDEO_FIFO_AWIDTH - 1 DOWNTO 0);
--  /* Increment binary counter */
wbnext <= wbin + (wen_i AND NOT(wfull));
--  /* Binary to Gray conversion */
--s_shift_right_val  <= TO_STDLOGICVECTOR(TO_BITVECTOR(s_filter_incr) SRA
--                   conv_integer(UNSIGNED(filter_factor_i)));
wgnext <= TO_STDLOGICVECTOR(TO_BITVECTOR(wbnext) SRL 1) XOR wbnext;

rempty_o	<= rempty;
--=================================================================================================
-- Generate blocks
--=================================================================================================
--NA

--=================================================================================================
-- Asynchronous blocks
--=================================================================================================
rdiff_bus 		<= (rwbin - rbin);
raempty_o 		<= raempty;
wdiff_bus		<= wbin - wrbin;
s_wrptr2_tmp	<= NOT(wrptr2(g_VIDEO_FIFO_AWIDTH DOWNTO g_VIDEO_FIFO_AWIDTH - 1)) 
						& wrptr2(g_VIDEO_FIFO_AWIDTH - 2 DOWNTO 0);
--------------------------------------------------------------------------
-- Name       : GRAY2BIN_PROC
-- Description: Process converts gray code to binary
--------------------------------------------------------------------------
GRAY2BIN_PROC:
	PROCESS(rwptr2,rwbin)
	BEGIN	
		rwbin(g_VIDEO_FIFO_AWIDTH)	<= rwptr2(g_VIDEO_FIFO_AWIDTH);
		FOR i in 0 to g_VIDEO_FIFO_AWIDTH-1 LOOP
				rwbin(i)	<= rwptr2(i) XOR rwbin(i+1);
		END LOOP;
	END PROCESS;
	
--------------------------------------------------------------------------
-- Name       : GRAY2BIN_CONV
-- Description: Process implements gray to binary conversion
--------------------------------------------------------------------------
GRAY2BIN_CONV:
	PROCESS(wrptr2,wrbin)
	BEGIN
		wrbin(g_VIDEO_FIFO_AWIDTH) <= wrptr2(g_VIDEO_FIFO_AWIDTH);
		FOR j IN 0 TO g_VIDEO_FIFO_AWIDTH-1 LOOP
			wrbin(j)	<= wrptr2(j) XOR wrbin(j+1);
		END LOOP;
	END PROCESS;
	



--=================================================================================================
-- Synchronous blocks
--=================================================================================================
--------------------------------------------------------------------------
-- Name       : READ_PTR_ASSIGN_PROC
-- Description: Process reads data
--------------------------------------------------------------------------
DELAY:
	PROCESS(rclock_i,rresetn_i)
	BEGIN
		IF rresetn_i = '0' THEN
			s_ren	<= '0';
		ELSIF(rising_edge(rclock_i))THEN
			s_ren	<= ren_i;
		END IF;
	END PROCESS;

--------------------------------------------------------------------------
-- Name       : READ_PTR_ASSIGN_PROC
-- Description: Process reads data
--------------------------------------------------------------------------
READ_PTR_ASSIGN_PROC:
	PROCESS(rclock_i,rresetn_i)
	BEGIN
		IF rresetn_i = '0' THEN
			rbin 	<= (OTHERS => '0');
			rptr	<= (OTHERS => '0');
		ELSIF(rising_edge(rclock_i))THEN
			rbin	<= rbnext;
			rptr	<= rgnext;
		END IF;
	END PROCESS;

--------------------------------------------------------------------------
-- Name       : SYNC_WRPTR_RDCLK_PROC
-- Description: Process synchronizes write pointer to read clock domain
--------------------------------------------------------------------------
SYNC_WRPTR_RDCLK_PROC:
	PROCESS(rclock_i,rresetn_i)
	BEGIN
		IF rresetn_i = '0' THEN
			rwptr1 	<= (OTHERS => '0');
			rwptr2	<= (OTHERS => '0');
		ELSIF(rising_edge(rclock_i))THEN
			rwptr1	<= wptr;
			rwptr2	<= rwptr1;
		END IF;
	END PROCESS;

--------------------------------------------------------------------------
-- Name       : REMPTY_ASSIGN_PROC
-- Description: Process assigns read empty when next rptr equals synchronized wptr
--------------------------------------------------------------------------
REMPTY_ASSIGN_PROC:
	PROCESS(rclock_i,rresetn_i)
	BEGIN
		IF rresetn_i = '0' THEN
			rempty 	<=	'1';
		ELSIF(rising_edge(rclock_i))THEN
			IF(rgnext = rwptr2)THEN
				rempty	<= '1';
			ELSE
				rempty	<= '0';
			END IF;
		END IF;
	END PROCESS;
--------------------------------------------------------------------------
-- Name       : DATACNT_PROC
-- Description: Process counts data in FIFO (diff between write and read ptr)
--------------------------------------------------------------------------
DATACNT_PROC:
	PROCESS(rclock_i,rresetn_i)
	BEGIN
		IF rresetn_i = '0' THEN
			rdata_count 	<= (OTHERS => '0');
		ELSIF(rising_edge(rclock_i))THEN
			rdata_count		<= (rwbin - rbin);
		END IF;
	END PROCESS;
	
--------------------------------------------------------------------------
-- Name       : READ_EMPTY_ASSIGN
-- Description: Process detects read buffer empty
--------------------------------------------------------------------------
READ_EMPTY_ASSIGN:
	PROCESS(rclock_i,rresetn_i)
	BEGIN
		IF rresetn_i = '0' THEN
			raempty 	<= '1';
		ELSIF(rising_edge(rclock_i))THEN
			IF(AEMPTY_THRESHOLD >= rdiff_bus)THEN
				raempty		<= '1';
			ELSE
				raempty		<= '0';
			END IF;
		END IF;
	END PROCESS;

--------------------------------------------------------------------------
-- Name       : HALFEMPTY_PROC
-- Description: Process assigns fifo half empty signal
--------------------------------------------------------------------------
HALFEMPTY_PROC:
	PROCESS(rclock_i,rresetn_i)
	BEGIN
		IF rresetn_i = '0' THEN
			fifo_hempty 	<= '1';
		ELSIF(rising_edge(rclock_i))THEN
			IF(g_HALF_EMPTY_THRESHOLD >= rdiff_bus)THEN
				fifo_hempty		<= '1';
			ELSE
				fifo_hempty		<= '0';
			END IF;
		END IF;
	END PROCESS;

-------WRITE SECTION----------------------
--------------------------------------------------------------------------
-- Name       : BIN_GRAY_CTR_PROC
-- Description: Process implements binary and gray counters
--------------------------------------------------------------------------
BIN_GRAY_CTR_PROC:
	PROCESS(wclock_i,wresetn_i)
	BEGIN
		IF wresetn_i = '0' THEN
			wbin 	<= (OTHERS => '0');
			wptr	<= (OTHERS => '0');
		ELSIF(rising_edge(wclock_i))THEN
			wbin	<= wbnext;
			wptr	<= wgnext;
		END IF;
	END PROCESS;

--------------------------------------------------------------------------
-- Name       : SYNC_READ_PTR
-- Description: Syncronizes read pointer into write clock domain
--------------------------------------------------------------------------
SYNC_READ_PTR:
	PROCESS(wclock_i,wresetn_i)
	BEGIN
		IF wresetn_i = '0' THEN
			wrptr1 	<= (OTHERS => '0');
			wrptr2	<= (OTHERS => '0');
		ELSIF(rising_edge(wclock_i))THEN
			wrptr1	<= rptr;
			wrptr2	<= wrptr1;
		END IF;
	END PROCESS;
  -- FIFO is full when following 3 condition are true
  --1. The wptr and the synchronized rptr MSB's are not equal
  --2. The wptr and the synchronized rptr 2nd MSB's are not equal
  --3. All other wptr and synchronized rptr bits must be equal
--------------------------------------------------------------------------
-- Name       : FIFO_FULL_ASSIGN
-- Description: Synchronizes read pointer into write clock domain
--------------------------------------------------------------------------
FIFO_FULL_ASSIGN:
	PROCESS(wclock_i,wresetn_i)
	BEGIN
		IF wresetn_i = '0' THEN
			wfull	<= '0';
		ELSIF(rising_edge(wclock_i))THEN
			IF(wgnext = s_wrptr2_tmp)THEN
				wfull	<= '1';
			ELSE
				wfull	<= '0';
			END IF;
		END IF;
	END PROCESS;

--------------------------------------------------------------------------
-- Name       : FIFO_COUNT
-- Description: Data available in FIFO is difference between write and read pointer
--------------------------------------------------------------------------
FIFO_COUNT:
	PROCESS(wclock_i,wresetn_i)
	BEGIN
		IF wresetn_i = '0' THEN
			wdata_count	<= (OTHERS => '0');
		ELSIF(rising_edge(wclock_i))THEN
			wdata_count	<= wbin - wrbin;
		END IF;
	END PROCESS;



--------------------------------------------------------------------------
-- Name       : WA_FULL_ASSIGN
-- Description: Assigns wafull signal
--------------------------------------------------------------------------
WA_FULL_ASSIGN:
	PROCESS(wclock_i,wresetn_i)
	BEGIN
		IF wresetn_i = '0' THEN
			wafull	<= '0';
		ELSIF(rising_edge(wclock_i))THEN
			IF(wdiff_bus >= AFULL_THRESHOLD)THEN
				wafull	<= '1';
			ELSE
				wafull	<= '0';
			END IF;
		END IF;
	END PROCESS;


--=================================================================================================
-- Component Instantiations
--=================================================================================================
ram2port_inst : ram2port
    GENERIC MAP(
            g_BUFF_AWIDTH   => g_VIDEO_FIFO_AWIDTH,
            g_DWIDTH    	=> g_INPUT_VIDEO_DATA_BIT_WIDTH
)
        PORT MAP(
			wr_data_i	   	=> wdata_i,
			rd_addr_i        	=> raddr,
			wr_addr_i        	=> waddr,
			we_i         		=> wen,
			wclock_i        	=> wclock_i,
			rclock_i        	=> rclock_i,
			rd_data_o       	=> rdata_o
        );
 END video_fifo;