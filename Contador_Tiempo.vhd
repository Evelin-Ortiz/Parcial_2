library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Contador_Tiempo is
    Port ( clk, reset, enable : in STD_LOGIC;
           pagos : out integer
           );
end Contador_Tiempo;

architecture Behavioral of Contador_Tiempo is
    signal count_reg : integer range 0 to 9;
   
begin
    process (clk, reset)
    begin
        if reset = '0' then
            count_reg <= 0;
            
        elsif rising_edge(clk) then
            if enable = '1' then
                count_reg <= count_reg + 1;
                if count_reg = 9 then
                    count_reg <= 0;
                    
                end if;
            end if;
        end if;
    end process;
    
    pagos <= count_reg;
    
end architecture;