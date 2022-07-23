library ieee;
use ieee.std_logic_1164.all;

entity MUX4x1 is
    port(
        INPUT: in std_logic_vector(3 downto 0);
        OUTPUT: out std_logic;
        C: in std_logic_vector(1 downto 0)
    );
end;

architecture Structural of MUX4x1 is
begin
    OUTPUT <=
        INPUT(3) when (C = "11") else
        INPUT(2) when (C = "10") else
        INPUT(1) when (C = "01") else
        INPUT(0);
end;
