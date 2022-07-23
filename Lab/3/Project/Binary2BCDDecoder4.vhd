library ieee;
use ieee.std_logic_1164.all;

entity Binary2BCDDecoder4 is
    port (
        BIN: in std_logic_vector(3 downto 0);
        BCD1, BCD0: out std_logic_vector(3 downto 0)
    );
end entity;

architecture Structural of Binary2BCDDecoder4 is
begin
    BCD1(3 downto 1) <= "000";
    BCD1(0) <= (BIN(3) and BIN(1)) or (BIN(3) and BIN(2));
    
    BCD0(3) <= BIN(3) and not BIN(2) and not BIN(1);
    BCD0(2) <= BIN(2) and (not BIN(3) or BIN(1));
    BCD0(1) <= (not BIN(3) and BIN(1)) or (BIN(3) and BIN(2) and not BIN(1));
    BCD0(0) <= BIN(0);
end;
