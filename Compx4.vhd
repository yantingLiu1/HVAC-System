library ieee;
use ieee.std_logic_1164.all;

entity Compx4 is
port(
	A : in std_logic_vector(3 downto 0);
	B : in std_logic_vector(3 downto 0);
	
	AGTBF : out std_logic;
	AEQBF : out std_logic;
	ALSBF : out std_logic
);

end Compx4;

architecture comparator of Compx4 is
	component Compx1 port(
		A : in std_logic;
		B : in std_logic;
		
		AGreater : out std_logic;
		AEqual : out std_logic;
		ALesser : out std_logic
	);
	end component;
	
	signal AGTB : std_logic_vector(3 downto 0);
	signal AEQB : std_logic_vector(3 downto 0);
	signal ALTB : std_logic_vector(3 downto 0);
		
	begin
		comp0 : Compx1
			port map(
				A(0),
				B(0),
				AGTB(0),
				AEQB(0),
				ALTB(0)
			);
		
		comp1 : Compx1
			port map(
				A(1),
				B(1),
				AGTB(1),
				AEQB(1),
				ALTB(1)
			);
		
		comp2 : Compx1
			port map(
				A(2),
				B(2),
				AGTB(2),
				AEQB(2),
				ALTB(2)
			);
		
		comp3 : Compx1
			port map(
				A(3),
				B(3),
				AGTB(3),
				AEQB(3),
				ALTB(3)
			);
			
   AGTBF <= AGTB(3) or
             (AEQB(3) and AGTB(2)) or
             (AEQB(3) and AEQB(2) and AGTB(1)) or
             (AEQB(3) and AEQB(2) and AEQB(1) and AGTB(0));

    ALSBF <= ALTB(3) or
             (AEQB(3) and ALTB(2)) or
             (AEQB(3) and AEQB(2) and ALTB(1)) or
             (AEQB(3) and AEQB(2) and AEQB(1) and ALTB(0));

    AEQBF <= AEQB(3) and AEQB(2) and AEQB(1) and AEQB(0);
	 
	end comparator;