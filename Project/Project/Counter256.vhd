library ieee;
use ieee.std_logic_1164.all;

entity Counter256 is
    port (
        CLK, RESETN, EN: in std_logic;
        VALUE: out std_logic_vector(7 downto 0)
    );
end;

architecture Structural of Counter256 is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    
    signal signalValue: std_logic_vector(7 downto 0);
    signal signalD: std_logic_vector(7 downto 0);
begin
    signalD(7) <= signalValue(7) xor (signalValue(6) and signalValue(5) and signalValue(4) and signalValue(3) and signalValue(2) and signalValue(1) and signalValue(0));
    signalD(6) <= signalValue(6) xor (signalValue(5) and signalValue(4) and signalValue(3) and signalValue(2) and signalValue(1) and signalValue(0));
    signalD(5) <= signalValue(5) xor (signalValue(4) and signalValue(3) and signalValue(2) and signalValue(1) and signalValue(0));
    signalD(4) <= signalValue(4) xor (signalValue(3) and signalValue(2) and signalValue(1) and signalValue(0));
    signalD(3) <= signalValue(3) xor (signalValue(2) and signalValue(1) and signalValue(0));
    signalD(2) <= signalValue(2) xor (signalValue(1) and signalValue(0));
    signalD(1) <= signalValue(1) xor signalValue(0);
    signalD(0) <= not signalValue(0);

    generateDFF: for i in 7 downto 0 generate
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
