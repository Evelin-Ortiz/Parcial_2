library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity Contrasena is
	Port(Clock, Reset           : in std_logic;
		Clave 		             : in std_logic_vector(3 downto 0);
		Led_Verde, Led_Rojo	 : out std_logic);

end Contrasena ; 

architecture arch_Contrasena of Contrasena is



type State_Type is (Std_In, Std_Intento1, Std_Intento2, Std_Intento3, Std_Ingresa);
signal Estado_Actual, Estado_Siguiente : State_Type;

begin
STATE_MEMORY: PROCESS (Clock, Reset)

    begin 
	if (Reset ='1') then 
		Estado_Actual <= Std_In;
	elsif (Clock'event and Clock='1') then 
		Estado_Actual <= Estado_Siguiente;
	end if;
    end PROCESS;


NEXT_STATE_LOGIC: PROCESS (Estado_Actual, Clave)
begin 	
	CASE (Estado_Actual) is 
		when Std_In =>  if (Clave="0011") then
							Estado_Siguiente<=Std_Ingresa;
							else 
							Estado_Siguiente<=Std_Intento1;
							end if;
							
	  when Std_Ingresa =>  if (Clave="0011") then
							Estado_Siguiente<=Std_In;
							else 
							Estado_Siguiente<=Std_Intento1;
							end if;					
		when Std_Intento1  =>  if (Clave="0011") then
							Estado_Siguiente<=Std_Ingresa;
							else 
							Estado_Siguiente<=Std_Intento2;
							end if;
							
		when Std_Intento2  =>  if (Clave="0011") then
							Estado_Siguiente<=Std_Ingresa;
							else 
							Estado_Siguiente<=Std_Intento3;
							end if;

		when Std_Intento3  =>  if (Clave="0011") then
							Estado_Siguiente<=Std_Ingresa;
							else 
							Estado_Siguiente<=Std_In;
							end if;
							
		when others => Estado_Siguiente<=Std_In;
    
end case;
end PROCESS;

OUTPUT_LOGIC : process (Estado_Actual, Clave)
	begin
			case (Estado_Actual) is
				when Std_In =>
					if (Clave="0011") then
						Led_Verde <= '1'; Led_Rojo <= '0';
					else
						Led_Verde <= '0'; Led_Rojo <= '1';
					end if;
					
					when Std_Ingresa =>  if (Clave="0011") then
							Led_Verde<='1'; Led_Rojo<='0';
							else 
							Led_Verde<='0'; Led_Rojo<='1';
							end if;		
							
				when Std_Intento1 => 	
					if (Clave="0011") then
						Led_Verde <= '1'; Led_Rojo <= '0';
					else
						Led_Verde <= '0'; Led_Rojo <= '1';
					end if;
				when Std_Intento2  => 	
					if (Clave="0011") then
						Led_Verde <= '1'; Led_Rojo <= '0';
					else
						Led_Verde <= '0'; Led_Rojo <= '1';
					end if;
				when Std_Intento3 => 	
				if (Clave="0011") then
					Led_Verde <= '1'; Led_Rojo <= '0';
				else
					Led_Verde <= '0'; Led_Rojo <= '1';
				end if;
				when others => Led_Verde <= '0'; Led_Rojo <= '0';
			end case;
		end process;

end arch_Contrasena ;