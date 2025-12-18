library ieee;
use ieee.std_logic_1164.all;

entity Compx1 is
port(
	A : in std_logic;
	B : in std_logic;
	
	AGreater : out std_logic;
	AEqual : out std_logic;
	ALesser : out std_logic
);

end Compx1;

architecture comparator of Compx1 is
begin
	Agreater <= A AND (NOT B);
	AEqual <= NOT (A XOR B);
	ALesser <= (NOT A) AND B;
end comparator;