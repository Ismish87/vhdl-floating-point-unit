--------------------------------------------------------------------------------
-- Title         : 3-bit Register
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : threeBitRegister.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2003/05/17
-- Last modified : 2007/09/25
-------------------------------------------------------------------------------
-- Description : This file creates a 3-bit register as defined in the VHDL
--		 Synthesis lecture.  The architecture is done at the RTL
--		 abstraction level and the implementation is done in structural
--		 VHDL.
-------------------------------------------------------------------------------
-- Modification history :
-- 2003.05.17 	R. Abielmona		Creation
-- 2004.09.22 	R. Abielmona		Ported for CEG 3550
-- 2007.09.25 	R. Abielmona		Modified copyright notice
-------------------------------------------------------------------------------
-- This file is copyright material of Rami Abielmona, Ph.D., P.Eng., Chief Research
-- Scientist at Larus Technologies.  Permission to make digital or hard copies of part
-- or all of this work for personal or classroom use is granted without fee
-- provided that copies are not made or distributed for profit or commercial
-- advantage and that copies bear this notice and the full citation of this work.
-- Prior permission is required to copy, republish, redistribute or post this work.
-- This notice is adapted from the ACM copyright notice.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY NormalizeRegister IS
	PORT(
		i_resetBar, i_load, i_clock	: IN	STD_LOGIC;
		R_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_carut : OUT STD_LOGIC;
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
END NormalizeRegister;

ARCHITECTURE rtl OF NormalizeRegister IS
	SIGNAL shifttoAdd: STD_LOGIC_VECTOR(7 downto 0);
	signal norm , loadfirst,Zflag :std_LOGIC;
	
	
	COMPONENT addSub8bit 
	  port (
		 sub : IN STD_LOGIC;   
		 i_X, i_Y : IN STD_LOGIC_VECTOR(7 downto 0); 
		 o_Som : OUT STD_LOGIC_VECTOR(7 downto 0); 
		 o_CarOut: OUT STD_LOGIC  
	  ) ;
	end COMPONENT ;
	
	
	COMPONENT  eightBitRightShiftRegister 
	PORT(
		i_resetBar, i_load, i_shift	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		o_iszero : OUT STD_LOGIC ;
		i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
    END COMPONENT;
	
	COMPONENT MUX2x1de7bit 
  port (
    i_sel : IN STD_LOGIC;
    i_D0, i_D1 : IN STD_LOGIC_VECTOR(6 downto 0);
	
	
    o_q :  out STD_LOGIC_VECTOR(6 downto 0)
  ) ;
end COMPONENT ;
	
	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

loadfirst<=i_load and Zflag ;
norm <=i_load and not(zflag);
addN : addSub8bit PORT MAP ('0',R_Value,shifttoAdd,o_Value ,o_carut ) ;
	  
shiftN: eightBitRightShiftRegister port map ( i_resetBar, loadfirst, norm ,i_clock	,Zflag,"10000000",shifttoAdd	);







	-- Output Driver

END ARCHITECTURE;
