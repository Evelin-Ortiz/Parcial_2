library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Contador_Tiempo is
    Port ( Clock, reset, enable, Load : in STD_LOGIC;
        Pagos         : out integer);
end Contador_Tiempo;

architecture arch_Contador of Contador_Tiempo is

    signal Conteo_reg1 : integer range 0 to 49;
    
begin

    process (Clock, reset)

    variable data_in : STD_LOGIC_VECTOR (5 downto 0);

    begin

            if reset = '0' then
                Conteo_reg1 <= 0;
                    
                elsif (rising_edge(Clock)) then
                
                    if enable = '1' then
                        
                            if Load = '1' then
                                
                                Conteo_reg1 <= to_integer(unsigned(data_in));
                                
                                    if (Conteo_reg1 = 49) then
                                        Conteo_reg1 <= 0;
                                        else
                                            Conteo_reg1 <= Conteo_reg1 + 1;
                                    end if;
                            end if;
                    end if;
                        
                    if enable = '1' then
                        
                        if Load = '0' then
                                
                            Conteo_reg1 <= to_integer(unsigned(data_in));
                        end if;
                    end if;	
                            
                    if enable = '0' then
                        
                        if Load = '0' then
                                
                            Conteo_reg1 <= to_integer(unsigned(data_in));
                        end if;
                    end if;
            end if;
            
            if (Conteo_reg1 mod 5) = 0 then
                Pagos <= Conteo_reg1 / 5;
            end if;

    end process;

end arch_Contador;


