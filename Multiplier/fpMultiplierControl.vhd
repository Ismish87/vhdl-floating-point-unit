--------------------------------------------------------------------------------
-- Titre         : Floating-Point Multiplier Control Path
-- Fichier       : fpMultiplierControl.vhd
-------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpMultiplierControl IS
	PORT (
		i_resetBar, i_clock			   : IN		STD_LOGIC;
		i_coutFz				   : IN		STD_LOGIC;
		o_loadREx, o_loadREy, o_loadRFx, o_loadRFy : OUT	STD_LOGIC;
		o_loadREz, o_loadRFz			   : OUT	STD_LOGIC;
		o_countUREz, o_shiftRFz, o_done 	   : OUT	STD_LOGIC;
		o_state					   : OUT	STD_LOGIC_VECTOR(0 to 3));
END fpMultiplierControl;

ARCHITECTURE rtl of fpMultiplierControl IS

COMPONENT enASdFF
	PORT (
		i_resetBar : IN STD_LOGIC;
		i_d	: IN STD_LOGIC;
		i_clock : IN STD_LOGIC;
		i_enable : IN STD_LOGIC; 
		o_q, o_qBar : OUT STD_LOGIC); 
END COMPONENT;

COMPONENT enARdFF_2
	PORT (
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END COMPONENT;

SIGNAL int_d, int_state : STD_LOGIC_VECTOR(0 to 3);

BEGIN
int_d(0) <= '0';
int_d(1) <= int_state(0);
int_d(2) <= int_state(1) AND i_coutFz;
int_d(3) <= int_state(2) OR (int_state(1) AND NOT(i_coutFz)) OR int_state(3);

s0: enASdFF
	PORT MAP (	i_resetBar => i_resetBar,
			i_clock => i_clock,
			i_d => int_d(0),
			i_enable => '1',
			o_q => int_state(0));

s1: enARdFF_2
	PORT MAP (	i_resetBar => i_resetBar,
			i_clock => i_clock,
			i_d => int_d(1),
			i_enable => '1',
			o_q => int_state(1));

s2: enARdFF_2
	PORT MAP (	i_resetBar => i_resetBar,
			i_clock => i_clock,
			i_d => int_d(2),
			i_enable => '1',
			o_q => int_state(2));

s3: enARdFF_2
	PORT MAP (	i_resetBar => i_resetBar,
			i_clock => i_clock,
			i_d => int_d(3),
			i_enable => '1',
			o_q => int_state(3));

	--  sorties
	o_state <= int_state;

	o_loadREx <= int_state(0);
	o_loadREy <= int_state(0);
	o_loadRFx <= int_state(0);
	o_loadRFy <= int_state(0);
	
	o_loadREz <= int_state(1);
	o_loadRFz <= int_state(1);

	o_countUREz <= int_state(2);
	o_shiftRFz <= int_state(2);

	o_done <= int_state(3);



END rtl;
