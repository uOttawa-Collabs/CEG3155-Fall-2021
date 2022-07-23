library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity Q2 is
    port (
        CLK: in std_logic;
        RESETN: in std_logic;
        R: in std_logic_vector(1 to 3);
        G: out std_logic_vector(1 to 3)
    );
end;


architecture Structural of Q2 is
    component DFF
        port (
            D: in std_logic;
            CLK: in std_logic;
            CLRN: in std_logic;
            PRN: in std_logic;
            Q: out std_logic
        );
    end component;
    
    signal signalD: std_logic_vector(1 downto 0);
    signal signalQ: std_logic_vector(1 downto 0);
begin
    generateDFF: for i in 1 downto 0 generate
        DFFInst: DFF
            port map (
                D => signalD(i),
                CLK => CLK,
                CLRN => RESETN,
                PRN => '1',
                Q => signalQ(i)
            );
    end generate;

    signalD(1) <=    -- (r1' + s1)r3 + ((s1 + r1)' + s1s0')r2
        ((not R(1) or signalQ(1)) and R(3))
        or (((signalQ(1) nor R(1)) or (signalQ(1) and not signalQ(0))) and R(2));
    
    signalD(0) <=    -- (r2' + s1s0)r3 + s1'r1
        ((not R(2) or (signalQ(1) and signalQ(0))) and R(3))
        or (not signalQ(1) and R(1));
    
    -- g1 = s1'r1
    G(1) <= not signalQ(1) and R(1);
    
    -- g2 = ((s1 + r1)' + s1s0')r2
    G(2) <=
        ((signalQ(1) nor R(1))
            or (signalQ(1) and not signalQ(0)))
        and R(2);
    
    -- g3 = ((r1 + r2)' + s1r2' + s1s0)r3
    G(3) <=
        ((R(1) nor R(2))
            or (signalQ(1) and not R(2))
            or (signalQ(1) and signalQ(0)))
        and R(3);
    
end;
