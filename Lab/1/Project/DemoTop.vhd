library ieee;
use ieee.std_logic_1164.all;

entity DemoTop is
    port(
        CLK: in std_logic;
        LED: out std_logic_vector(7 downto 0);
        SEG_A: out std_logic;
        SEG_B: out std_logic;
        SEG_C: out std_logic;
        SEG_D: out std_logic;
        SEG_E: out std_logic;
        SEG_F: out std_logic;
        SEG_G: out std_logic
    );
end;

architecture RTL of DemoTop is
    component Project is
        port(
            GClock: in std_logic;
            GReset: in std_logic;
            Left: in std_logic;
            Right: in std_logic;
            LED: out std_logic_vector(7 downto 0)
        );
    end component;
    
    component dec_7seg is
        port(
            i_hexDigit: IN STD_LOGIC_VECTOR(3 downto 0);
            o_segment_a, o_segment_b, o_segment_c, o_segment_d, o_segment_e, 
            o_segment_f, o_segment_g: OUT STD_LOGIC
        );
    end component;
    
    component ClockConverter is
        port(
            CLK_IN: in std_logic;
            CLK_OUT: out std_logic
        );
    end component;
    
    -- Assume clock frequency is 20 Hz
    -- Each phase lasts for 2s
    constant COUNT_TOTAL: integer := 80;
    signal signalLeft: std_logic;
    signal signalRight: std_logic;
    signal signalPhase: std_logic_vector(3 downto 0);
    signal signalGClock: std_logic;

begin    
    main: Project
    port map(
        GClock => signalGClock,
        GReset => '1',
        Left => signalLeft,
        Right => signalRight,
        LED => LED
    );
    
    sevenSegmentDecoder: dec_7seg
    port map(
        i_hexDigit => signalPhase,
        o_segment_a => SEG_A,
        o_segment_b => SEG_B,
        o_segment_c => SEG_C,
        o_segment_d => SEG_D,
        o_segment_e => SEG_E,
        o_segment_f => SEG_F,
        o_segment_g => SEG_G
    );
    
    converter: ClockConverter
    port map(
        CLK_IN => CLK,
        CLK_OUT => signalGClock
    );
    
    process(signalGClock)
        variable phase: integer range 0 to 3;
        variable counter: integer range 0 to COUNT_TOTAL;
    begin
         if (rising_edge(signalGClock)) then
            if (counter = COUNT_TOTAL) then
                case phase is
                    when 0 =>
                        signalLeft <= '0';
                        signalRight <= '0';
                        signalPhase <= "0000";
                    when 1 =>
                        signalLeft <= '0';
                        signalRight <= '1';
                        signalPhase <= "0001";
                    when 2 =>
                        signalLeft <= '1';
                        signalRight <= '0';
                        signalPhase <= "0010";
                    when 3 =>
                        signalLeft <= '1';
                        signalRight <= '1';
                        signalPhase <= "0011";
                end case;
                
                if (phase = 3) then
                    phase := 0;
                else
                    phase := phase + 1;
                end if;
                
                counter := 0;
            else
                counter := counter + 1;
            end if;
        end if;
    end process;
end;
