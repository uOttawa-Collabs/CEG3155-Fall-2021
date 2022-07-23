library ieee;
use ieee.std_logic_1164.all;

entity SignedMultiplier4 is
    port (
        X, Y: in std_logic_vector(3 downto 0);
        CLK, RESETN: in std_logic;
        P: out std_logic_vector(7 downto 0);
        V, Z: out std_logic
    );
end;

architecture Structural of SignedMultiplier4 is
    component Multiplier4
        port (
            X, Y: in std_logic_vector(3 downto 0);
            CLK, RESETN: in std_logic;
            P: out std_logic_vector(7 downto 0);
            V, Z: out std_logic
        );
    end component;
    
    component Complementer4
        port (
            INPUT: in std_logic_vector(3 downto 0);
            OUTPUT: out std_logic_vector(3 downto 0)
        );
    end component;
    
    component Complementer8
        port (
            INPUT: in std_logic_vector(7 downto 0);
            OUTPUT: out std_logic_vector(7 downto 0)
        );
    end component;
    
    signal signalX, signalY: std_logic_vector(3 downto 0);
    signal signalXC, signalYC: std_logic_vector(3 downto 0);
    signal signalP, signalPC: std_logic_vector(7 downto 0);
begin
    multiplier4Inst: Multiplier4
        port map (
            X => signalX,
            Y => signalY,
            CLK => CLK,
            RESETN => RESETN,
            P => signalP,
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
    
    complementerP: Complementer8
        port map (
            INPUT => signalP,
            OUTPUT => signalPC
        );
    
    signalX <=
        X when (X(3) = '0') else
        signalXC;
    
    signalY <=
        Y when (Y(3) = '0') else
        signalYC;
    
    P <=
        signalP when ((X(3) xor Y(3)) = '0') else
        signalPC;
end;
