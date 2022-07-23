library ieee;
use ieee.std_logic_1164.all;

entity FullAdder is
    port (
        X, Y: in std_logic;
        Cin: in std_logic;
        S: out std_logic;
        Cout: out std_logic;
        P, G: out std_logic
    );
end FullAdder;

architecture Structural of FullAdder is
begin
    S <= X xor Y xor Cin;
    Cout <= (X and Y) or (Cin and X) or (Cin and Y);
    P <= X or Y;
    G <= X and Y;
end;
