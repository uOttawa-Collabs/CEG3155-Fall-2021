library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity UARTFSM is
    port (
        GClock: in std_logic;
        GReset: in std_logic;
        
        StateInformation: in std_logic_vector(3 downto 0);
        
        UARTReceiverReset: out std_logic;
        Address: out std_logic_vector(1 downto 0);
        Read1Write0: out std_logic;
        DataRx: in std_logic_vector(7 downto 0);
        DataTx: out std_logic_vector(7 downto 0);
        IRQ: in std_logic_vector(1 downto 0)
    );
end;

architecture Structural of UARTFSM is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;
    
    component Counter16D is
        port (
            CLK, RESETN: in std_logic;
            EN, LOAD: in std_logic;
            INPUT: in std_logic_vector(3 downto 0);
            EXPIRE: out std_logic;
            VALUE: out std_logic_vector(3 downto 0)
        );
    end component;
begin
end;
