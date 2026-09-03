-- Full-additionneur 1 -bit


LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity additionneurUnBit is
  port (
    i_A, i_B : IN STD_LOGIC;   
    i_Cin : IN STD_LOGIC;  
    o_Somme : OUT STD_LOGIC;        
    o_Cout: OUT STD_LOGIC   
  ) ;
end additionneurUnBit ;

architecture arch of additionneurUnBit is

  SIGNAL sig1 ,sig2,sig3 : STD_LOGIC; 
 

  begin
    sig1 <= i_A xor i_B;
    sig2 <= sig1 and i_Cin ;
    sig3 <= i_A and i_B;

  -- Output 
  o_Somme <= sig1 xor i_Cin;
  o_Cout <= sig2 or sig3;


end architecture ;