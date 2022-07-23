library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity UARTTransmitterController is
    port (
        GReset: in std_logic;
        
        CLK: in std_logic;
        SEND: in std_logic;
        
        TDRE_LOAD: out std_logic;
        TDRE_WRITE: out std_logic;
        
        TDR_LOAD: out std_logic;
        
        TSR_LOAD: out std_logic;
        TSR_SHIFT: out std_logic;
        
        TxDFF_SET: out std_logic; 
        TxDFF_LOAD: out std_logic
    );
end;

architecture Structural of UARTTransmitterController is
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
    
    signal CTR_LOAD: std_logic;
    signal CTR_EN: std_logic;
    signal CTR_EXPIRE: std_logic;
    
    signal signalD: std_logic_vector(1 downto 0);
    signal signalQ: std_logic_vector(1 downto 0);
begin
    generateDFF: for i in 1 downto 0 generate
        dffInst: enARdFF_2
            port map (
                i_resetBar => GReset,
                i_d => signalD(i),
                i_enable => '1',
                i_clock => CLK,
                o_q => signalQ(i)
            );
    end generate;
    
    CTR: Counter16D
        port map (
            CLK => CLK,
            RESETN => GReset,
            EN => CTR_EN,
            LOAD => CTR_LOAD,
            INPUT => "1000",
            EXPIRE => CTR_EXPIRE
        );
end;
