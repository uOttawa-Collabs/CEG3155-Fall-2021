library ieee;
use ieee.std_logic_1164.all;

entity ENDFFPET is
    port(
        SETN, RESETN, CLK, D, EN: in std_logic;
        Q: out std_logic
    );
end;

architecture RTL of ENDFFPET is
begin
    process(CLK, RESETN, SETN)
    begin
        if (RESETN = '0') then
            Q <= '0';
        elsif (SETN = '0') then
            Q <= '1';
        elsif (EN = '1' and rising_edge(CLK)) then
            Q <= D;
        end if;
    end process;
end;
