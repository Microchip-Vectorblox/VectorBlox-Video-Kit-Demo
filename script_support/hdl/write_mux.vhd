--=================================================================================================
-- File Name                           : write_mux.vhd


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
-- write_mux entity declaration
--=================================================================================================
ENTITY write_mux IS
GENERIC(     
		--Data width of incoming data
		g_DATA_WIDTH					: INTEGER	:= 256;

        --Address width
		g_ADDR_WIDTH					: INTEGER	:= 32;

        --Burst Size width
        g_BURST_WIDTH                   : INTEGER   := 16
   );
PORT (
--Port list
    -- system reset
    reset_i                            	: IN STD_LOGIC;

    -- System Clock
    sys_clk_i                           : IN STD_LOGIC;

	--Mux selection output for channel selection
	mux_sel_i							: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
	
	--W0 data valid
	w0_data_valid_i						: IN STD_LOGIC;
	--W0 burst size
    w0_burst_size_i	                    : IN STD_LOGIC_VECTOR(g_BURST_WIDTH-1 DOWNTO 0);
	--W0 write start address
    w0_wstart_addr_i	                : IN STD_LOGIC_VECTOR(g_ADDR_WIDTH-1 DOWNTO 0);
	--W0 data input
	w0_data_i							: IN STD_LOGIC_VECTOR(g_DATA_WIDTH-1 DOWNTO 0);

	--W1 data valid
	w1_data_valid_i						: IN STD_LOGIC;
	--W1 burst size
    w1_burst_size_i	                    : IN STD_LOGIC_VECTOR(g_BURST_WIDTH-1 DOWNTO 0);
	--W1 write start address
    w1_wstart_addr_i	                : IN STD_LOGIC_VECTOR(g_ADDR_WIDTH-1 DOWNTO 0);
	--W1 data input
	w1_data_i							: IN STD_LOGIC_VECTOR(g_DATA_WIDTH-1 DOWNTO 0);

	--W2 data valid
	w2_data_valid_i						: IN STD_LOGIC;
	--W2 burst size
    w2_burst_size_i	                    : IN STD_LOGIC_VECTOR(g_BURST_WIDTH-1 DOWNTO 0);
	--W2 write start address
    w2_wstart_addr_i	                : IN STD_LOGIC_VECTOR(g_ADDR_WIDTH-1 DOWNTO 0);
	--W2 data input
	w2_data_i							: IN STD_LOGIC_VECTOR(g_DATA_WIDTH-1 DOWNTO 0);

	--W3 data valid
	w3_data_valid_i						: IN STD_LOGIC;
	--W3 burst size
    w3_burst_size_i	                    : IN STD_LOGIC_VECTOR(g_BURST_WIDTH-1 DOWNTO 0);
	--W3 write start address
    w3_wstart_addr_i	                : IN STD_LOGIC_VECTOR(g_ADDR_WIDTH-1 DOWNTO 0);
	--W3 data input
	w3_data_i							: IN STD_LOGIC_VECTOR(g_DATA_WIDTH-1 DOWNTO 0);

	--Data valid output
	data_valid_o						: OUT STD_LOGIC;
	--Burst size
    burst_size_o	                    : OUT STD_LOGIC_VECTOR(g_BURST_WIDTH-1 DOWNTO 0);
	--Write start address
    wstart_addr_o	                	: OUT STD_LOGIC_VECTOR(g_ADDR_WIDTH-1 DOWNTO 0);
	--Data input
	data_o								: OUT STD_LOGIC_VECTOR(g_DATA_WIDTH-1 DOWNTO 0)

		

);
END write_mux;


--=================================================================================================
-- write_mux architecture body
--=================================================================================================
ARCHITECTURE write_mux OF write_mux IS

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
--NA

--=================================================================================================
-- Synchronous blocks
--=================================================================================================
--------------------------------------------------------------------------
-- Name       : REGISTERED_MUX
-- Description: Process to generates a MUX with registered output
--------------------------------------------------------------------------
REGISTERED_MUX:
	PROCESS(SYS_CLK_I,RESET_I)
	BEGIN
		IF (RESET_I = '0') THEN
			data_valid_o	    <= '0';
		    burst_size_o	    <= (OTHERS => '0');
		    wstart_addr_o	    <= (OTHERS => '0');
		    data_o	            <= (OTHERS => '0');
		ELSIF rising_edge(SYS_CLK_I) THEN
			IF(mux_sel_i = "00")THEN
                data_valid_o	    <= w0_data_valid_i;
                burst_size_o	    <= w0_burst_size_i;
                wstart_addr_o	    <= w0_wstart_addr_i;
                data_o	            <= w0_data_i;
            ELSIF(mux_sel_i = "01")THEN
                data_valid_o	    <= w1_data_valid_i;
                burst_size_o	    <= w1_burst_size_i;
                wstart_addr_o	    <= w1_wstart_addr_i;
                data_o	            <= w1_data_i;
            ELSIF(mux_sel_i = "10")THEN
                data_valid_o	    <= w2_data_valid_i;
                burst_size_o	    <= w2_burst_size_i;
                wstart_addr_o	    <= w2_wstart_addr_i;
                data_o	            <= w2_data_i;
            ELSE
                data_valid_o	    <= w3_data_valid_i;
                burst_size_o	    <= w3_burst_size_i;
                wstart_addr_o	    <= w3_wstart_addr_i;
                data_o	            <= w3_data_i;
            END IF;
		END IF;
	END PROCESS;
--=================================================================================================
-- Component Instantiations
--=================================================================================================
--NA
END write_mux;