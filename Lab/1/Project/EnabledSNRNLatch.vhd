library ieee;
use ieee.std_logic_1164.all;

entity EnabledSNRNLatch is
    port(
        SN, RN, SEN, REN: in std_logic;
        Q, QN: out std_logic
    );
end;

architecture Structural of EnabledSNRNLatch is
    signal signalQ: std_logic := '0';
    signal signalQN: std_logic := '1';
begin
    -- Concurrent Signal Assignment
    signalQ <= ((SN and SEN) nand signalQN);
    signalQN <= ((RN and REN) nand signalQ);
    
    -- Output Driver
    Q <= signalQ;
    QN <= signalQN;
end;
