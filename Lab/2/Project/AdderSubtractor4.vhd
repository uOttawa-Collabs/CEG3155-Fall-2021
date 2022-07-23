library ieee;
use ieee.std_logic_1164.all;

entity AdderSubtractor4 is
    port (
        X, Y: in std_logic_vector(3 downto 0);
        SUB: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Cout: out std_logic;
        V, Z: out std_logic
    );
end;

architecture Structural of AdderSubtractor4 is
    component Adder4
        port (
            X, Y: in std_logic_vector(3 downto 0);
            Cin: in std_logic;
            S: out std_logic_vector(3 downto 0);
            Cout: out std_logic;
            P, G: out std_logic;
            V, Z: out std_logic
        );
    end component;
    
    signal signalY: std_logic_vector(3 downto 0);
begin
    generateSignalY:
        for i in 3 downto 0 generate
            signalY(i) <= Y(i) xor SUB;
        end generate;
    
    adder4Inst: Adder4
        port map (
            X => X,
            Y => signalY,
            Cin => SUB,
            S => S,
            Cout => Cout,
            V => V,
            Z => Z
        );
end;
