library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister8 is
    port (
        CLK, RESETN: in std_logic;
        MODE: in std_logic_vector(1 downto 0);
        SERIAL_IN_LEFT, SERIAL_IN_RIGHT: in std_logic;
        PARALLEL_IN: in std_logic_vector(7 downto 0);
        PARALLEL_OUT: out std_logic_vector(7 downto 0)
    );
    -- MODE: 00 for latching, 01 for parallel loading, 10 for shifting left, 11 for shifting right
end;

architecture Structural of ShiftRegister8 is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    
    component MUX4 is
        generic (
            T: integer := 1
        );
        port (
            I3, I2, I1, I0: in std_logic_vector(T downto 0);
            O: out std_logic_vector(T downto 0);
            C: in std_logic_vector(1 downto 0)
        );
    end component;
    
    signal signalDFFOutput: std_logic_vector(7 downto 0);
    signal signalMUXOutput: std_logic_vector(7 downto 0);
    signal signalMUXInputLeftShift: std_logic_vector(7 downto 0);
    signal signalMUXInputRightShift: std_logic_vector(7 downto 0);
begin
    signalMUXInputLeftShift(0) <= SERIAL_IN_RIGHT;
    signalMUXInputLeftShift(7 downto 1) <= signalDFFOutput(6 downto 0);
    signalMUXInputRightShift(7) <= SERIAL_IN_LEFT;
    signalMUXInputRightShift(6 downto 0) <= signalDFFOutput(7 downto 1);
    
    generateMUX: for i in 7 downto 0 generate
        MUX4Inst: MUX4
            generic map (
                T => 0
            )
            port map (
                I3(0) => signalMUXInputRightShift(i),
                I2(0) => signalMUXInputLeftShift(i),
                I1(0) => PARALLEL_IN(i),
                I0(0) => signalDFFOutput(i),
                O(0) => signalMUXOutput(i),
                C => MODE
            );
    end generate;
    
    generateDFF: for i in 7 downto 0 generate
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

