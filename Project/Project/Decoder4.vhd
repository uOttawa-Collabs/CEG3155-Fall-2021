library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity Decoder4 is
    port (
        E: in std_logic;
        I: in std_logic_vector(1 downto 0);
        O: out std_logic_vector(3 downto 0)
    );
end;

architecture Structural of Decoder4 is
begin
    O <=
        "0000" when (E = '0') else
            "1000" when (E = '1' and I = "11") else
            "0100" when (E = '1' and I = "10") else
            "0010" when (E = '1' and I = "01") else
            "0001" when (E = '1' and I = "00");
end;
