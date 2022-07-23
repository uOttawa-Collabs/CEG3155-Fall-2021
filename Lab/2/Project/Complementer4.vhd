library ieee;
use ieee.std_logic_1164.all;

entity Complementer4 is
    port (
        INPUT: in std_logic_vector(3 downto 0);
        OUTPUT: out std_logic_vector(3 downto 0)
    );
end;

architecture Structural of Complementer4 is
begin
    OUTPUT(3) <= INPUT(3) xor (INPUT(2) or INPUT(1) or INPUT(0));
    OUTPUT(2) <= INPUT(2) xor (INPUT(1) or INPUT(0));
    OUTPUT(1) <= INPUT(1) xor INPUT(0);
    OUTPUT(0) <= INPUT(0);
end;
