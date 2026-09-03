---    :4-bit additionneur soustracteur

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity addSub8bit is
  port (
    sub : IN STD_LOGIC;   
    i_X, i_Y : IN STD_LOGIC_VECTOR(7 downto 0); 
    o_Som : OUT STD_LOGIC_VECTOR(7 downto 0); 
    o_CarOut: OUT STD_LOGIC  
  ) ;
end addSub8bit ;

architecture arch of addSub8bit is
    SIGNAL Somme, CarryOut: STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL Y : STD_LOGIC_VECTOR(7 downto 0);

    COMPONENT additionneurUnBit
      port (
    i_A, i_B : IN STD_LOGIC;   
    i_Cin : IN STD_LOGIC;  
    o_Somme : OUT STD_LOGIC;        
    o_Cout: OUT STD_LOGIC   
  ) ;
    END COMPONENT;

begin
	
    Y(7) <= i_Y(7) xor sub;
	 Y(6) <= i_Y(6) xor sub;
	 Y(5) <= i_Y(5) xor sub;
    Y(4) <= i_Y(4) xor sub;
    Y(3) <= i_Y(3) xor sub;
    Y(2) <= i_Y(2) xor sub;
    Y(1) <= i_Y(1) xor sub;
    Y(0) <= i_Y(0) xor sub;

    fa0: additionneurUnBit port map(i_X(0), Y(0), sub, Somme(0), CarryOut(0));
    fa1: additionneurUnBit port map(i_X(1), Y(1), CarryOut(0), Somme(1), CarryOut(1));
    fa2: additionneurUnBit port map(i_X(2), Y(2), CarryOut(1), Somme(2), CarryOut(2));
	 fa3: additionneurUnBit port map(i_X(3), Y(3), CarryOut(2), Somme(3), CarryOut(3));
	 fa4: additionneurUnBit port map(i_X(4), Y(4), CarryOut(3), Somme(4), CarryOut(4));
	 fa5: additionneurUnBit port map(i_X(5), Y(5), CarryOut(4), Somme(5), CarryOut(5));
	 fa6: additionneurUnBit port map(i_X(6), Y(6), CarryOut(5), Somme(6), CarryOut(6));
    fa7: additionneurUnBit port map(i_X(7), Y(7), CarryOut(6), Somme(7), CarryOut(7));
	
    -- Output 
	o_Som <= Somme;
	o_CarOut <= CarryOut(7);

end architecture ; 