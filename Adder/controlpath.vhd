-- Title         : Control Path for Lab 2
-------------------------------------------------------------------------------
-- File          : controlpath.vhd
-------------------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
entity controlpath is
  port (
    i_gresetBar : IN STD_LOGIC;
    i_gclock  : IN STD_LOGIC;
    decNull ,normrez: IN STD_LOGIC;
	 loadCompReg,loadShiftReg,loaddecReg,dec,loadEr,loadMr,shift : OUT STD_LOGIC) ;
end controlpath ;

architecture arch of controlpath is
    SIGNAL int_state, int_d : STD_LOGIC_VECTOR(8 downto 0);
	 
	 SIGNAL AXORB :std_LOGIC;
	 
	 

    COMPONENT enardFF_2
        PORT(
            i_resetBar	: IN	STD_LOGIC;
            i_d		: IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC
        );
		  
    END COMPONENT;
	 
	 component enARdFF_2S0
	PORT(
		i_resetBar	: IN	STD_LOGIC;
		i_d		: IN	STD_LOGIC;
		i_enable	: IN	STD_LOGIC;
		i_clock		: IN	STD_LOGIC;
		o_q, o_qBar	: OUT	STD_LOGIC);
END component;

begin



    int_d(0) <= '0';
    int_d(1) <= ( int_State(0));
	 int_d(2) <= ( int_State(1));
	 int_d(3) <= ( not(decNull) and(int_State(2) or int_State(4)));
    int_d(4) <= ( int_State(3));
    int_d(5) <= ( (decNull) and(int_State(2) or int_State(4)));
    state0: enARdFF_2S0 port map(i_gresetBar,int_d(0), '1', i_gclock, int_State(0));
    state1: enardFF_2 port map(i_gresetBar, int_d(1), '1', i_gclock, int_State(1));
	 state2: enardFF_2 port map(i_gresetBar, int_d(2), '1', i_gclock, int_State(2));
    state3: enardFF_2 port map(i_gresetBar, int_d(3), '1', i_gclock, int_State(3));
    state4: enardFF_2 port map(i_gresetBar, int_d(4), '1', i_gclock, int_State(4));
    state5: enardFF_2 port map(i_gresetBar, int_d(5), '1', i_gclock, int_State(5));
	 
    -- Output Drivers
	 
	loadCompReg<= int_State(0);
	loadShiftReg<= int_State(2);
  	loaddecReg<= int_State(1);
	dec<= int_State(3);
	shift<= int_State(4);
	loadEr<= int_State(5);
	loadMr<= int_State(5);
end architecture ; -- arch