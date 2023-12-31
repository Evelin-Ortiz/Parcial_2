library ieee ;
    use ieee.std_logic_1164.all ;
    use ieee.numeric_std.all ;

entity Parqueadero_2Parcial is
    port (
			Contrasena1   			    	 : in std_logic_vector(3 downto 0);
			Parqueadero 			       : in std_logic_vector(7 downto 0);
			
			Selec					       	 : in std_logic;
			Front_Sensor, Back_Sensor   : in std_logic;
			reset 		 					 : in STD_LOGIC;
			clock    	  					 : in STD_LOGIC;
			
			Led_V, Led_R 			       : out std_logic;
			N_Estacionamiento		       : out std_logic_vector(6 downto 0);
			Display_P                   : out std_logic_vector(6 downto 0);
			Espacio_Libre      		    : out std_logic_vector(6 downto 0)
			);
end Parqueadero_2Parcial ; 

architecture arch of Parqueadero_2Parcial is
    
    type State_Type is (Std_Inicial, Std_Contrasena,Std_Espera, Std_Estacionamiento);
    signal Estado_actual, Estado_sig : State_Type;

   

	signal clock_1  	  : STD_LOGIC;
	signal contador_int : integer range 1 to 9 := 1;
	signal opcion 		  : integer range 1 to 8;
   signal contador 	  : integer range 0 to 8 :=8 ;
	

   signal Pago_1 : integer;
	signal Pago_2 : integer;
	signal Pago_3 : integer;
	signal Pago_4 : integer;
	signal Pago_5 : integer;
	signal Pago_6 : integer;
	signal Pago_7 : integer;
	signal Pago_8 : integer;
	
	

   signal Pago 	 : integer range 0 to 9;
   signal enable_P : std_logic_vector(7 downto 0) := (Parqueadero);
   signal l_verde  : std_logic;
   signal l_rojo   : std_logic;


   component Contador_Tiempo is
    Port ( clk, reset, enable : in STD_LOGIC;
           pagos : out integer
           );
end component;

    component Freq_Divider is
    Port ( clk : in STD_LOGIC;
           out_clk : out STD_LOGIC
           );
	end component;

    component Contrasena is
		Port(Clock, Reset            : in std_logic;
			Clave 		              : in std_logic_vector(3 downto 0);
			Led_Verde, Led_Rojo	     : out std_logic);
    end component;

