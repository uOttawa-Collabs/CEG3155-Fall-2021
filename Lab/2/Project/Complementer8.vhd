library ieee;
use ieee.std_logic_1164.all;

entity Complementer8 is
    port (
        INPUT: in std_logic_vector(7 downto 0);
        OUTPUT: out std_logic_vector(7 downto 0)
    );
end;

architecture Structural of Complementer8 is
begin
    OUTPUT(7) <= INPUT(7) xor (INPUT(6) or INPUT(5) or INPUT(4) or INPUT(3) or INPUT(2) or INPUT(1) or INPUT(0));
    OUTPUT(6) <= INPUT(6) xor (INPUT(5) or INPUT(4) or INPUT(3) or INPUT(2) or INPUT(1) or INPUT(0));
    OUTPUT(5) <= INPUT(5) xor (INPUT(4) or INPUT(3) or INPUT(2) or INPUT(1) or INPUT(0));
    OUTPUT(4) <= INPUT(4) xor (INPUT(3) or INPUT(2) or INPUT(1) or INPUT(0));
    OUTPUT(3) <= INPUT(3) xor (INPUT(2) or INPUT(1) or INPUT(0));
    OUTPUT(2) <= INPUT(2) xor (INPUT(1) or INPUT(0));
    OUTPUT(1) <= INPUT(1) xor INPUT(0);
    OUTPUT(0) <= INPUT(0);
end;
