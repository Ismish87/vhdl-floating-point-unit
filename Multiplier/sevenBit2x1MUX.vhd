--------------------------------------------------------------------------------
-- Title         : 7-Bit 2-to-1 Multiplexer
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : sevenBit2x1MUX.vhd

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sevenBit2x1MUX IS
	PORT (
		i_sel		: IN	STD_LOGIC;
		i_A		: IN	STD_LOGIC_VECTOR(6 downto 0);
		i_B		: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_q		: OUT	STD_LOGIC_VECTOR(6 downto 0));
END sevenBit2x1MUX;

ARCHITECTURE struct OF sevenBit2x1MUX IS
	
BEGIN

WITH i_sel SELECT
	o_q <= i_A when '0',
	       i_B when '1',
	       "0000000" when others;
END struct; 
