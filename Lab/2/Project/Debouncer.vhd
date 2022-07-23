library ieee;
use ieee.std_logic_1164.all;

entity Debouncer is
    generic (
        T: integer := 0
    );
    port (
        RESETN: in std_logic;
        CLK: in std_logic;
        RAW: in std_logic_vector(T downto 0);
        CLEAN: out std_logic_vector(T downto 0)
    );
end;

architecture Structural of Debouncer is
    component debouncer_2 is
        port (
            i_resetBar: in std_logic;
            i_clock: in std_logic;
            i_raw: in std_logic;
            o_clean: out std_logic
        );
    end component;
begin
    generateDebouncer:
        for i in T downto 0 generate
            debouncerInst: debouncer_2
                port map(
                    i_resetBar => RESETN,
                    i_clock => CLK,
                    i_raw => RAW(i),
                    o_clean => CLEAN(i)
                );
        end generate;
end;
