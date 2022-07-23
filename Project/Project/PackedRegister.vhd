library ieee;
use ieee.std_logic_1164.all;

entity PackedRegister is
    generic (
        T: integer := 7
    );
    port (
        CLK, RESETN: in std_logic;
        LOAD: in std_logic_vector(T downto 0);
        LOAD_ALL: in std_logic;
        PARALLEL_IN: in std_logic_vector(T downto 0);
        PARALLEL_OUT: out std_logic_vector(T downto 0)
    );
    -- Every bit can be loaded without affecting other bits
end;

architecture Structural of PackedRegister is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
begin
    generateDFF: for i in T downto 0 generate
        DFFInst: enARdFF_2
            port map (
                i_resetBar => RESETN,
                i_d => PARALLEL_IN(i),
                i_enable => LOAD(i) or LOAD_ALL,
                i_clock => CLK,
                o_q => PARALLEL_OUT(i)
            );
    end generate;
end;

