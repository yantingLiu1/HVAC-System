--Function: Last Mux
--Purpose: Differentiates between the carry and the sum, to determine which set of LEDs it should output to
--Libraries used
library ieee;
use ieee.std_logic_1164.all;

--entity declaration
entity mux is
port(
	desired_Temp4, vacation_Temp4 : in std_logic_vector(3 downto 0); --lastMux0 is the carry, lastMux1 is the sum
	vacation_mode: in std_logic; --selects between the carry and sum
	mux_temp4: out std_logic_vector(3 downto 0) --result of between whether to use lastMux0 or lastMux1
);

end mux;

architecture muxLogic of mux is

--code begins
begin 

	-- for the multiplexing of four hex input busses

	with vacation_mode select
	mux_temp4 <= desired_Temp4 when '0',
					vacation_Temp4 when '1';
end muxLogic;