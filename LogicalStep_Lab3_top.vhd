library ieee;
use ieee.std_logic_1164.all;


entity LogicalStep_Lab3_top is port (
	clkin_50		: in 	std_logic;
	pb_n			: in	std_logic_vector(3 downto 0); --active low
 	sw   			: in  std_logic_vector(7 downto 0); 	
	
	----------------------------------------------------
--	HVAC_temp : out std_logic_vector(3 downto 0); -- used for simulations only. Comment out for FPGA download compiles.
	----------------------------------------------------
	
   leds			: out std_logic_vector(7 downto 0);
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;				    		-- seg7 digit1 selector
	seg7_char2  : out	std_logic				    		-- seg7 digit2 selector
	
); 
end LogicalStep_Lab3_top;

architecture design of LogicalStep_Lab3_top is
--
-- Provided Project Components Used
------------------------------------------------------------------- 

component SevenSegment  port (
   hex	   :  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
   sevenseg :  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
); 
end component SevenSegment;

component segment7_mux port (
          clk        : in  std_logic := '1';
			 DIN2 		: in  std_logic_vector(6 downto 0);	
			 DIN1 		: in  std_logic_vector(6 downto 0);
			 DOUT			: out	std_logic_vector(6 downto 0);
			 DIG2			: out	std_logic;
			 DIG1			: out	std_logic
        );
end component segment7_mux;
--	
--component Tester port (
-- MC_TESTMODE				: in  std_logic;
-- I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
--	input1					: in  std_logic_vector(3 downto 0);
--	input2					: in  std_logic_vector(3 downto 0);
--	TEST_PASS  				: out	std_logic							 
--	); 
--	end component;
----	
--component HVAC 	port (
--	HVAC_SIM					: in boolean; --make sure HVAC component HVAc sim is set to true during SIMULATIONS, during FULL compiles, set to FALSE
--	clk						: in std_logic; 
--	run		   			: in std_logic;
--	increase, decrease	: in std_logic;
--	temp						: out std_logic_vector (3 downto 0)
--	);
--end component;
------------------------------------------------------------------
-- Add any Other Components here
------------------------------------------------------------------
component Compx4 port(
	A : in std_logic_vector(3 downto 0);
	B : in std_logic_vector(3 downto 0);
	
	AGTBF : out std_logic;
	AEQBF : out std_logic;
	ALSBF : out std_logic
);
end component;
------------------------------------------------------------------	
-- Create any additional internal signals to be used
------------------------------------------------------------------	
constant HVAC_SIM : boolean := FALSE; -- set to FALSE when compiling for FPGA download to LogicalStep board 
                                      -- or TRUE for doing simulations with the HVAC Component
------------------------------------------------------------------	

-- global clock
signal clk_in					: std_logic;
signal hex_A, hex_B 			: std_logic_vector(3 downto 0);
signal hexA_7seg, hexB_7seg: std_logic_vector(6 downto 0);

		signal desired_temp   : std_logic_vector(3 downto 0);
    signal vacation_temp  : std_logic_vector(3 downto 0);
    signal mux_temp       : std_logic_vector(3 downto 0);
    signal current_temp   : std_logic_vector(3 downto 0);
    
    signal run_s            : std_logic;
    signal inc, dec       : std_logic;
    signal at_temp        : std_logic;

    
	 signal vacation_mode_s : std_logic;
    signal MC_test_mode_s   : std_logic;
    signal door_open_s      : std_logic;
    signal window_open_s    : std_logic;
	 
	 
    signal AGTBF_s, AEQBF_s, ALSBF_s : std_logic;

    signal test_pass_sig : std_logic;
	signal pb_o : std_logic_vector(3 downto 0);
------------------------------------------------------------------- 
component Bidir_shift_reg
    port (
        CLK            : in std_logic;
        RESET          : in std_logic;
        CLK_EN         : in std_logic;
        LEFT0_RIGHT1   : in std_logic;
        REG_BITS       : out std_logic_vector(7 downto 0)
    );
end component;

--leds <= sreg_output;

component  U_D_Bin_Counter8bit port(
	CLK : in std_logic;
	RESET : in std_logic; 
	CLK_EN : in std_logic;
	UP1_DOWN0 : in std_logic;
	COUNTER_BITS : out std_logic_vector(7 downto 0)
);
end component;
--leds <= counter_output;

