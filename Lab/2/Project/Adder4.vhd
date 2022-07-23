library ieee;
use ieee.std_logic_1164.all;

entity Adder4 is
    port (
        X, Y: in std_logic_vector(3 downto 0);
        Cin: in std_logic;
        S: out std_logic_vector(3 downto 0);
        Cout: out std_logic;
        P, G: out std_logic;
        V, Z: out std_logic
    );
end;

architecture Structural of Adder4 is
    component FullAdder
        port (
            X, Y: in std_logic;
            Cin: in std_logic;
            S: out std_logic;
            Cout: out std_logic;
            P, G: out std_logic
        );
    end component;
    
    component LookaheadCarryUnit
        port (
            P, G: in std_logic_vector(3 downto 0);
            Cin: in std_logic;
            PG, GG: out std_logic;
            C: out std_logic_vector(4 downto 0)
        );
    end component;
    
    signal signalFullAdderCarry: std_logic_vector(4 downto 0);
    signal signalFullAdderG, signalFullAdderP: std_logic_vector(3 downto 0);
    signal signalS: std_logic_vector(3 downto 0);
begin
    generateFullAdder:
        for i in 3 downto 0 generate
            fullAdderInst: FullAdder
                port map (
                    X => X(i),
                    Y => Y(i),
                    Cin => signalFullAdderCarry(i),
                    S => signalS(i),
                    P => signalFullAdderP(i),
                    G => signalFullAdderG(i)
                );
        end generate;
    
    lookaheadCarryUnitInst: LookaheadCarryUnit
        port map (
            P => signalFullAdderP,
            G => signalFullAdderG,
            Cin => Cin,
            C => signalFullAdderCarry,
            PG => P,
            GG => G
        );
    
    S <= signalS;
    Cout <= signalFullAdderCarry(4);
    V <= signalFullAdderCarry(4) xor signalFullAdderCarry(3);
    Z <= not (signalS(3) or signalS(2) or signalS(1) or signalS(0));
end;
