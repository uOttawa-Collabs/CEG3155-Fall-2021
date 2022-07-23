library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity Multiplier4 is
    port (
        X, Y: in std_logic_vector(3 downto 0);
        CLK, RESETN: in std_logic;
        P: out std_logic_vector(7 downto 0);
        V, Z: out std_logic
    );
end;

architecture Structural of Multiplier4 is
    component Multiplier4Control is
        port (
            CLK: in std_logic;
            RESETN: in std_logic;
            PRD_0_Z: in std_logic;
            CNT_EQU_4: in std_logic;
            PRD_RESETN: out std_logic;
            PRD_SHIFT_RIGHT: out std_logic;
            PRD_LEFT_LOAD: out std_logic;
            PRD_RIGHT_LOAD: out std_logic;
            CNT_CLK: out std_logic;
            CNT_RESETN: out std_logic;
            OUT_LOAD: out std_logic;
            M_AND_RESETN: out std_logic;
            M_AND_LOAD: out std_logic;
            M_ER_RESETN: out std_logic;
            M_ER_LOAD: out std_logic
        );
    end component;

    component ShiftRegister8 is
        port (
            CLK, RESETN: in std_logic;
            MODE: in std_logic_vector(1 downto 0);
            SERIAL_IN_LEFT, SERIAL_IN_RIGHT: in std_logic;
            PARALLEL_IN: in std_logic_vector(7 downto 0);
            PARALLEL_OUT: out std_logic_vector(7 downto 0)
        );
        -- MODE: 00 for latching, 01 for parallel loading, 10 for shifting left, 11 for shifting right
    end component;

    component ShiftRegister4 is
        port (
            CLK, RESETN: in std_logic;
            MODE: in std_logic_vector(1 downto 0);
            SERIAL_IN_LEFT, SERIAL_IN_RIGHT: in std_logic;
            PARALLEL_IN: in std_logic_vector(3 downto 0);
            PARALLEL_OUT: out std_logic_vector(3 downto 0)
        );
        -- MODE: 00 for latching, 01 for parallel loading, 10 for shifting left, 11 for shifting right
    end component;
    
    component AdderSubtractor4 is
        port (
            X, Y: in std_logic_vector(3 downto 0);
            SUB: in std_logic;
            S: out std_logic_vector(3 downto 0);
            Cout: out std_logic;
            V, Z: out std_logic
        );
    end component;
    
    component Counter16 is
        port (
            CLK, RESETN, EN: in std_logic;
            VALUE: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal signalCounterClock: std_logic;
    signal signalCounterResetN: std_logic;
    signal signalCounterValue: std_logic_vector(3 downto 0);
    
    signal signalOutputLoad: std_logic;
    signal signalOutput: std_logic_vector(7 downto 0);
    
    signal signalSRMultiplicandResetN: std_logic;
    signal signalSRMultiplicandLoad: std_logic;
    signal signalSRMultiplicandOut: std_logic_vector(3 downto 0);
    
    signal signalSRMultiplierResetN: std_logic;
    signal signalSRMultiplierLoad: std_logic;
    signal signalSRMultiplierOut: std_logic_vector(3 downto 0);
    
    signal signalSRProductResetN: std_logic;
    signal signalSRProductLeftLoad: std_logic;
    signal signalSRProductRightLoad: std_logic;
    signal signalSRProductShiftRight: std_logic;
    
    signal signalSRProductLeftInput: std_logic_vector(3 downto 0);
    signal signalSRProductLeftOutput: std_logic_vector(3 downto 0);
    signal signalSRProductRightOutput: std_logic_vector(3 downto 0);
begin
    counter: Counter16
        port map (
            CLK => signalCounterClock,
            RESETN => RESETN and signalCounterResetN,
            EN => '1',
            VALUE => signalCounterValue
        );

    control: Multiplier4Control
        port map (
            CLK => CLK,
            RESETN => RESETN,
            PRD_0_Z => not signalSRProductRightOutput(0),
            CNT_EQU_4 => signalCounterValue(2) and (not signalCounterValue(1)) and signalCounterValue(0),
            PRD_RESETN => signalSRProductResetN,
            PRD_SHIFT_RIGHT => signalSRProductShiftRight,
            PRD_LEFT_LOAD => signalSRProductLeftLoad,
            PRD_RIGHT_LOAD => signalSRProductRightLoad,
            CNT_CLK => signalCounterClock,
            CNT_RESETN => signalCounterResetN,
            OUT_LOAD => signalOutputLoad,
            M_AND_RESETN => signalSRMultiplicandResetN,
            M_AND_LOAD => signalSRMultiplicandLoad,
            M_ER_RESETN => signalSRMultiplierResetN,
            M_ER_LOAD => signalSRMultiplierLoad
        );

    adderSubtractor4Inst: AdderSubtractor4
        port map (
            X => signalSRProductLeftOutput,
            Y => X,
            SUB => '0',
            S => signalSRProductLeftInput
        );
    
    SRMultiplicand: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN and signalSRMultiplicandResetN,
            MODE(1) => '0',
            MODE(0) => signalSRMultiplicandLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN => X,
            PARALLEL_OUT => signalSRMultiplicandOut
        );
    
    SRMultiplier: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN and signalSRMultiplierResetN,
            MODE(1) => '0',
            MODE(0) => signalSRMultiplierLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN => Y,
            PARALLEL_OUT => signalSRMultiplierOut
        );
    
    SRProductLeft: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN and signalSRProductResetN,
            MODE(1) => signalSRProductShiftRight,
            MODE(0) => signalSRProductShiftRight or signalSRProductLeftLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN => signalSRProductLeftInput,
            PARALLEL_OUT => signalSRProductLeftOutput
        );
        
    SRProductRight: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN and signalSRProductResetN,
            MODE(1) => signalSRProductShiftRight,
            MODE(0) => signalSRProductShiftRight or signalSRProductRightLoad,
            SERIAL_IN_LEFT => signalSRProductLeftOutput(0),
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN => Y,
            PARALLEL_OUT => signalSRProductRightOutput
        );
        
    SROutput: ShiftRegister8
        port map (
            CLK => CLK,
            RESETN => RESETN,
            MODE(1) => '0',
            MODE(0) => signalOutputLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN(7 downto 4) => signalSRProductLeftOutput,
            PARALLEL_IN(3 downto 0) => signalSRProductRightOutput,
            PARALLEL_OUT => signalOutput
        );
    
    P <= signalOutput;
    V <= '0';
    Z <= not (or_reduce(signalOutput));
end;
