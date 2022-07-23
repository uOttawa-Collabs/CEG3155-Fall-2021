library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister4 is
    port (
        CLK, RESETN: in std_logic;
        MODE: in std_logic_vector(1 downto 0);
        SERIAL_IN_LEFT, SERIAL_IN_RIGHT: in std_logic;
        PARALLEL_IN: in std_logic_vector(3 downto 0);
        PARALLEL_OUT: out std_logic_vector(3 downto 0)
    );
    -- MODE: 00 for latching, 01 for parallel loading, 10 for shifting left, 11 for shifting right
end;

architecture Structural of ShiftRegister4 is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    
    component MUX4x1 is
        port(
            INPUT: in std_logic_vector(3 downto 0);
            OUTPUT: out std_logic;
            C: in std_logic_vector(1 downto 0)
        );
    end component;
    
    signal signalDFFOutput: std_logic_vector(3 downto 0);
    signal signalMUXOutput: std_logic_vector(3 downto 0);
    signal signalMUXInputLeftShift: std_logic_vector(3 downto 0);
    signal signalMUXInputRightShift: std_logic_vector(3 downto 0);
begin
    signalMUXInputLeftShift(0) <= SERIAL_IN_RIGHT;
    signalMUXInputLeftShift(3 downto 1) <= signalDFFOutput(2 downto 0);
    signalMUXInputRightShift(3) <= SERIAL_IN_LEFT;
    signalMUXInputRightShift(2 downto 0) <= signalDFFOutput(3 downto 1);
    
    generateMUX: for i in 3 downto 0 generate
        MUX4x1Inst: MUX4x1
            port map (
                INPUT(3) => signalMUXInputRightShift(i),
                INPUT(2) => signalMUXInputLeftShift(i),
                INPUT(1) => PARALLEL_IN(i),
                INPUT(0) => signalDFFOutput(i),
                OUTPUT => signalMUXOutput(i),
                C => MODE
            );
    end generate;
    
    generateDFF: for i in 3 downto 0 generate
        DFFInst: enARdFF_2
            port map (
                i_resetBar => RESETN,
                i_d => signalMUXOutput(i),
                i_enable => '1',
                i_clock => CLK,
                o_q => signalDFFOutput(i)
            );
    end generate;
    
    PARALLEL_OUT <= signalDFFOutput;
end;

