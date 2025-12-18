library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Tester is
    port (
        MC_TESTMODE          : in  std_logic;
        I1EQI2, I1GTI2, I1LTI2: in std_logic;
        input1               : in  std_logic_vector(3 downto 0);
        input2               : in  std_logic_vector(3 downto 0);
        TEST_PASS            : out std_logic
    );
end Tester;

architecture Test_ckt of Tester is
    signal EQ_PASS, GT_PASS, LT_PASS : std_logic;
begin

    Tester1: process (MC_TESTMODE, input1, input2, I1EQI2, I1GTI2, I1LTI2)
    begin
        if (input1 = input2) and (I1EQI2 = '1') then
            EQ_PASS <= '1';
            GT_PASS <= '0';
            LT_PASS <= '0';

        elsif ((input1) > (input2)) and (I1GTI2 = '1') then
            GT_PASS <= '1';
            EQ_PASS <= '0';
            LT_PASS <= '0';

        elsif ((input1) < (input2)) and (I1LTI2 = '1') then
            LT_PASS <= '1';
            EQ_PASS <= '0';
            GT_PASS <= '0';

        else
            EQ_PASS <= '0';
            GT_PASS <= '0';
            LT_PASS <= '0';
        end if;

        TEST_PASS <= MC_TESTMODE and (EQ_PASS or GT_PASS or LT_PASS);
    end process;

end test_ckt;