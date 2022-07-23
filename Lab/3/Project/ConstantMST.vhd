library ieee;
use ieee.std_logic_1164.all;

entity ConstantMST is
    port (
        MST: out std_logic_vector(3 downto 0)
    );
end;

architecture Structural of ConstantMST is
begin
    MST <= "0011";
end;
