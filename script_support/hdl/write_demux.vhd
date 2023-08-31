--=================================================================================================
-- File Name                           : write_demux.vhd


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
--=================================================================================================
-- write_demux entity declaration
--=================================================================================================
ENTITY write_demux IS
PORT (
--Port list
    -- system reset
    reset_i                            	: IN STD_LOGIC;

	--Mux selection output for channel selection
	mux_sel_i							: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	--Acknowledge input from Write Master
	ack_i								: IN STD_LOGIC;
	
	--Done input from Write Master
	done_i								: IN STD_LOGIC;
	
	--W0 acknowledge to DDR Write controller
	w0_ack_o							: OUT STD_LOGIC;
	--W0 done to DDR Write controller
	w0_done_o							: OUT STD_LOGIC;
	--W1 acknowledge to DDR Write controller
	w1_ack_o							: OUT STD_LOGIC;
	--W1 done to DDR Write controller
	w1_done_o							: OUT STD_LOGIC;
	--W2 acknowledge to DDR Write controller	
	w2_ack_o							: OUT STD_LOGIC;
	--W2 done to DDR Write controller
	w2_done_o							: OUT STD_LOGIC;
	--W3 acknowledge to DDR Write controller	
	w3_ack_o							: OUT STD_LOGIC;
	--W3 done to DDR Write controller
	w3_done_o							: OUT STD_LOGIC
		

);
END write_demux;


--=================================================================================================
-- write_demux architecture body
--=================================================================================================
ARCHITECTURE write_demux OF write_demux IS

--=================================================================================================
-- Component declarations
--=================================================================================================

--=================================================================================================
-- Synthesis Attributes
--=================================================================================================
--NA--
--=================================================================================================
-- Signal declarations
--=================================================================================================


BEGIN
--=================================================================================================
-- Top level output port assignments
--=================================================================================================

					
--=================================================================================================
-- Generate blocks
--=================================================================================================
--NA--
--=================================================================================================
-- Asynchronous blocks
--=================================================================================================
--------------------------------------------------------------------------
-- Name       : DEMUX_PROC
-- Description: Process to generate Iout based on enable signal
--------------------------------------------------------------------------
DEMUX_PROC:
    PROCESS(reset_i, ack_i, done_i, mux_sel_i)
    BEGIN
		IF(reset_i = '0') THEN
			w0_ack_o	<= '0';
			w0_done_o	<= '0';
			w1_ack_o	<= '0';
			w1_done_o	<= '0';
			w2_ack_o	<= '0';
			w2_done_o	<= '0';
			w3_ack_o	<= '0';
			w3_done_o	<= '0';			
		ELSE
			CASE mux_sel_i IS
			WHEN "00" =>
				w0_ack_o	<= ack_i;
				w0_done_o	<= done_i;
				w1_ack_o	<= '0';
				w1_done_o	<= '0';
				w2_ack_o	<= '0';
				w2_done_o	<= '0';
				w3_ack_o	<= '0';
				w3_done_o	<= '0';	
			WHEN "01" =>
				w0_ack_o	<= '0';
				w0_done_o	<= '0';
				w1_ack_o	<= ack_i;
				w1_done_o	<= done_i;
				w2_ack_o	<= '0';
				w2_done_o	<= '0';
				w3_ack_o	<= '0';
				w3_done_o	<= '0';		
			WHEN "10" =>
				w0_ack_o	<= '0';
				w0_done_o	<= '0';
				w1_ack_o	<= '0';
				w1_done_o	<= '0';
				w2_ack_o	<= ack_i;
				w2_done_o	<= done_i;
				w3_ack_o	<= '0';
				w3_done_o	<= '0';		
			WHEN OTHERS =>
				w0_ack_o	<= '0';
				w0_done_o	<= '0';
				w1_ack_o	<= '0';
				w1_done_o	<= '0';
				w2_ack_o	<= '0';
				w2_done_o	<= '0';
				w3_ack_o	<= ack_i;
				w3_done_o	<= done_i;
			END CASE;				
		END IF;
	END PROCESS;
--=================================================================================================
-- Component Instantiations
--=================================================================================================
--NA
END write_demux;