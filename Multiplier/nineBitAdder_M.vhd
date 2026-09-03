--------------------------------------------------------------------------------
-- Titre         : 9-Bit Full Adder (fpMultiplier variation)
-- Fichier       : nineBitAdder_M.vhd
-------------------------------------------------------------------------------


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY nineBitAdder_M IS
	PORT ( 		i_x			: IN STD_LOGIC_VECTOR(8 downto 0);
			i_y			: IN STD_LOGIC_VECTOR(8 downto 0);
			i_cin			: IN STD_LOGIC;
			o_cout			: OUT STD_LOGIC;
			o_q			: OUT STD_LOGIC_VECTOR(8 downto 0));
END nineBitAdder_M;

ARCHITECTURE struct OF nineBitAdder_M IS

COMPONENT oneBitFullAdder
	PORT ( 		i_x		: IN STD_LOGIC;
			i_y 		: IN STD_LOGIC;
			i_cin		: IN STD_LOGIC;
			o_cout		: OUT STD_LOGIC;
			o_s		: OUT STD_LOGIC);
END COMPONENT;

SIGNAL int_c : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_s : STD_LOGIC_VECTOR(8 downto 0);

BEGIN

adder0: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(0),
			i_y => i_y(0),
			i_cin => i_cin,
			o_cout => int_c(0),
			o_s => int_s(0));

adder1: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(1),
			i_y => i_y(1),
			i_cin => int_c(0),
			o_cout => int_c(1),
			o_s => int_s(1));

adder2: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(2),
			i_y => i_y(2),
			i_cin => int_c(1),
			o_cout => int_c(2),
			o_s => int_s(2));


adder3: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(3),
			i_y => i_y(3),
			i_cin => int_c(2),
			o_cout => int_c(3),
			o_s => int_s(3));

adder4: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(4),
			i_y => i_y(4),
			i_cin => int_c(3),
			o_cout => int_c(4),
			o_s => int_s(4));

adder5: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(5),
			i_y => i_y(5),
			i_cin => int_c(4),
			o_cout => int_c(5),
			o_s => int_s(5));

adder6: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(6),
			i_y => i_y(6),
			i_cin => int_c(5),
			o_cout => int_c(6),
			o_s => int_s(6));

adder7: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(7),
			i_y => i_y(7),
			i_cin => int_c(6),
			o_cout => int_c(7),
			o_s => int_s(7));

adder8: oneBitFullAdder
	PORT MAP ( 	i_x => i_x(8),
			i_y => i_y(8),
			i_cin => int_c(7),
			o_cout => o_cout,
			o_s => int_s(8));

	-- Sorties
	o_q <= int_s;

END struct;
