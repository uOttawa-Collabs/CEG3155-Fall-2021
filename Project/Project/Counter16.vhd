library ieee;
use ieee.std_logic_1164.all;

entity Counter16 is
    port (
        CLK, RESETN, EN: in std_logic;
        VALUE: out std_logic_vector(3 downto 0)
    );
end;

architecture Structural of Counter16 is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    
    signal signalValue: std_logic_vector(3 downto 0);
    signal signalD: std_logic_vector(3 downto 0);
begin
    signalD(3) <= signalValue(3) xor (signalValue(2) and signalValue(1) and signalValue(0));
    signalD(2) <= signalValue(2) xor (signalValue(1) and signalValue(0));
    signalD(1) <= signalValue(1) xor signalValue(0);
    signalD(0) <= not signalValue(0);

    generateDFF: for i in 3 downto 0 generate
        dffInst: enARdFF_2
            port map (
                i_resetBar => RESETN,
                i_d => signalD(i),
                i_enable => EN,
                i_clock => CLK,
                o_q => signalValue(i)
            );
    end generate;
    
    VALUE <= signalValue;
end;
