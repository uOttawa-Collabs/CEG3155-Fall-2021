library ieee;
use ieee.std_logic_1164.all;

entity MUX4 is
    generic (
        T: integer := 1
    );
    port (
        I3, I2, I1, I0: in std_logic_vector(T downto 0);
        O: out std_logic_vector(T downto 0);
        C: in std_logic_vector(1 downto 0)
    );
end;

architecture Structural of MUX4 is
begin
    O <=
        I3 when (C = "11") else
        I2 when (C = "10") else
        I1 when (C = "01") else
        I0;
end;
