LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
entity MUX2x1de8bit is
  port (
    i_sel : IN STD_LOGIC;
    i_D0, i_D1 : IN STD_LOGIC_VECTOR(7 downto 0);
	
	
    o_q :  out STD_LOGIC_VECTOR(7 downto 0)
  ) ;
end MUX2x1de8bit ;

architecture i_sel of MUX2x1de8bit is

    SIGNAL int_q : STD_LOGIC_VECTOR(7 downto 0);

begin
    WITH i_sel SELECT
        int_q <= i_D0 WHEN '0',
        	 i_D1 WHEN '1';
 
        

    -- Output driver
    o_q <= int_q;

end architecture ; -- arch