library ieee;
use ieee.std_logic_1164.all;

entity DFFPET is
    port(
        SETN, RESETN, CLK, D: in std_logic;
        Q, QN: out std_logic
    );
end;

architecture Structural of DFFPET is
    signal signalSetLatchQN: std_logic;
    signal signalResetLatchQ: std_logic;
    signal signalResetLatchQN: std_logic;
    
    component EnabledSNRNLatch
        PORT(
            SN, RN, SEN, REN: in std_logic;
            Q, QN: out std_logic
        );
    end component;

begin
    -- Component Instantiation
    setLatch: EnabledSNRNLatch
    port map(
        SN => SETN,
        RN => RESETN,
        SEN => signalResetLatchQN,
        REN => CLK,
        QN => signalSetLatchQN
    );
    
    resetLatch: EnabledSNRNLatch
    port map(
        SN => signalSetLatchQN,
        RN => RESETN,
        SEN => CLK,
        REN => D,
        Q => signalResetLatchQ,
        QN => signalResetLatchQN
    );
    
    dataLatch: EnabledSNRNLatch
    port map(
        SN => SETN,
        RN => RESETN,
        SEN => signalSetLatchQN,
        REN => signalResetLatchQ,
        Q => Q,
        QN => QN
    );
end;
