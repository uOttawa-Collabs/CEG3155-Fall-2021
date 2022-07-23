library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_misc.all;

entity Divider4 is
    port (
        X, Y: in std_logic_vector(3 downto 0);
        CLK, RESETN: in std_logic;
        Q, R: out std_logic_vector(3 downto 0);
        V, Z: out std_logic
    );
end;

architecture Structural of Divider4 is
    component Divider4Control is
        port (
            CLK: in std_logic;
            RESETN: in std_logic;
            REM_N: in std_logic;
            CNT_EQU: in std_logic;
            REM_RESETN: out std_logic;
            REM_SHL: out std_logic;
            REM_S_RIGHT: out std_logic;
            REM_LEFT_LOAD: out std_logic;
            REM_LEFT_SHR: out std_logic;
            REM_RIGHT_LOAD: out std_logic;
            CNT_CLK: out std_logic;
            CNT_RESETN: out std_logic;
            OUT_LOAD: out std_logic;
            ALU_SUB: out std_logic;
            D_ND_RESETN: out std_logic;
            D_ND_LOAD: out std_logic;
            D_OR_RESETN: out std_logic;
            D_OR_LOAD: out std_logic
        );
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
    
    signal signalSubtract: std_logic;
    
    signal signalSRDividendResetN: std_logic;
    signal signalSRDividendLoad: std_logic;
    signal signalSRDividendOut: std_logic_vector(3 downto 0);
    
    signal signalSRDivisorResetN: std_logic;
    signal signalSRDivisorLoad: std_logic;
    signal signalSRDivisorOut: std_logic_vector(3 downto 0);
    
    signal signalSRRemainderResetN: std_logic;
    signal signalSRRemainderLeftLoad: std_logic;
    signal signalSRRemainderRightLoad: std_logic;
    signal signalSRRemainderShiftLeft: std_logic;
    signal signalSRRemainderLeftShiftRight: std_logic;
    signal signalSRRemainderLeftInput, signalSRRemainderLeftOutput: std_logic_vector(3 downto 0);
    signal signalSRRemainderRightInput, signalSRRemainderRightOutput: std_logic_vector(3 downto 0);
    signal signalSRRemainderRightSerialInRight: std_logic;
    
begin
    counter: Counter16
        port map (
            CLK => signalCounterClock,
            RESETN => RESETN and signalCounterResetN,
            EN => '1',
            VALUE => signalCounterValue
        );

    control: Divider4Control
        port map (
            CLK => CLK,
            RESETN => RESETN,
            REM_N => signalSRRemainderLeftOutput(3),
            CNT_EQU => signalCounterValue(2) and (not signalCounterValue(1)) and signalCounterValue(0),
            REM_RESETN => signalSRRemainderResetN,
            REM_SHL => signalSRRemainderShiftLeft,
            REM_S_RIGHT => signalSRRemainderRightSerialInRight,
            REM_LEFT_LOAD => signalSRRemainderLeftLoad,
            REM_LEFT_SHR => signalSRRemainderLeftShiftRight,
            REM_RIGHT_LOAD => signalSRRemainderRightLoad,
            CNT_CLK => signalCounterClock,
            CNT_RESETN => signalCounterResetN,
            OUT_LOAD => signalOutputLoad,
            ALU_SUB => signalSubtract,
            D_ND_RESETN => signalSRDividendResetN,
            D_ND_LOAD => signalSRDividendLoad,
            D_OR_RESETN => signalSRDivisorResetN,
            D_OR_LOAD => signalSRDivisorLoad
        );
    
    adderSubtractor4Inst: AdderSubtractor4
        port map (
            X => signalSRRemainderLeftOutput,
            Y => Y,
            SUB => signalSubtract,
            S => signalSRRemainderLeftInput
        );
        
    SRDividend: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN and signalSRDividendResetN,
            MODE(1) => '0',
            MODE(0) => signalSRDividendLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN => X,
            PARALLEL_OUT => signalSRDividendOut
        );
        
    SRDivisor: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN and signalSRDivisorResetN,
            MODE(1) => '0',
            MODE(0) => signalSRDivisorLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN => Y,
            PARALLEL_OUT => signalSRDivisorOut
        );
    
    SRRemainderLeft: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN and signalSRRemainderResetN,
            MODE(1) => signalSRRemainderShiftLeft or signalSRRemainderLeftShiftRight,
            MODE(0) => (not signalSRRemainderShiftLeft) or signalSRRemainderLeftShiftRight or signalSRRemainderLeftLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => signalSRRemainderRightOutput(3),
            PARALLEL_IN => signalSRRemainderLeftInput,
            PARALLEL_OUT => signalSRRemainderLeftOutput
        );
        
    SRRemainderRight: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN and signalSRRemainderResetN,
            MODE(1) => signalSRRemainderShiftLeft,
            MODE(0) => (not signalSRRemainderShiftLeft) or signalSRRemainderRightLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => signalSRRemainderRightSerialInRight,
            PARALLEL_IN => X,
            PARALLEL_OUT => signalSRRemainderRightOutput
        );
        
    SRRemainderOutput: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN,
            MODE(1) => '0',
            MODE(0) => signalOutputLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN => signalSRRemainderLeftOutput,
            PARALLEL_OUT => R
        );
    
    SRQuotientOutput: ShiftRegister4
        port map (
            CLK => CLK,
            RESETN => RESETN,
            MODE(1) => '0',
            MODE(0) => signalOutputLoad,
            SERIAL_IN_LEFT => '0',
            SERIAL_IN_RIGHT => '0',
            PARALLEL_IN => signalSRRemainderRightOutput,
            PARALLEL_OUT => Q
        );
    
    V <= not (or_reduce(Y));
    Z <= not (or_reduce(signalSRRemainderLeftOutput) or or_reduce(signalSRRemainderRightOutput));
end;
