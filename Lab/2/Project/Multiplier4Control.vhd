library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity Multiplier4Control is
    port (
        CLK: in std_logic;
        RESETN: in std_logic;
        PRD_0_Z: in std_logic;
        CNT_EQU_4: in std_logic;
        PRD_RESETN: out std_logic;
        PRD_SHIFT_RIGHT: out std_logic;
        PRD_LEFT_LOAD: out std_logic;
        PRD_RIGHT_LOAD: out std_logic;
        CNT_CLK: out std_logic;
        CNT_RESETN: out std_logic;
        OUT_LOAD: out std_logic;
        M_AND_RESETN: out std_logic;
        M_AND_LOAD: out std_logic;
        M_ER_RESETN: out std_logic;
        M_ER_LOAD: out std_logic
    );
end;

architecture Structural of Multiplier4Control is
    component DFF
        port (
            D: in std_logic;
            CLK: in std_logic;
            CLRN: in std_logic;
            PRN: in std_logic;
            Q: out std_logic 
        );
    end component;
    
    signal signalSIn: std_logic_vector(0 to 5);
    signal signalS: std_logic_vector(0 to 5);
    signal signalC0: std_logic;
    signal signalC1Out: std_logic;
begin
    S0: DFF
        port map (
            D => signalSIn(0),
            CLK => CLK,
            CLRN => '1',
            PRN => RESETN,
            Q => signalS(0)
        );
    
    generateStateFF: for i in 1 to 5 generate
        S: DFF
            port map (
                D => signalSIn(i),
                CLK => CLK,
                CLRN => RESETN,
                PRN => '1',
                Q => signalS(i)
            );
    end generate;
    
    PRD_RESETN <= signalS(1) or signalS(2) or signalS(3) or signalS(4) or signalS(5);
    PRD_LEFT_LOAD <= signalS(2);
    PRD_RIGHT_LOAD <= signalS(1);
    PRD_SHIFT_RIGHT <= signalS(4);
    CNT_RESETN <= signalS(2) or signalS(3) or signalS(4);
    CNT_CLK <= signalS(4);
    OUT_LOAD <= signalS(5);
    M_AND_RESETN <= signalS(0) or signalS(1) or signalS(2) or signalS(3) or signalS(4);
    M_AND_LOAD <= signalS(0);
    M_ER_RESETN <= signalS(0) or signalS(1) or signalS(2) or signalS(3) or signalS(4);
    M_ER_LOAD <= signalS(0);
    
    signalSIn(0) <= signalS(5);
    signalSIn(1) <= signalS(0);
    signalC0 <= signalS(1) or signalC1Out;
    signalSIn(2) <= signalC0 and (not PRD_0_Z);
    signalSIn(3) <= signalC0 and PRD_0_Z;
    signalSIn(4) <= signalS(2) or signalS(3);
    signalSIn(5) <= signalS(4) and CNT_EQU_4;
    signalC1Out <= signalS(4) and (not CNT_EQU_4);
end;
