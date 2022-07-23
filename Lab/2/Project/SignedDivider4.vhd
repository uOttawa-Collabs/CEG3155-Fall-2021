library ieee;
use ieee.std_logic_1164.all;

entity SignedDivider4 is
    port (
        X, Y: in std_logic_vector(3 downto 0);
        CLK, RESETN: in std_logic;
        Q, R: out std_logic_vector(3 downto 0);
        V, Z: out std_logic
    );
end;

architecture Structural of SignedDivider4 is
    component Divider4
        port (
            X, Y: in std_logic_vector(3 downto 0);
            CLK, RESETN: in std_logic;
            Q, R: out std_logic_vector(3 downto 0);
            V, Z: out std_logic
        );
    end component;
    
    component Complementer4
        port (
            INPUT: in std_logic_vector(3 downto 0);
            OUTPUT: out std_logic_vector(3 downto 0)
        );
    end component;
    
    signal signalX, signalY: std_logic_vector(3 downto 0);
    signal signalXC, signalYC: std_logic_vector(3 downto 0);
    signal signalQ, signalQC: std_logic_vector(3 downto 0);
begin
    divider4Inst: Divider4
        port map (
            X => signalX,
            Y => signalY,
            CLK => CLK,
            RESETN => RESETN,
            Q => signalQ,
            R => R,
            V => V,
            Z => Z
        );
    
    complementerX: Complementer4
        port map (
            INPUT => X,
            OUTPUT => signalXC
        );
        
    complementerY: Complementer4
        port map (
            INPUT => Y,
            OUTPUT => signalYC
        );
    
    complementerQ: Complementer4
        port map (
            INPUT => signalQ,
            OUTPUT => signalQC
        );
    
    signalX <=
        X when (X(3) = '0') else
        signalXC;
    
    signalY <=
        Y when (Y(3) = '0') else
        signalYC;
    
    Q <=
        signalQ when ((X(3) xor Y(3)) = '0') else
        signalQC;
end;
