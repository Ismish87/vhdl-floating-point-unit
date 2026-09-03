--------------------------------------------------------------------------------
-- Title         : 3-bit Shift Register
-- Project       : VHDL Synthesis Overview
-------------------------------------------------------------------------------
-- File          : threeBitShiftRegister.vhd
-- Author        : Rami Abielmona  <rabielmo@site.uottawa.ca>
-- Created       : 2003/05/17
-- Last modified : 2007/09/25
-------------------------------------------------------------------------------
-- Description : This file creates a 3-bit shift register as defined in the VHDL 
--		 Synthesis lecture. The architecture is done at the RTL 
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

ENTITY eightBitRightShiftRegisterMod IS
	PORT(
		i_resetBar, i_load, i_shift	: IN	STD_LOGIC;
		i_clock	,i_decal		: IN	STD_LOGIC;
		o_iszero,o_bi : OUT STD_LOGIC ;
		i_Value			: IN	STD_LOGIC_VECTOR(7 downto 0);
		o_Value			: OUT	STD_LOGIC_VECTOR(7 downto 0)
		);
		
END eightBitRightShiftRegisterMod;

ARCHITECTURE rtl OF eightBitRightShiftRegisterMod IS
	SIGNAL int_Value, int_notValue ,outmux: STD_LOGIC_VECTOR(7 downto 0);
	SIgNAL zeroFlag :STD_LOGIC ;

	COMPONENT enARdFF_2
		PORT(
			i_resetBar	: IN	STD_LOGIC;
			i_d		: IN	STD_LOGIC;
			i_enable	: IN	STD_LOGIC;
			i_clock		: IN	STD_LOGIC;
			o_q, o_qBar	: OUT	STD_LOGIC);
	END COMPONENT;
	    COMPONENT t2x1MUX
        port (
    i_sel : IN STD_LOGIC;
    i_D0, i_D1 : IN STD_LOGIC;
	
	
    o_q : OUT STD_LOGIC
  ) ;
    END COMPONENT;

BEGIN

  ZERoFlag <=NOT(int_Value(0) OR int_Value(1) OR int_Value(2) OR int_Value(3) OR int_Value(4) OR int_Value(5) OR int_Value(6) OR int_Value(7));


mux7 :t2x1MUX port map(i_shift,i_value(7),i_decal,outmux(7));

			  
bit7: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(7), 
			  i_enable  => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(7),
	          o_qBar => int_notValue(7));
				 
mux6 :t2x1MUX port map(i_shift,i_value(6),int_Value(7),outmux(6));


bit6: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(6), 
			  i_enable  => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(6),
	          o_qBar => int_notValue(6));

				 
mux5 :t2x1MUX port map(i_shift,i_value(5),int_Value(6),outmux(5));

bit5: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(5),
			  i_enable => i_load or i_shift, 
			  i_clock => i_clock,
			  o_q => int_Value(5),
	          o_qBar => int_notValue(5));


				 
mux4 :t2x1MUX port map(i_shift,i_value(4),int_Value(5),outmux(4));

bit4: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(4), 
			  i_enable  => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(4),
	          o_qBar => int_notValue(4));
			
mux3 :t2x1MUX port map(i_shift,i_value(3),int_Value(4),outmux(3));

bit3: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(3), 
			  i_enable => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(3),
	          o_qBar => int_notValue(3));


mux2 :t2x1MUX port map(i_shift,i_value(2),int_Value(3),outmux(2));

bit2: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(2), 
			  i_enable  => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(2),
	          o_qBar => int_notValue(2));
				 
mux1 :t2x1MUX port map(i_shift,i_value(1),int_Value(2),outmux(1));

bit1: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(1), 
			  i_enable  => i_load or i_shift,
			  i_clock => i_clock,
			  o_q => int_Value(1),
	          o_qBar => int_notValue(1));

				 
mux0 :t2x1MUX port map(i_shift,i_value(0),int_Value(1),outmux(0));

bit0: enARdFF_2
	PORT MAP (i_resetBar => i_resetBar,
			  i_d => outmux(0),
			  i_enable  => i_load or i_shift, 
			  i_clock => i_clock,
			  o_q => int_Value(0),
	          o_qBar => int_notValue(0));

	-- Output Driver
	o_Value		<= int_Value;
	o_bi <= int_Value(0);
	o_iszero   <= ZERoFlag ;

END rtl;