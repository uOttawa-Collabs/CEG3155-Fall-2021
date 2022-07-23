library ieee;
use ieee.std_logic_1164.all;

entity MUX8 is
    generic (
        T: integer := 1
    );
    port (
        I7, I6, I5, I4, I3, I2, I1, I0: in std_logic_vector(T downto 0);
        O: out std_logic_vector(T downto 0);
        C: in std_logic_vector(2 downto 0)
    );
end;

architecture Structural of MUX8 is
begin
    O <=
        I7 when (C = "111") else
        I6 when (C = "110") else
        I5 when (C = "101") else
        I4 when (C = "100") else
        I3 when (C = "011") else
        I2 when (C = "010") else
        I1 when (C = "001") else
        I0;
end;
