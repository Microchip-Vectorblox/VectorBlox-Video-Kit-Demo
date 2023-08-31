--=================================================================================================
-- File Name                           : read_demux.vhd


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
-- read_demux entity declaration
--=================================================================================================
ENTITY read_demux IS

PORT (
--Port list
    -- system reset
    reset_i                            	: IN STD_LOGIC;

	--Mux selection output for channel selection
	mux_sel_i							: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	--Acknowledge input from Read Master
	ack_i								: IN STD_LOGIC;
	
	--Done input from Read Master
	done_i								: IN STD_LOGIC;
	
	--Data valid signal from Read Master
	data_valid_i						: IN STD_LOGIC;
	
	--R0 acknowledge to DDR Read controller
	r0_ack_o							: OUT STD_LOGIC;
	--R0 done to DDR Read controller
	r0_done_o							: OUT STD_LOGIC;
	--R0 data valid to DDR Read controller
	r0_data_valid_o						: OUT STD_LOGIC;
	
	--R1 acknowledge to DDR Read controller
	r1_ack_o							: OUT STD_LOGIC;
	--R1 done to DDR Read controller
	r1_done_o							: OUT STD_LOGIC;
	--R1 data valid to DDR Read controller
	r1_data_valid_o						: OUT STD_LOGIC;
	
	--R2 acknowledge to DDR Read controller	
	r2_ack_o							: OUT STD_LOGIC;
	--R2 done to DDR Read controller
	r2_done_o							: OUT STD_LOGIC;
	--R2 data valid to DDR Read controller
	r2_data_valid_o						: OUT STD_LOGIC;
	
	--R3 acknowledge to DDR Read controller	
	r3_ack_o							: OUT STD_LOGIC;
	--R3 done to DDR Read controller
	r3_done_o							: OUT STD_LOGIC;
	--R3 data valid to DDR Read controller
	r3_data_valid_o						: OUT STD_LOGIC
		

);
END read_demux;


--=================================================================================================
-- read_demux architecture body
--=================================================================================================
ARCHITECTURE read_demux OF read_demux IS

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
    PROCESS(reset_i, ack_i, done_i, mux_sel_i,data_valid_i)
    BEGIN
		IF(reset_i = '0') THEN
			r0_ack_o			<= '0';
			r0_done_o			<= '0';
			r0_data_valid_o		<= '0';
			r1_ack_o			<= '0';
			r1_done_o			<= '0';
			r1_data_valid_o		<= '0';
			r2_ack_o			<= '0';
			r2_done_o			<= '0';
			r2_data_valid_o		<= '0';
			r3_ack_o			<= '0';
			r3_done_o			<= '0';	
			r3_data_valid_o		<= '0';		
		ELSE
			CASE mux_sel_i IS
			WHEN "00" =>
				r0_ack_o			<= ack_i;
				r0_done_o			<= done_i;
				r0_data_valid_o		<= data_valid_i;
				r1_ack_o			<= '0';
				r1_done_o			<= '0';
				r1_data_valid_o		<= '0';
				r2_ack_o			<= '0';
				r2_done_o			<= '0';
				r2_data_valid_o		<= '0';
				r3_ack_o			<= '0';
				r3_done_o			<= '0';	
				r3_data_valid_o		<= '0';
			WHEN "01" =>		
				r0_ack_o			<= '0';
				r0_done_o			<= '0';
				r0_data_valid_o		<= '0';
				r1_ack_o			<= ack_i;
				r1_done_o			<= done_i;
				r1_data_valid_o		<= data_valid_i;
				r2_ack_o			<= '0';
				r2_done_o			<= '0';
				r2_data_valid_o		<= '0';
				r3_ack_o			<= '0';
				r3_done_o			<= '0';	
				r3_data_valid_o		<= '0';	
			WHEN "10" =>		
				r0_ack_o			<= '0';
				r0_done_o			<= '0';
				r0_data_valid_o		<= '0';
				r1_ack_o			<= '0';
				r1_done_o			<= '0';
				r1_data_valid_o		<= '0';
				r2_ack_o			<= ack_i;
				r2_done_o			<= done_i;
				r2_data_valid_o		<= data_valid_i;
				r3_ack_o			<= '0';
				r3_done_o			<= '0';		
				r3_data_valid_o		<= '0';
			WHEN OTHERS =>		
				r0_ack_o			<= '0';
				r0_done_o			<= '0';
				r0_data_valid_o		<= '0';
				r1_ack_o			<= '0';
				r1_done_o			<= '0';
				r1_data_valid_o		<= '0';
				r2_ack_o			<= '0';
				r2_done_o			<= '0';
				r2_data_valid_o		<= '0';
				r3_ack_o			<= ack_i;
				r3_done_o			<= done_i;
				r3_data_valid_o		<= data_valid_i;
			END CASE;				
		END IF;
	END PROCESS;
--=================================================================================================
-- Component Instantiations
--=================================================================================================
--NA
END read_demux;