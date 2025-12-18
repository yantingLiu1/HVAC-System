library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- clk input is the LogicalStep 50MHz clock input
entity HVAC is
    port (
        HVAC_SIM    : in boolean;
        clk         : in std_logic; 
        run         : in std_logic;
        increase    : in std_logic;
        decrease    : in std_logic;
        temp        : out std_logic_vector (3 downto 0)
    );
end entity;

architecture rtl of HVAC is

    signal clk_2hz        : std_logic;
    signal HVAC_clock     : std_logic;
    signal digital_counter : std_logic_vector(23 downto 0);
    signal cnt            : unsigned(3 downto 0) := "0111";

begin

    -- clk_divider process generates a 2Hz Clock from the 50 MHz clk
    clk_divider: process (clk)
        variable counter : unsigned(23 downto 0) := (others => '0');
    begin
        if rising_edge(clk) then
            counter := counter + 1;
        end if;
        digital_counter <= std_logic_vector(counter);
    end process;
    
    clk_2hz <= digital_counter(23);

    -- Clock multiplexer chooses between clk and divided clock
    clk_mux: process (HVAC_SIM, clk, clk_2hz)
    begin
        if HVAC_SIM then
            HVAC_clock <= clk;
        else
            HVAC_clock <= clk_2hz;
        end if;
    end process;

    -- Temperature control process
    process (HVAC_clock)
    begin
        if rising_edge(HVAC_clock) then
            if run = '1' then
                if increase = '1' and cnt < "1111" then
                    cnt <= cnt + 1;
                elsif decrease = '1' and cnt > "0000" then
                    cnt <= cnt - 1;
                end if;
            end if;
        end if;
    end process;

    temp <= std_logic_vector(cnt);

end rtl;