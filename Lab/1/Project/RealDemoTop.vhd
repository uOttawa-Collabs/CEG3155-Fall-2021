library ieee;
use ieee.std_logic_1164.all;

entity RealDemoTop is
    port(
        GClock: in std_logic;
        GReset: in std_logic;
        Left: in std_logic;
        Right: in std_logic;
        LED: out std_logic_vector(7 downto 0)
    );
end;

architecture RTL of RealDemoTop is
    component Project is
        port(
            GClock: in std_logic;
            GReset: in std_logic;
            Left: in std_logic;
            Right: in std_logic;
            LED: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component ClockConverter is
        port(
            CLK_IN: in std_logic;
            CLK_OUT: out std_logic
        );
    end component;
    
    signal signalGClock: std_logic;
    
begin    
    main: Project
    port map(
        GClock => signalGClock,
        GReset => GReset,
        Left => Left,
        Right => Right,
        LED => LED
    );
    
    converter: ClockConverter
    port map(
        CLK_IN => GClock,
        CLK_OUT => signalGClock
    );
end;
