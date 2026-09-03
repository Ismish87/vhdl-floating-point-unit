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

ENTITY SevenBitDecRegister IS
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_dec			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0);
		o_Null			: OUT	STD_LOGIC);
		
END SevenBitDecRegister;

ARCHITECTURE rtl OF SevenBitDecRegister IS
	SIGNAL int_Value, int_notValue ,regToSub,subToMux1,muxtoReg: STD_LOGIC_VECTOR(6 downto 0);
	SIGNAL caout : std_LOGIC ;  

	COMPONENT addSub7bit 
	  port (
		 sub : IN STD_LOGIC;   
		 i_X, i_Y : IN STD_LOGIC_VECTOR(6 downto 0); 
		 o_Som : OUT STD_LOGIC_VECTOR(6 downto 0)
	  ) ;
	end COMPONENT ;
	
	
	COMPONENT SevenBitRegister 
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		i_clock			: IN	STD_LOGIC;
		i_Value			: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0));
		
    END COMPONENT;
	
	COMPONENT MUX2x1de7bit 
  port (
    i_sel : IN STD_LOGIC;
    i_D0, i_D1 : IN STD_LOGIC_VECTOR(6 downto 0);
	
	
    o_q :  out STD_LOGIC_VECTOR(6 downto 0)
  ) ;
end COMPONENT ;


BEGIN


sub  : addSub7bit port map('1',regToSub,"0000001",subtoMux1);

mux: mux2x1de7bit port map (i_dec,i_value,subToMux1,muxtoReg);

reg : sevenBitRegister port map(i_resetBar, i_load or i_dec, i_clock, muxtoReg,regToSub );

o_Null<= (not(regToSub(0)) and not(regToSub(1)) and not(regToSub(2)) and not(regToSub(3)) and not(regToSub(4)) and not(regToSub(5)) and not(regToSub(6)) );
O_Value  <=  regToSub;







	-- Output Driver 
END rtl;
