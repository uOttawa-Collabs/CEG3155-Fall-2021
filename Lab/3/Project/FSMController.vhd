library ieee;
library altera;
use ieee.std_logic_1164.all;
use altera.altera_primitives_components.all;

entity FSMController is
    port (
        CLK: in std_logic;
        RESETN: in std_logic;
        
        -- Car sensor interface
        SSCS: in std_logic;                         -- Side Street Car Sensor
        
        -- Counter interface
        SLCT: out std_logic_vector(1 downto 0);     -- Select Counter Load
                                                    -- 00: MSC
                                                    -- 01: MST
                                                    -- 10: SSC
                                                    -- 11: SST
        
        ENCT: out std_logic;                        -- Enable Counter
        LDCT: out std_logic;                        -- Load Counter
        CTEP: in std_logic;                         -- Counter Expire
        
        -- Light interface
        MSTL: out std_logic_vector(2 downto 0);     -- Main Street Traffic Lights
        SSTL: out std_logic_vector(2 downto 0)      -- Side Street Traffic Lights
    );
end;

architecture Structural of FSMController is
    component enARdFF_2 is
        port (
            i_resetBar: in std_logic;
            i_d: in std_logic;
            i_enable: in std_logic;
            i_clock: in std_logic;
            o_q, o_qBar: out std_logic
        );
    end component;

    signal signalD, signalQ: std_logic_vector(3 downto 0);
begin
    generateDFF: for i in 3 downto 0 generate
        dffInst: enARdFF_2
            port map (
                i_resetBar => RESETN,
                i_d => signalD(i),
                i_enable => '1',
                i_clock => CLK,
                o_q => signalQ(i)
            );
    end generate;
    
    -- State Trainsition
    signalD(3) <= (signalQ(3) and (signalQ(0) nand CTEP)) or (signalQ(2) and signalQ(1) and signalQ(0) and CTEP);
    signalD(2) <= signalQ(2) xor (signalQ(1) and signalQ(0) and CTEP);
    signalD(1) <= (signalQ(1) and (signalQ(0) nand CTEP)) or (not signalQ(1) and signalQ(0) and CTEP and (SSCS or signalQ(2)));
    signalD(0) <= signalQ(0) nand CTEP;
    
    -- Output Generation
    MSTL(2) <= signalQ(2);
    MSTL(1) <= not signalQ(2) and signalQ(1);
    MSTL(0) <= signalQ(2) nor signalQ(1);
    
    SSTL(2) <= not signalQ(2);
    SSTL(1) <= signalQ(2) and signalQ(1);
    SSTL(0) <= signalQ(2) and not signalQ(1);
    
    SLCT(1) <= signalQ(2);
    SLCT(0) <= signalQ(3) or signalQ(1);
    
    LDCT <= not signalQ(0);
    ENCT <= signalQ(0);
end;
