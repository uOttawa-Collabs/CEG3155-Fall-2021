library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity Divider4Control is
    port (
        CLK: in std_logic;
        RESETN: in std_logic;
        REM_N: in std_logic;
        CNT_EQU: in std_logic;
        REM_RESETN: out std_logic;
        REM_SHL: out std_logic;
        REM_S_RIGHT: out std_logic;
        REM_LEFT_LOAD: out std_logic;
        REM_LEFT_SHR: out std_logic;
        REM_RIGHT_LOAD: out std_logic;
        CNT_CLK: out std_logic;
        CNT_RESETN: out std_logic;
        OUT_LOAD: out std_logic;
        ALU_SUB: out std_logic;
        D_ND_RESETN: out std_logic;
        D_ND_LOAD: out std_logic;
        D_OR_RESETN: out std_logic;
        D_OR_LOAD: out std_logic
    );
end;

architecture Structural of Divider4Control is
    component DFF
        port (
            D: in std_logic;
            CLK: in std_logic;
            CLRN: in std_logic;
            PRN: in std_logic;
            Q: out std_logic 
        );
    end component;
    
    signal signalSIn: std_logic_vector(0 to 9);
    signal signalS: std_logic_vector(0 to 9);
begin
    S0: DFF
        port map (
            D => signalSIn(0),
            CLK => CLK,
            CLRN => '1',
            PRN => RESETN,
            Q => signalS(0)
        );
    
    generateStateFF: for i in 1 to 9 generate
        S: DFF
            port map (
                D => signalSIn(i),
                CLK => CLK,
                CLRN => RESETN,
                PRN => '1',
                Q => signalS(i)
            );
    end generate;
    
    REM_RESETN <= signalS(1) or signalS(2) or signalS(3) or signalS(4) or signalS(5) or signalS(6) or signalS(7) or signalS(8) or signalS(9);
    REM_SHL <= signalS(2) or signalS(4) or signalS(9);
    REM_S_RIGHT <= signalS(4);
    REM_LEFT_LOAD <= signalS(3) or signalS(5);
    REM_LEFT_SHR <= signalS(7);
    REM_RIGHT_LOAD <= signalS(1);
    CNT_CLK <= signalS(6);
    CNT_RESETN <= signalS(3) or signalS(4) or signalS(5) or signalS(6) or signalS(9);
    OUT_LOAD <= signalS(8);
    ALU_SUB <= signalS(2) or signalS(3) or signalS(6);
    D_ND_RESETN <= signalS(0) or signalS(1) or signalS(2) or signalS(3) or signalS(4) or signalS(5) or signalS(6) or signalS(7) or signalS(9);
    D_ND_LOAD <= signalS(0);
    D_OR_RESETN <= signalS(0) or signalS(1) or signalS(2) or signalS(3) or signalS(4) or signalS(5) or signalS(6) or signalS(7) or signalS(9);
    D_OR_LOAD <= signalS(0);
    
    signalSIn(0) <= signalS(8);
    signalSIn(1) <= signalS(0);
    signalSIn(2) <= signalS(1);
    signalSIn(3) <= signalS(2) or (signalS(6) and (not CNT_EQU));
    signalSIn(4) <= signalS(3) and (not REM_N);
    signalSIn(5) <= signalS(3) and REM_N;
    signalSIn(9) <= signalS(5);
    signalSIn(6) <= signalS(4) or signalS(9);
    signalSIn(7) <= signalS(6) and CNT_EQU;
    signalSIn(8) <= signalS(7);
end;