begin
    
    

    STATE_MEMORY: PROCESS (clock, reset)

    begin 
	IF (reset ='1') then 
		Estado_actual <= Std_Inicial;
	ELSIF (clock'event and clock='1') then 
		Estado_actual <= Estado_sig;
	END IF;
    END PROCESS;
    

    NEXT_STATE_LOGIC: PROCESS (Estado_actual, Front_Sensor, Back_Sensor)

    begin 
		CASE (Estado_actual) is 
			when Std_Inicial =>  if (Front_Sensor ='1' and Back_Sensor ='0') then
				Estado_sig<=Std_Contrasena;
				else 
				Estado_sig<=Std_Inicial;
				end if;				
    
			when Std_Contrasena =>  if ( Back_Sensor ='1' and l_verde = '1'  ) then
				Estado_sig<=Std_Estacionamiento;
				else 
				Estado_sig<= Std_Espera;
				end if;
            
			when Std_Espera =>  if (Back_Sensor ='1' and l_verde = '1' ) then
							Estado_sig<=Std_Estacionamiento;
							else 
							Estado_sig<=Std_Espera;
							end if;	
							
         when Std_Estacionamiento =>  if (Front_Sensor ='0' and Back_Sensor ='0' ) then
				Estado_sig<=Std_Inicial;
				else 
				Estado_sig<=Std_Estacionamiento;
				end if;
    
    
		when others => Estado_sig<=Std_Inicial;
    
        end case;
    END PROCESS;

    OUTPUT_LOGIC : process (Estado_actual, Front_Sensor, Back_Sensor)
	begin
		case (Estado_actual) is
			when Std_Inicial => 
				if (Front_Sensor = '0' and Back_Sensor = '0') then
					Led_V <= '0';
					Led_R <= '0';
				end if;
			when Std_Contrasena =>  
				if (Front_Sensor = '1' and Back_Sensor = '0') then
					Led_V <= l_verde;
					Led_R <= l_rojo;
				end if;
				
			when Std_Espera =>  if (Back_Sensor ='1' and l_verde = '1' ) then
					Led_V <= l_verde;
					Led_R <= l_rojo;
					end if;
					
			when Std_Estacionamiento =>  
				if (Back_Sensor = '1' and l_verde = '1') then
					enable_P <= Parqueadero;
					
				end if;
			when others => 
				Led_V <= '0';
				Led_R <= '0';
		end case;
	end process;

    Contrasena0: Contrasena port map (Clock => clock, Reset => reset, Clave => Contrasena1, Led_Verde => l_verde, Led_Rojo => l_rojo);

--------------------------------------------------------------------------------------------------
   Reloj1s: Freq_Divider port map (clk => clock, out_clk => clock_1);
	 --Parqueadero 1
	
	P1 : Contador_Tiempo port map (clk => clock_1, reset => reset, enable => Parqueadero(0),pagos=>Pago_1);
	
	--Parqueadero 2
	
	P2 : Contador_Tiempo port map (clk => clock_1, reset => reset, enable => Parqueadero(1),pagos=>Pago_2);
	
	--Parqueadero 3
	
	P3 : Contador_Tiempo port map (clk => clock_1, reset => reset, enable => Parqueadero(2), pagos=>Pago_3);
	
	--Parqueadero 4
	
	P4 : Contador_Tiempo port map (clk => clock_1, reset => reset, enable => Parqueadero(3), pagos=>Pago_4);
	
	--Parqueadero 5
	
	P5 : Contador_Tiempo port map (clk => clock_1, reset => reset, enable => Parqueadero(4), pagos=>Pago_5);
	
	--Parqueadero 6
	
	P6 : Contador_Tiempo port map (clk => clock_1, reset => reset, enable => Parqueadero(5),pagos=>Pago_6);
	
	--Parqueadero 7
	
	P7 : Contador_Tiempo port map (clk => clock_1, reset => reset, enable => Parqueadero(6),pagos=>Pago_7);
	
	--Parqueadero 8
	
	P8 : Contador_Tiempo port map (clk => clock_1, reset => reset, enable => Parqueadero(7),pagos=>Pago_8);

--------------------------------------------------------------------------------------------------

	
    Contador_Cero: process (Parqueadero)
    begin
	 contador<=8;
        for i in Parqueadero'range loop
            if Parqueadero(i) = '1' then
                contador <= contador - 1;
					 else
					 contador<=8;
            end if;
        end loop;
    end process;
--------------------------------------------------------------------------------------------------
    --Contador del Selector

    process(Selec)
    begin
        if rising_edge(Selec) then
            if contador_int > 8 then
                contador_int <= 1;
            else
                contador_int <= contador_int + 1;
            end if;
        end if;
        opcion <= contador_int;
    end process;

    with opcion select
    Pago <= Pago_1 when 1,
            Pago_2 when 2,
            Pago_3 when 3,
            Pago_4 when 4,
            Pago_5 when 5,
            Pago_6 when 6,
            Pago_7 when 7,
            Pago_8 when 8;
            
----------------------------------------------------------------------------------------------
    --Decodificador

	process (Pago) begin
		case Pago is 
			when 0 =>Display_P<= "0000001";
			when 1 =>Display_P<= "1001111";
			when 2 =>Display_P<= "0010010";
			when 3 =>Display_P<= "0000110";
			when 4 =>Display_P<= "1001100";
			when 5 =>Display_P<= "0100100";
			when 6 =>Display_P<= "0100000";
			when 7 =>Display_P<= "0001111";
			when 8 =>Display_P<= "0000000";
			when 9 =>Display_P<= "0000100";
			when others  =>Display_P<= "1111111";
		end case;
	end process;

    process (opcion) begin
		case opcion is 
			when 1 =>N_Estacionamiento<= "1001111";
			when 2 =>N_Estacionamiento<= "0010010";
			when 3 =>N_Estacionamiento<= "0000110";
			when 4 =>N_Estacionamiento<= "1001100";
			when 5 =>N_Estacionamiento<= "0100100";
			when 6 =>N_Estacionamiento<= "0100000";
			when 7 =>N_Estacionamiento<= "0001111";
			when 8 =>N_Estacionamiento<= "0000000";
			when others  =>N_Estacionamiento<= "1111111";
		end case;
	end process;

    process (contador) begin
		case contador is 
			when 0 =>Espacio_Libre<= "0000001";
			when 1 =>Espacio_Libre<= "1001111";
			when 2 =>Espacio_Libre<= "0010010";
			when 3 =>Espacio_Libre<= "0000110";
			when 4 =>Espacio_Libre<= "1001100";
			when 5 =>Espacio_Libre<= "0100100";
			when 6 =>Espacio_Libre<= "0100000";
			when 7 =>Espacio_Libre<= "0001111";
			when 8 =>Espacio_Libre<= "0000000";
			when others  =>Espacio_Libre<= "1111111";
		end case;
	end process;
 
end architecture ;

