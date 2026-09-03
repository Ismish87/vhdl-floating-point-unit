library ieee;
use ieee.std_logic_1164.all;

entity addFP is
  port(
    GClock      : in  std_logic;
    GReset      : in  std_logic; 

    SignA       : in  std_logic;
    MantissaA   : in  std_logic_vector(7 downto 0);
    ExponentA   : in  std_logic_vector(6 downto 0);

    SignB       : in  std_logic;
    MantissaB   : in  std_logic_vector(7 downto 0);
    ExponentB   : in  std_logic_vector(6 downto 0);

    SignOut     : out std_logic;
    MantissaOut : out std_logic_vector(7 downto 0);
    ExponentOut : out std_logic_vector(6 downto 0);
    Overflow    : out std_logic
	 
  );
end addFP;

architecture rtl of addFP is

  signal loadCompReg , loadDecReg , dec, loadShiftReg, loadEr, loadMres : std_logic;
  signal nullFlag, shiftR, normrez, shiftnorm : std_logic;
  signal expOverflow : std_logic;
  signal odec : std_logic_vector(6 downto 0);

  component datapath
    port(
      i_resetBar, i_loadCompReg, i_loadDecReg, dec, i_loadshiftReg, shift,
      i_loadEr, i_loadMres, shiftnorm : in  std_logic;
      i_clock                         : in  std_logic;
      dec_Null, normrez               : out std_logic;
      Ea, Eb                          : in  std_logic_vector(6 downto 0);
      Ma, Mb                          : in  std_logic_vector(7 downto 0);
      Er                              : out std_logic_vector(6 downto 0);
		expOverflow 						  : out std_logic;
      Mr                              : out std_logic_vector(7 downto 0);
      decvalue                        : out std_logic_vector(6 downto 0)
    );
  end component;

  component controlpath
    port(
      i_gresetBar : in  std_logic;
      i_gclock    : in  std_logic;
      decNull     : in  std_logic;
      normrez     : in  std_logic;
      loadCompReg : out std_logic;
      loadShiftReg: out std_logic;
      loaddecReg  : out std_logic;
      dec         : out std_logic;
      loadEr      : out std_logic;
      loadMr      : out std_logic;
      shift       : out std_logic
    );
  end component;

begin

  dp : datapath
    port map(
      i_resetBar     => GReset,
      i_loadCompReg  => loadCompReg,
      i_loadDecReg   => loadDecReg,
      dec            => dec,
		expOverflow => expOverflow,
      i_loadshiftReg => loadShiftReg,
      shift          => shiftR,
      i_loadEr       => loadEr,
      i_loadMres     => loadMres,
      shiftnorm      => shiftnorm,
      i_clock        => GClock,
      dec_Null       => nullFlag,
      normrez        => normrez,
      Ea             => ExponentA,
      Eb             => ExponentB,
      Ma             => MantissaA,
      Mb             => MantissaB,
      Er             => ExponentOut,
      Mr             => MantissaOut,
      decvalue       => odec
    );

  cp : controlpath
    port map(
      i_gresetBar  => GReset,
      i_gclock     => GClock,
      decNull      => nullFlag,
      normrez      => normrez,
      loadCompReg  => loadCompReg,
      loadShiftReg => loadShiftReg,
      loaddecReg   => loadDecReg,
      dec          => dec,
      loadEr       => loadEr,
      loadMr       => loadMres,
      shift        => shiftR
    );

  SignOut  <= '0';  
  Overflow <= expOverflow;    

end rtl;
