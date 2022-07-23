library ieee;
library altera;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use altera.altera_primitives_components.all;

entity ClockDivider is
    generic (
        W: integer := 1;
        N: integer := 2
    );
    port (
        RESETN: in std_logic;
        CLK_IN: in std_logic;
        CLK_OUT: out std_logic
    );
end;


architecture RTL of ClockDivider is
    signal clock: std_logic;
begin
    process(CLK_IN, RESETN, clock)
        variable count: std_logic_vector(W - 1 downto 0);
    begin
        if RESETN = '0' then
            count := (others => '0');
            clock <= '0';
        elsif CLK_IN'event and CLK_IN = '1' then
            if count < N / 2 then
                clock <= '0';
            else
                clock <= '1';
            end if;
            
            count := count + 1;
            
            if count = N then
                count := (others => '0');
            end if;
        end if;
        
        CLK_OUT <= clock;
    end process;
end;
