LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY dataPath IS
    PORT(
        i_resetBar, i_loadCompReg , i_loadDecReg ,dec,i_loadshiftReg,shift,
        i_loadEr,i_loadMres,shiftnorm : IN  STD_LOGIC;

        i_clock     : IN  STD_LOGIC;

        dec_Null    : OUT STD_LOGIC;
        normrez     : OUT STD_LOGIC;

        expOverflow : OUT STD_LOGIC;

        Ea,Eb       : IN  STD_LOGIC_VECTOR(6 downto 0);
        Ma,Mb       : IN  STD_LOGIC_VECTOR(7 downto 0);

        decvalue    : OUT STD_LOGIC_VECTOR(6 downto 0);
        Er          : OUT STD_LOGIC_VECTOR(6 downto 0);
        Mr          : OUT STD_LOGIC_VECTOR(7 downto 0);

        m_Value     : OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END dataPath;

ARCHITECTURE rtl OF dataPath IS

    SIGNAL int_Value, int_notValue, compToDec, muxtoRexp : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL mMuxToShift, outshiftreg, muxtoshift, addMOut, addmuxtoadd, NormToM : STD_LOGIC_VECTOR(7 downto 0);

    SIGNAL outComp : STD_LOGIC;

    SIGNAL normrez_i : STD_LOGIC;

    SIGNAL next_exponent : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL overflow_bit  : STD_LOGIC;
    SIGNAL ssa, ssb, ssr : STD_LOGIC_VECTOR(6 downto 0);

    
    SIGNAL dummy_osub    : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL dummy_compcar : STD_LOGIC;
    SIGNAL dummy_iszero  : STD_LOGIC;
    SIGNAL dummy_bi      : STD_LOGIC;
    SIGNAL dummy_normcar : STD_LOGIC;

    COMPONENT addSub7bit
        PORT(
            sub      : IN  STD_LOGIC;
            i_X, i_Y : IN  STD_LOGIC_VECTOR(6 downto 0);
            o_Som    : OUT STD_LOGIC_VECTOR(6 downto 0);
            o_CarOut : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT SevenBitRegister IS
        PORT(
            i_resetBar, i_load : IN  STD_LOGIC;
            i_clock            : IN  STD_LOGIC;
            i_Value            : IN  STD_LOGIC_VECTOR(6 downto 0);
            o_Value            : OUT STD_LOGIC_VECTOR(6 downto 0)
        );
    END COMPONENT;

    COMPONENT MUX2x1de7bit
        PORT(
            i_sel      : IN  STD_LOGIC;
            i_D0, i_D1 : IN  STD_LOGIC_VECTOR(6 downto 0);
            o_q        : OUT STD_LOGIC_VECTOR(6 downto 0)
        );
    END COMPONENT;

    COMPONENT SevenBitDecRegister
        PORT(
            i_resetBar, i_load : IN  STD_LOGIC;
            i_clock            : IN  STD_LOGIC;
            i_dec              : IN  STD_LOGIC;
            i_Value            : IN  STD_LOGIC_VECTOR(6 downto 0);
            o_Value            : OUT STD_LOGIC_VECTOR(6 downto 0);
            o_Null             : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT CompareExpRegister
        PORT(
            i_resetBar, i_load : IN  STD_LOGIC;
            A_Value            : IN  STD_LOGIC_VECTOR(6 downto 0);
            B_Value            : IN  STD_LOGIC_VECTOR(6 downto 0);
            o_Value            : OUT STD_LOGIC_VECTOR(6 downto 0);
            osub_Value         : OUT STD_LOGIC_VECTOR(6 downto 0);
            lowExp             : OUT STD_LOGIC;
            o_Carut            : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT eightBitRightShiftRegister
        PORT(
            i_resetBar, i_load, i_shift : IN  STD_LOGIC;
            i_clock                     : IN  STD_LOGIC;
            o_iszero, o_bi              : OUT STD_LOGIC;
            i_Value                     : IN  STD_LOGIC_VECTOR(7 downto 0);
            o_Value                     : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT addSub8bit
        PORT(
            sub      : IN  STD_LOGIC;
            i_X, i_Y : IN  STD_LOGIC_VECTOR(7 downto 0);
            o_Som    : OUT STD_LOGIC_VECTOR(7 downto 0);
            o_CarOut : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT MUX2x1de8bit
        PORT(
            i_sel      : IN  STD_LOGIC;
            i_D0, i_D1 : IN  STD_LOGIC_VECTOR(7 downto 0);
            o_q        : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT eightBitRegister
        PORT(
            i_resetBar, i_load : IN  STD_LOGIC;
            i_clock            : IN  STD_LOGIC;
            i_Value            : IN  STD_LOGIC_VECTOR(7 downto 0);
            o_Value            : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT NormalizeRegister
        PORT(
            i_resetBar, i_load, i_clock : IN  STD_LOGIC;
            R_Value                     : IN  STD_LOGIC_VECTOR(7 downto 0);
            o_carut                     : OUT STD_LOGIC;
            o_Value                     : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

BEGIN

    comp : CompareExpRegister
        PORT MAP(
            i_resetBar => i_resetBar,
            i_load     => i_loadCompReg,
            A_Value    => Ea,
            B_Value    => Eb,
            o_Value    => compToDec,
            osub_Value => dummy_osub,
            lowExp     => outComp,
            o_Carut    => dummy_compcar
        );

    decReg : SevenBitDecRegister
        PORT MAP(
            i_resetBar => i_resetBar,
            i_load     => i_loadDecReg,
            i_clock    => i_clock,
            i_dec      => dec,
            i_Value    => compToDec,
            o_Value    => decvalue,
            o_Null     => dec_Null
        );

    mantisseMux : MUX2x1de8bit
        PORT MAP(outComp, Ma, Mb, muxtoshift);

    shiftReg : eightBitRightShiftRegister
        PORT MAP(
            i_resetBar => i_resetBar,
            i_load     => i_loadshiftReg,
            i_shift    => shift,
            i_clock    => i_clock,
            o_iszero   => dummy_iszero,
            o_bi       => dummy_bi,
            i_Value    => muxtoshift,
            o_Value    => outshiftreg
        );

    m_Value <= outshiftreg;

    expMux : MUX2x1de7bit
        PORT MAP(not(outComp), Ea, Eb, muxtoRexp);

    addMux : MUX2x1de8bit
        PORT MAP(not(outComp), Ma, Mb, addmuxtoadd);

    add8bit : addSub8bit
        PORT MAP('0', addmuxtoadd, outshiftreg, addMOut, normrez_i);

    normrez <= normrez_i;

		NormalizeReg : NormalizeRegister
			port map(i_resetBar, i_loadMres, i_clock, addMOut, dummy_normcar, NormToM);


    MrReg : eightBitRegister
        PORT MAP(i_resetBar, i_loadMres, i_clock, NormToM, Mr);


    ssa <= muxtoRexp;
    ssb <= "0000001";

    expPlus1 : addSub7bit
        PORT MAP('0', ssa, ssb, ssr, overflow_bit);

    expNormMux : MUX2x1de7bit
        PORT MAP(normrez_i, muxtoRexp, ssr, next_exponent);

    ErReg : SevenBitRegister
        PORT MAP(i_resetBar, i_loadEr, i_clock, next_exponent, Er);

    expOverflow <= normrez_i AND overflow_bit;

END rtl;
