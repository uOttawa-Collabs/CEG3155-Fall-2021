library ieee;
use ieee.std_logic_1164.all;

entity FixedPointALU is
    port (
        OperationSelect: in std_logic_vector(1 downto 0);
        OperandA, OperandB: in std_logic_vector(3 downto 0);
        GClock, GReset: in std_logic;
        
        MuxOut: out std_logic_vector(7 downto 0);
        CarryOut: out std_logic;
        ZeroOut: out std_logic;
        OverflowOut: out std_logic
    );
end;

architecture Structural of FixedPointALU is
    component AdderSubtractor4 is
        port (
            X, Y: in std_logic_vector(3 downto 0);
            SUB: in std_logic;
            S: out std_logic_vector(3 downto 0);
            Cout: out std_logic;
            V, Z: out std_logic
        );
    end component;
    
    component SignedMultiplier4 is
        port (
            X, Y: in std_logic_vector(3 downto 0);
            CLK, RESETN: in std_logic;
            P: out std_logic_vector(7 downto 0);
            V, Z: out std_logic
        );
    end component;
    
    component SignedDivider4 is
        port (
            X, Y: in std_logic_vector(3 downto 0);
            CLK, RESETN: in std_logic;
            Q, R: out std_logic_vector(3 downto 0);
            V, Z: out std_logic
        );
    end component;
    
    component MUX8bit4x1 is
        port (
            I3, I2, I1, I0: in std_logic_vector(7 downto 0);
            O: out std_logic_vector(7 downto 0);
            C: in std_logic_vector(1 downto 0)
        );
    end component;
    
    component MUX4x1 is
        port(
            INPUT: in std_logic_vector(3 downto 0);
            OUTPUT: out std_logic;
            C: in std_logic_vector(1 downto 0)
        );
    end component;
    
    signal signalAdditionSubtractionResult: std_logic_vector(3 downto 0);
    signal signalMultiplicationResult: std_logic_vector(7 downto 0);
    signal signalDivisionResult: std_logic_vector(7 downto 0);
    signal signalV, signalZ: std_logic_vector(0 to 2);
begin
    MUX8bit4x1Inst: MUX8bit4x1
        port map (
            I3 => signalDivisionResult,
            I2 => signalMultiplicationResult,
            I1(7 downto 4) => "0000",
            I1(3 downto 0) => signalAdditionSubtractionResult,
            I0(7 downto 4) => "0000",
            I0(3 downto 0) => signalAdditionSubtractionResult,
            O => MuxOut,
            C => OperationSelect
        );
        
    MUX4x1InstZ: MUX4x1
        port map (
            INPUT(3) => signalZ(2),
            INPUT(2) => signalZ(1),
            INPUT(1) => signalZ(0),
            INPUT(0) => signalZ(0),
            OUTPUT => ZeroOut,
            C => OperationSelect
        );
        
    MUX4x1InstV: MUX4x1
        port map (
            INPUT(3) => signalV(2),
            INPUT(2) => signalV(1),
            INPUT(1) => signalV(0),
            INPUT(0) => signalV(0),
            OUTPUT => OverflowOut,
            C => OperationSelect
        );
    
    adderSubtractorInst: AdderSubtractor4
        port map (
            X => OperandA,
            Y => OperandB,
            SUB => (not OperationSelect(1)) and OperationSelect(0),
            S => signalAdditionSubtractionResult,
            Cout => CarryOut,
            V => signalV(0),
            Z => signalZ(0)
        );
        
    multiplierInst: SignedMultiplier4
        port map (
            X => OperandA,
            Y => OperandB,
            CLK => GClock,
            RESETN => GReset,
            P => signalMultiplicationResult,
            V => signalV(1),
            Z => signalZ(1)
        );
        
    dividerInst: SignedDivider4
        port map (
            X => OperandA,
            Y => OperandB,
            CLK => GClock,
            RESETN => GReset,
            Q => signalDivisionResult(3 downto 0),
            R => signalDivisionResult(7 downto 4),
            V => signalV(2),
            Z => signalZ(2)
        );
end;
