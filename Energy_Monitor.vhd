library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity energy_monitor is
    Port (
		equal : in std_logic;
		greater : in  std_logic;
		less : in  std_logic;
		door_open : in  std_logic;
		window_open : in  std_logic;
		MC_test_mode : in  std_logic;
		vacation_mode : in std_logic;

		run : out std_logic;
		increase : out std_logic;
		decrease : out std_logic;

		furnace_led : out std_logic;
		at_temp_led : out std_logic;
		ac_led : out std_logic;
		blower_led : out std_logic;
		window_led : out std_logic;
		door_led : out std_logic;
		vacation_led : out std_logic
    );
end energy_monitor;

architecture Behavioural of energy_monitor is
BEGIN 
    process(equal, greater, less, door_open, window_open, MC_test_mode, vacation_mode) is
		 begin
		
				-- Default outputs
				run <= '0';
				increase <= '0';
				decrease <= '0';
				ac_led <= '0';
				furnace_led <= '0';
				at_temp_led <= '0';
				blower_led <= '0';
				vacation_led <= '0';
				window_led <= '0';
				door_led <= '0';
		

			  if door_open = '0' and window_open = '0' and MC_test_mode = '0' then
					if greater = '1' then
						-- MUX temp > current temp => increase
						run <= '1';
						increase <= '1';
						decrease <= '0';
						furnace_led <= '1';
						blower_led  <= '1';
						ac_led <= '0';
						at_temp_led <= '0';
						window_led <= '0';
						door_led <= '0';
						
					elsif less = '1' then
						-- MUX temp < current temp => decrease
						run <= '1';
						increase <= '0';
						decrease <= '1';
						furnace_led <= '0';
						ac_led <= '1';
						blower_led  <= '1';
						at_temp_led <= '0';
					elsif equal = '1' then
						-- Temp match => n/a
						run <= '0';
						at_temp_led <= '1';	
						increase <= '0';
						decrease <= '0';
						ac_led <= '0';
						furnace_led <= '0';
						blower_led <= '0';
					end if;
				
				else 
					if door_open = '1' then
					door_led <= '1';
					end if;
					if window_open = '1' then
						window_led <= '1';
					end if;
				end if;
 
				if vacation_mode = '1' then
						vacation_led <= '1';
				end if;
				
				
    end process;

end Behavioural;