component Energy_Monitor
        port (
           
			equal         : in  std_logic;
			greater       : in  std_logic;
			less          : in  std_logic;
			door_open     : in  std_logic;
			window_open   : in  std_logic;
			MC_test_mode  : in  std_logic;
			vacation_mode : in std_logic;

			run           : out std_logic;
			increase      : out std_logic;
			decrease      : out std_logic;
			
			furnace_led   : out std_logic;
			at_temp_led   : out std_logic;
			ac_led        : out std_logic;
			blower_led : out std_logic;
			window_led : out std_logic;
			door_led : out std_logic;
			vacation_led : out std_logic
			  );
    end component;

	 component Tester
		port(
 	MC_TESTMODE				: in  std_logic;
   I1EQI2,I1GTI2,I1LTI2	: in	std_logic;
	input1					: in  std_logic_vector(3 downto 0);
	input2					: in  std_logic_vector(3 downto 0);
	TEST_PASS  				: out	std_logic							 
	); 
	end component;
	 
	 component mux
        port (
         desired_Temp4, vacation_Temp4 : in std_logic_vector(3 downto 0); 
	vacation_mode: in std_logic; 
	mux_temp4: out std_logic_vector(3 downto 0) 
        );
    end component;
	 
	 component PB_inverters
        port (
            pb_in   : in  std_logic_vector(3 downto 0);
            pb     : out std_logic_vector(3 downto 0)
        );
    end component;
	 
	 component HVAC
		port
	(
		HVAC_SIM					: in boolean;
		clk						: in std_logic; 
		run		   			: in std_logic;
		increase, decrease	: in std_logic;
		temp						: out std_logic_vector (3 downto 0)
	);
	end component;
			
		
	 
	 signal sreg_output      : std_logic_vector(7 downto 0);
signal counter_output   : std_logic_vector(7 downto 0);
signal not_used  : std_logic;


begin -- Here the circuit begins

		clk_in <= clkin_50;	--hook up the clock input
		desired_temp  <= sw(3 downto 0);
		vacation_temp <= sw(7 downto 4);
	
    -- Invert push buttons
--    vacation_mode_s <= not pb_n(3);
--    MC_test_mode_s  <= not pb_n(2);
--    door_open_s     <= not pb_n(1);
--    window_open_s   <= not pb_n(0);

-- temp inputs hook-up to internal busses.
	hex_A <= sw(3 downto 0);
	--hex_A <= current_temp;
	hex_B <= sw(7 downto 4);

	inst1: sevensegment port map (hex_A, hexA_7seg);
	inst2: sevensegment port map (hex_B, hexB_7seg);
	inst3: segment7_mux port map (clk_in, hexA_7seg, hexB_7seg, seg7_data, seg7_char2, seg7_char1);
	---inst4: Compx4 port map(sw(3 downto 0), sw(7 downto 0), leds(2), leds(1), leds(0)); -- from the top level diagram 
    COMPARATOR: Compx4 port map(
       mux_temp,
        current_temp,
--		  leds(3),
--		  leds(2),
--		  leds(1)
			AGTBF_s,
			AEQBF_s,
			ALSBF_s
    );

--inst5: Bidir_shift_reg port map(clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));
--inst6:  U_D_Bin_Counter8bit port map(clk_in, NOT(pb_n(0)), sw(0), sw(1), leds(7 downto 0));


    HVAC1: HVAC port map(
        HVAC_SIM,
       clk_in,
         run_s,
        inc,
        dec,
        current_temp
    );
	 	
	PBInvert1: PB_Inverters port map(
		pb_n, 
		pb_o
	);


    EM1: Energy_Monitor port map(
			AEQBF_s,
			AGTBF_s,
			ALSBF_s,
			pb_o(0),
			pb_o(1),
			pb_o(2),
			pb_o(3),

			run_s,
			inc,
			dec,
			
--			not_used,
--			not_used,
--			not_used,
--			not_used,
--			not_used,
--			not_used,
--			not_used
	
			leds(0),
			leds(1),
			leds(2),
			leds(3),
			leds(4),
			leds(5),
			leds(7)
    );


    MUX1: mux port map(
        sw(3 downto 0),
        sw(7 downto 4),
        pb_o(3),
        mux_temp
    );
	 
    Tester1: Tester port map(
        pb_o(2),
        AEQBF_s,
        AGTBF_s,
        ALSBF_s,
		  sw(3 downto 0),
      -- mux_temp,
        current_temp,
        leds(6)
    );	
	
end design;

