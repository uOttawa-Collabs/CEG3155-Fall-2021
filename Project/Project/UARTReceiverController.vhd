library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity UARTReceiverController is
    port (
        GReset: in std_logic;
        
        CLK: in std_logic;
        RxD: in std_logic;
        
        RDRF_LOAD: out std_logic;
        RDRF_WRITE: out std_logic;
        
        OE_LOAD: out std_logic;
        OE_WRITE: out std_logic;
        
        FE_LOAD: out std_logic;
        FE_WRITE: out std_logic;
        
        RSR_SHIFT: out std_logic;
        
        RDR_LOAD: out std_logic
    );
end;

architecture Structural of UARTReceiverController is
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

    signal CTR0_EN: std_logic;
    signal CTR0_LOAD: std_logic;
    signal CTR0_IN: std_logic_vector(3 downto 0);
    signal CTR0_EXPIRE: std_logic;
    
    signal CTR1_CLK: std_logic;
    signal CTR1_EN: std_logic;
    signal CTR1_LOAD: std_logic;
    signal CTR1_EXPIRE: std_logic;
    
    signal signalD: std_logic_vector(3 downto 0);
    signal signalQ: std_logic_vector(3 downto 0);
begin
    generateDFF: for i in 3 downto 0 generate
        dffInst: enARdFF_2
            port map (
                i_resetBar => GReset,
                i_d => signalD(i),
                i_enable => '1',
                i_clock => CLK,
                o_q => signalQ(i)
            );
    end generate;
    
    CTR0: Counter16D
        port map (
            CLK => CLK,
            RESETN => GReset,
            EN => CTR0_EN,
            LOAD => CTR0_LOAD,
            INPUT => CTR0_IN,
            EXPIRE => CTR0_EXPIRE
        );
    
    CTR1: Counter16D
        port map (
            CLK => CTR1_CLK,
            RESETN => GReset,
            EN => CTR1_EN,
            LOAD => CTR1_LOAD,
            INPUT => "1000",
            EXPIRE => CTR1_EXPIRE
        );
    
  
end;
