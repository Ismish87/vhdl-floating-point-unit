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

ENTITY CompareExpRegister IS
	PORT(
		i_resetBar, i_load	: IN	STD_LOGIC;
		A_Value			: IN	STD_LOGIC_VECTOR(6 downto 0);
		B_Value			: IN	STD_LOGIC_VECTOR(6 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0);
		osub_Value			: OUT	STD_LOGIC_VECTOR(6 downto 0);
		lowExp :  OUT STD_LOGIC;

		o_Carut 		: OUT STD_LOGIC);
END CompareExpRegister;

ARCHITECTURE rtl OF CompareExpRegister IS
	SIGNAL int_Value, int_notValue,int_compValue,muxtoreg ,outsub: STD_LOGIC_VECTOR(6 downto 0);
	
	
	
	COMPONENT addSub7bit 
	  port (
		 sub : IN STD_LOGIC;   
		 i_X, i_Y : IN STD_LOGIC_VECTOR(6 downto 0); 
		 o_Som : OUT STD_LOGIC_VECTOR(6 downto 0); 
		 o_CarOut: OUT STD_LOGIC  
	  ) ;
	end COMPONENT ;
	
	
	COMPONENT SevenBitRegister IS
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
	
	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;

BEGIN

subAB : addSub7bit PORT MAP (
		 '1',  
		 A_Value,
		 B_Value, 
		 int_Value , 
		  o_carut
	  ) ;
	  
int_notValue <= NOT(int_Value);

compR : addSub7bit PORT MAP (
		 '0',  
		 int_notValue,
		 "0000001", 
		 int_compValue
		  
	  ) ;
	  
	  


  
mux1: MUX2x1de7bit 
  port map (
    int_Value(6),
    int_Value, int_compValue ,muxtoreg
	 
  ) ;




		o_Value<=muxtoreg;
		osub_Value<= int_Value;


lowExp<=not(int_Value(6));




	-- Output Driver
	--o_Value		<= int_Value;

END rtl;
