LIBRARY ieee;
USE ieee.std_logic_1164.all;
--------------------------------------------------------
ENTITY freq_divider IS
    PORT (  Clock : IN STD_LOGIC;
            Salida1, Salida2 : BUFFER STD_LOGIC);
END freq_divider;
--------------------------------------------------------
ARCHITECTURE example OF freq_divider IS  
        SIGNAL Contador1: INTEGER RANGE 0 TO 50000000;

    BEGIN
        PROCESS (Clock)
VARIABLE Contador2: INTEGER RANGE 0 TO 50000000;
        BEGIN
            IF (Clock' EVENT AND Clock='1') THEN
                Contador1 <= Contador1 + 1;
                Contador2 := Contador2 + 1;

                IF (Contador1 = 24999999 ) THEN
                    Salida1 <= NOT Salida1;
                    Contador1 <= 1;
                END IF;

                IF (Contador2 = 25000000 ) THEN
                    Salida2 <= NOT Salida2;
                    Contador2 := 1;
                END IF;
            END IF;
        END PROCESS;
END example;