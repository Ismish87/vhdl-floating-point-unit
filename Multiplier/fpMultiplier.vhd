LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY fpMultiplier IS
	PORT (	
	       GClock, GReset           : IN    STD_LOGIC;
	       SignA, SignB 		: IN 	STD_LOGIC;
	       MantissaA, MantissaB     : IN    STD_LOGIC_VECTOR(7 downto 0);
	       ExponentA, ExponentB     : IN    STD_LOGIC_VECTOR(6 downto 0);
	       SignOut                  : OUT   STD_LOGIC;
	       MantissaOut              : OUT   STD_LOGIC_VECTOR(7 downto 0);
	       ExponentOut		: OUT	STD_LOGIC_VECTOR(6 downto 0);
	       Overflow			: OUT 	STD_LOGIC);
END fpMultiplier;

ARCHITECTURE rtl OF fpMultiplier IS

COMPONENT nineBitAdder_M
	PORT ( 		i_x			: IN STD_LOGIC_VECTOR(8 downto 0);
			i_y			: IN STD_LOGIC_VECTOR(8 downto 0);
			i_cin			: IN STD_LOGIC;
			o_cout			: OUT STD_LOGIC;
			o_q			: OUT STD_LOGIC_VECTOR(8 downto 0));
END COMPONENT;

COMPONENT nineBitMultiplier
	PORT (		i_A, i_B		: IN	STD_LOGIC_VECTOR(8 downto 0);
			o_cout			: OUT	STD_LOGIC;
			o_q			: OUT	STD_LOGIC_VECTOR(8 downto 0));
END COMPONENT;

COMPONENT sevenBitRegister
	PORT (
			i_GReset	: IN	STD_LOGIC;
			i_clock 	: IN	STD_LOGIC;
			i_E		: IN	STD_LOGIC_VECTOR(6 downto 0);
			i_load 		: IN	STD_LOGIC;
			o_E		: OUT	STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT nineBitShiftRegister
	PORT ( 
			i_resetBar, i_clock 			: IN 	STD_LOGIC;	 
			i_load, i_clear, i_shift		: IN	STD_LOGIC;
			i_A					: IN	STD_LOGIC_VECTOR(8 downto 0);
			o_q					: OUT	STD_LOGIC_VECTOR(8 downto 0));
END COMPONENT;

COMPONENT eightBitAdder_M
	PORT ( 
			i_x		: IN STD_LOGIC_VECTOR(7 downto 0);
			i_y		: IN STD_LOGIC_VECTOR(7 downto 0);
			i_cin		: IN STD_LOGIC;
			o_cout		: OUT STD_LOGIC;
			o_s		: OUT STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT sevenBitUpCounter
	PORT (
			i_resetBar, i_load, i_countU	: IN	STD_LOGIC;
			i_A				: IN 	STD_LOGIC_VECTOR(6 downto 0);
			i_clock				: IN	STD_LOGIC;
			o_q				: OUT	STD_LOGIC_VECTOR(6 downto 0));
END COMPONENT;

COMPONENT fpMultiplierControl
	PORT (
			i_resetBar, i_clock			   : IN		STD_LOGIC;
			i_coutFz				   : IN		STD_LOGIC;
			o_loadREx, o_loadREy, o_loadRFx, o_loadRFy : OUT	STD_LOGIC;
			o_loadREz, o_loadRFz			   : OUT	STD_LOGIC;
			o_countUREz, o_shiftRFz, o_done 	   : OUT	STD_LOGIC;
			o_state					   : OUT	STD_LOGIC_VECTOR(0 to 3));
END COMPONENT;

--Status signals
SIGNAL int_coutFz : STD_LOGIC;

--Control signals
SIGNAL int_loadREx, int_loadREy, int_loadRFx, int_loadRFy : STD_LOGIC;
SIGNAL int_countUREz, int_loadREz, int_loadRFz, int_shiftRFz : STD_LOGIC;
SIGNAL int_done : STD_LOGIC;
SIGNAL int_state : STD_LOGIC_VECTOR(0 to 3);

--Datapath signals
SIGNAL int_extendedREx, int_extendedREy : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_exponentSign : STD_LOGIC;
SIGNAL int_Fx, int_Fy : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL int_REx, int_REy : STD_LOGIC_VECTOR(6 downto 0);
SIGNAL int_EsumUnbiased : STD_LOGIC_VECTOR(7 downto 0);
SIGNAL int_Esum : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL int_REz : STD_LOGIC_VECTOR(6 downto 0);
SIGNAL int_RFx, int_RFy : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL int_Fz : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL int_RFz : STD_LOGIC_VECTOR(8 downto 0);
SIGNAL int_signedEsumUnbiased : STD_LOGIC_VECTOR(8 downto 0);
BEGIN

int_extendedREx <= '0' & int_REx;
int_extendedREy <= '0' & int_REy;

int_Fx <= '1' & MantissaA;
int_Fy <= '1' & MantissaB;

int_signedEsumUnbiased <= '0' & int_EsumUnbiased;

controlLogic: fpMultiplierControl
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_coutFz => int_coutFz,
			o_loadREx => int_loadREx,
			o_loadREy => int_loadREy,
			o_loadRFx => int_loadRFx,
			o_loadRFy => int_loadRFy,
			o_loadREz => int_loadREz,
			o_loadRFz => int_loadRFz,
			o_countUREz => int_countUREz,
			o_shiftRFz => int_shiftRFz,
			o_done => int_done,
			o_state => int_state);

REx: sevenBitRegister
	PORT MAP (	i_GReset => GReset,
			i_clock => GClock,
			i_E => ExponentA,
			i_load => int_loadREx,
			o_E => int_REx);

REy: sevenBitRegister
	PORT MAP (	i_GReset => GReset,
			i_clock => GClock,
			i_E => ExponentB,
			i_load => int_loadREy,
			o_E => int_REy);

ExponentAdder: eightBitAdder_M
	PORT MAP (	i_x => int_extendedREx,
			i_y => int_extendedREy,
			i_cin => '0',
			o_s => int_EsumUnbiased);

subtractor: nineBitAdder_M
	PORT MAP (	i_x => int_signedEsumUnbiased,
			i_y => "111000000",
			i_cin => '1',
			o_q => int_Esum);

exponentCounter: sevenBitUpCounter
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_A => int_Esum(6 downto 0),
			i_load => int_loadREz,
			i_countU => int_countUREz,
			o_q => int_REz);

Fx: nineBitShiftRegister
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_load => int_loadRFx,
			i_shift => '0',
			i_clear => '0',
			i_A => int_Fx,
			o_q => int_RFx);

Fy: nineBitShiftRegister
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_load => int_loadRFy,
			i_shift => '0',
			i_clear => '0',
			i_A => int_Fy,
			o_q => int_RFy);

multiplier: nineBitMultiplier
	PORT MAP (	i_A => int_RFx,
			i_B => int_RFy,
			o_cout => int_coutFz,
			o_q => int_Fz);

Fz: nineBitShiftRegister
	PORT MAP (	i_resetBar => GReset,
			i_clock => GClock,
			i_load => int_loadRFz,
			i_shift => int_shiftRFz,
			i_clear => '0',
			i_A => int_Fz,
			o_q => int_RFz);

	-- Sorties
	Overflow <= (int_state(2) OR int_state(3)) AND (int_Esum(8) OR int_Esum(7));
	SignOut <= SignA XOR SignB;
	MantissaOut <= int_RFz(7 downto 0);
	ExponentOut <= int_REz;

END rtl;