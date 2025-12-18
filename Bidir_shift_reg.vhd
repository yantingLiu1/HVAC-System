library IEEE;
use IEEE.std_logic_1164.all;

entity Bidir_shift_reg is
    port(
        CLK           : in std_logic := '0';
        RESET         : in std_logic := '0';
        CLK_EN        : in std_logic := '0';
        LEFT0_RIGHT1  : in std_logic := '0';
        REG_BITS      : out std_logic_vector(7 downto 0)
    );
end Bidir_shift_reg;

architecture oneBiDir of Bidir_shift_reg is
    signal sreg : std_logic_vector(7 downto 0);
begin
    process(CLK)
    begin
        if rising_edge(CLK) then
            if RESET = '1' then
                sreg <= (others => '0');
            elsif CLK_EN = '1' then
                if LEFT0_RIGHT1 = '1' then
                    -- Shift right
                    sreg <= '1' & sreg(7 downto 1);
                else
                    -- Shift left
                    sreg <= sreg(6 downto 0) & '0';
                end if;
            end if;
        end if;
    end process;

    REG_BITS <= sreg;
end oneBiDir;