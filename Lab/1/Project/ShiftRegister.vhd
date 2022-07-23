library ieee;
use ieee.std_logic_1164.all;

entity ShiftRegister is
    port(
        LOAD, RESETN: in std_logic;
        SHL, SHR: in std_logic;
        CLK: in std_logic;
        INPUT: in std_logic_vector(7 downto 0);
        OUTPUT: out std_logic_vector(7 downto 0)
    );
end ShiftRegister;

architecture Structural OF ShiftRegister is
    signal signalDFF: std_logic_vector(7 downto 0);
    signal signalMUX: std_logic_vector(7 downto 0);
    component ENDFFPET
        port(
            SETN: in std_logic;
            RESETN: in std_logic;
            D: in std_logic;
            EN: in std_logic;
            CLK: in std_logic;
            Q: out std_logic
        );
    end component;
    component MUX4x1
        port(
            INPUT: in std_logic_vector(3 downto 0);
            OUTPUT: out std_logic;
            C: in std_logic_vector(1 downto 0)
        );
    end component;
begin
    MUX7: MUX4x1
    port map(
        INPUT(0) => INPUT(7),
        INPUT(1) => signalDFF(0),
        INPUT(2) => signalDFF(6),
        INPUT(3) => INPUT(7),
        OUTPUT => signalMUX(7),
        C(1) => SHL,
        C(0) => SHR
    );

    MUX6: MUX4x1
    port map(
        INPUT(0) => INPUT(6),
        INPUT(1) => signalDFF(7),
        INPUT(2) => signalDFF(5),
        INPUT(3) => INPUT(6),
        OUTPUT => signalMUX(6),
        C(1) => SHL,
        C(0) => SHR
    );

    MUX5: MUX4x1
    port map(
        INPUT(0) => INPUT(5),
        INPUT(1) => signalDFF(6),
        INPUT(2) => signalDFF(4),
        INPUT(3) => INPUT(5),
        OUTPUT => signalMUX(5),
        C(1) => SHL,
        C(0) => SHR
    );

    MUX4: MUX4x1
    port map(
        INPUT(0) => INPUT(4),
        INPUT(1) => signalDFF(5),
        INPUT(2) => signalDFF(3),
        INPUT(3) => INPUT(4),
        OUTPUT => signalMUX(4),
        C(1) => SHL,
        C(0) => SHR
    );

    MUX3: MUX4x1
    port map(
        INPUT(0) => INPUT(3),
        INPUT(1) => signalDFF(4),
        INPUT(2) => signalDFF(2),
        INPUT(3) => INPUT(3),
        OUTPUT => signalMUX(3),
        C(1) => SHL,
        C(0) => SHR
    );

    MUX2: MUX4x1
    port map(
        INPUT(0) => INPUT(2),
        INPUT(1) => signalDFF(3),
        INPUT(2) => signalDFF(1),
        INPUT(3) => INPUT(2),
        OUTPUT => signalMUX(2),
        C(1) => SHL,
        C(0) => SHR
    );

    MUX1: MUX4x1
    port map(
        INPUT(0) => INPUT(1),
        INPUT(1) => signalDFF(2),
        INPUT(2) => signalDFF(0),
        INPUT(3) => INPUT(1),
        OUTPUT => signalMUX(1),
        C(1) => SHL,
        C(0) => SHR
    );

    MUX0: MUX4x1
    port map(
        INPUT(0) => INPUT(0),
        INPUT(1) => signalDFF(1),
        INPUT(2) => signalDFF(7),
        INPUT(3) => INPUT(0),
        OUTPUT => signalMUX(0),
        C(1) => SHL,
        C(0) => SHR
    );
    
    DFF7: ENDFFPET
    port map(
        SETN => '1',
        RESETN => RESETN,
        D => signalMUX(7),
        EN => LOAD,
        Q => signalDFF(7),
        CLK => CLK
    );

    DFF6: ENDFFPET
    port map(
        SETN => '1',
        RESETN => RESETN,
        D => signalMUX(6),
        EN => LOAD,
        Q => signalDFF(6),
        CLK => CLK
    );

    DFF5: ENDFFPET
    port map(
        SETN => '1',
        RESETN => RESETN,
        D => signalMUX(5),
        EN => LOAD,
        Q => signalDFF(5),
        CLK => CLK
    );

    DFF4: ENDFFPET
    port map(
        SETN => '1',
        RESETN => RESETN,
        D => signalMUX(4),
        EN => LOAD,
        Q => signalDFF(4),
        CLK => CLK
    );

    DFF3: ENDFFPET
    port map(
        SETN => '1',
        RESETN => RESETN,
        D => signalMUX(3),
        EN => LOAD,
        Q => signalDFF(3),
        CLK => CLK
    );

    DFF2: ENDFFPET
    port map(
        SETN => '1',
        RESETN => RESETN,
        D => signalMUX(2),
        EN => LOAD,
        Q => signalDFF(2),
        CLK => CLK
    );

    DFF1: ENDFFPET
    port map(
        SETN => '1',
        RESETN => RESETN,
        D => signalMUX(1),
        EN => LOAD,
        Q => signalDFF(1),
        CLK => CLK
    );

    DFF0: ENDFFPET
    port map(
        SETN => '1',
        RESETN => RESETN,
        D => signalMUX(0),
        EN => LOAD,
        Q => signalDFF(0),
        CLK => CLK
    );
    OUTPUT <= signalDFF;
end;
