library ieee;
use ieee.std_logic_1164.all;

entity OR8bit2x1 is
    port(
        A, B: in std_logic_vector(7 downto 0);
        C: out std_logic_vector(7 downto 0)
    );
end;

architecture Structural of OR8bit2x1 is
begin
    C <= A or B;
end;
