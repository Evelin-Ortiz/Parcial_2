library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Freq_Divider is
    Port ( clk : in STD_LOGIC;
           out_clk : out STD_LOGIC
           );
end Freq_Divider;

architecture Behavioral of Freq_Divider is
    constant CLK_FREQUENCY : integer := 50000000;  
    constant COUNT_MAX : integer := CLK_FREQUENCY * 3;  
    signal count : integer range 0 to COUNT_MAX-1;
    signal out_internal : std_logic;
begin
    process (clk)
    begin
        if rising_edge(clk) then
            count <= count + 1;
            if count = COUNT_MAX-1 then
                count <= 0;
                out_internal <= NOT out_internal;
            end if;
        end if;
    end process;

    out_clk <= out_internal;
end Behavioral;
