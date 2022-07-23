library ieee;
use ieee.std_logic_1164.all;

entity ClockConverter is
    port(
        CLK_IN: in std_logic;
        CLK_OUT: out std_logic
    );
end;

architecture RTL of ClockConverter is
    signal output: std_logic;
    
    -- The frequence of CLK_IN is divided by RATIO.
    -- e.g. If the input clock is of frequency 50 MHz, then the output clock will be 20 Hz.
    constant RATIO: integer := 250000;
begin
    process(CLK_IN)
        variable counter: integer range 0 to RATIO;
    begin
        if (rising_edge(CLK_IN)) then
            if (counter = RATIO) then
                output <= not output;
                counter := 0;
            else
                counter := counter + 1;
            end if;
        end if;
    end process;
    CLK_OUT <= output;
end;
