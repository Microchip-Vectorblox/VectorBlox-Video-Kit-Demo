--=================================================================================================
-- File Name                           : data_unpacker.vhd




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
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

--=================================================================================================
-- data_unpacker entity declaration
--=================================================================================================
ENTITY data_unpacker IS
PORT(
-- Port list
    -- System reset
    reset_i                            	: IN STD_LOGIC;
	
	-- Display clock
    disp_clk_i                          : IN STD_LOGIC;
    
    -- Read enable signal from DDR
    read_en_i                           : IN STD_LOGIC;
	
	-- data ready from FIFO
    fifo_data_valid_i                   : IN STD_LOGIC;
	
	-- Data Input
	data_i								: IN STD_LOGIC_VECTOR(255 DOWNTO 0);
	
	-- Data Input
	horz_resl_i							: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	-- data output valid
	data_valid_o              			: OUT STD_LOGIC;
	
	-- Read request for FIFO
	fifo_read_o              			: OUT STD_LOGIC;

    -- Number of 128 bit packets to read 
    beats_to_read_o                     : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
	
	-- Data output
	data_o								: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
   
);
END data_unpacker;

--=================================================================================================
-- pattern_generator architecture body
--=================================================================================================

ARCHITECTURE data_packer_arch OF data_unpacker IS

--=================================================================================================
-- Component declarations
--=================================================================================================
--NA--
--=================================================================================================
-- Synthesis Attributes
--=================================================================================================
--NA--
--=================================================================================================
-- Signal declarations
--=================================================================================================
		
SIGNAL s_packet_counter	            : STD_LOGIC_VECTOR(2 DOWNTO 0);		
SIGNAL s_read_counter	            : STD_LOGIC_VECTOR(2 DOWNTO 0);		
SIGNAL s_line_count_max	            : STD_LOGIC_VECTOR(15 DOWNTO 0);		
SIGNAL s_line_counter	            : STD_LOGIC_VECTOR(15 DOWNTO 0);		
SIGNAL s_data_pack	             	: STD_LOGIC_VECTOR(255 DOWNTO 0);	
SIGNAL s_data_unpacked             	: STD_LOGIC_VECTOR(31 DOWNTO 0);		
SIGNAL s_read_latch 		        : STD_LOGIC;	
SIGNAL s_read_fifo	 		        : STD_LOGIC;
SIGNAL s_ddr_read_en_dly	        : STD_LOGIC;
SIGNAL s_ddr_read_en_dly2	 	    : STD_LOGIC;
SIGNAL s_ddr_read_en_fe	            : STD_LOGIC;	

BEGIN

--=================================================================================================
-- Top level output port assignments
--=================================================================================================

data_o			<= s_data_unpacked;
fifo_read_o		<= s_read_fifo;
beats_to_read_o <= "000" & horz_resl_i(15 DOWNTO 3) - '1';
--=================================================================================================
-- Generate blocks
--=================================================================================================


--=================================================================================================
-- Asynchronous blocks
--=================================================================================================

s_line_count_max	<= "000" & horz_resl_i(15 DOWNTO 3);	
s_ddr_read_en_fe       <= s_ddr_read_en_dly2 AND (NOT(s_ddr_read_en_dly));		
--=================================================================================================
-- Synchronous blocks
--================================================================================================= 

--------------------------------------------------------------------------
-- Name       : DELAY_PROC_DISP_CLK
-- Description: Generate the delayed signals
--------------------------------------------------------------------------
DELAY_PROC_DISP_CLK:
	PROCESS(disp_clk_i,reset_i)
	BEGIN
		IF (reset_i = '0') THEN
			s_ddr_read_en_dly		    <= '0';
			s_ddr_read_en_dly2		    <= '0';
		ELSIF rising_edge(disp_clk_i) THEN
			s_ddr_read_en_dly           <= read_en_i;
			s_ddr_read_en_dly2          <= s_ddr_read_en_dly;
		END IF;
	END PROCESS;
--------------------------------------------------------------------------
-- Name       : READING_PROC
-- Description: Generate read fifo signals
--------------------------------------------------------------------------
READING_PROC:
	PROCESS(disp_clk_i,RESET_I)
	BEGIN
		IF (RESET_I = '0') THEN
			s_read_latch		<= '0';
			s_read_fifo			<= '0';
			s_read_counter		<= (OTHERS => '0');
		ELSIF rising_edge(disp_clk_i) THEN
			IF(s_ddr_read_en_fe = '1') THEN
				s_read_latch	<= '1';
			ELSIF(s_line_counter = s_line_count_max) THEN
				s_read_latch	<= '0';
			END IF;
			IF(s_read_latch = '1') THEN
				s_read_counter 	<= s_read_counter + '1';
				IF(s_read_counter = "000") THEN
					s_read_fifo	<= '1';
				ELSE
					s_read_fifo	<= '0';
				END IF; 
			ELSE
				s_read_counter	<= (OTHERS=>'0');
				s_read_fifo		<= '0';
			END IF;
		END IF;
	END PROCESS;
	
--------------------------------------------------------------------------
-- Name       : DATA_ASSIGN
-- Description: Process assigns data based on counter value
--------------------------------------------------------------------------
DATA_ASSIGN:
	PROCESS(disp_clk_i,RESET_I)
	BEGIN
		IF RESET_I = '0' THEN
			s_data_pack			<= (OTHERS => '0');
			s_line_counter		<= (OTHERS => '0');
			s_data_unpacked		<= (OTHERS => '0');			
			s_packet_counter	<= (OTHERS=>'0');			
			data_valid_o		<= '0';
		ELSIF rising_edge(disp_clk_i) THEN	
			IF(fifo_data_valid_i = '1')THEN
				s_data_pack 	<= x"00000000" & data_i(255 DOWNTO 32);
				s_data_unpacked	<= data_i(31 DOWNTO 0);
				s_line_counter	<= s_line_counter + '1';				
				s_packet_counter<= s_packet_counter + '1';
				data_valid_o	<= '1';
			ELSE
				IF(s_packet_counter /= "000") THEN					
					s_packet_counter	<= s_packet_counter + '1';
				END IF;
				s_data_pack 	<= x"00000000" & s_data_pack(255 DOWNTO 32);
				s_data_unpacked	<= s_data_pack(31 DOWNTO 0);
				IF(s_read_latch = '0') THEN
					s_line_counter <= (OTHERS=>'0');
					IF(s_packet_counter = "000") THEN
						data_valid_o	<= '0';
					END IF;
				END IF;
			END IF;
		END IF;			
	END PROCESS; 

--=================================================================================================
-- Component Instantiations
--=================================================================================================
--NA--
END data_packer_arch;
