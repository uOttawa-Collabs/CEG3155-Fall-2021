library ieee;
use ieee.std_logic_1164.all;

entity SequenceComparator is
    port (
        w1, w0: in std_logic;
        CLK, RESETN: in std_logic;
        z: out std_logic
    );
end;

architecture Structural of SequenceComparator is
    component enARdFF_2 IS
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: OUT std_logic
        );
    end component;
    
    signal signalNotW: std_logic;
    signal signalS: std_logic_vector(2 downto 0);
begin
    signalNotW <= w1 xnor w0;
    
    s2DFF: enARdFF_2
        port map (
            i_resetBar => RESETN,
            i_d => (signalS(2) and signalNotW) or (signalS(1) and signalS(0) and signalNotW),
            i_enable => '1',
            i_clock => CLK,
            o_q => signalS(2)
        );
    
    s1DFF: enARdFF_2
        port map (
            i_resetBar => RESETN,
            i_d => ((not signalS(1)) and signalS(0) and signalNotW) or (signalS(1) and (not signalS(0)) and signalNotW),
            i_enable => '1',
            i_clock => CLK,
            o_q => signalS(1)
        );
    
    s0DFF: enARdFF_2
        port map (
            i_resetBar => RESETN,
            i_d => (not signalS(2)) and (not signalS(0)) and signalNotW,
            i_enable => '1',
            i_clock => CLK,
            o_q => signalS(0)
        );
    z <= signalS(2);
end;
