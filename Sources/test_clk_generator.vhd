LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY test_clock_generator IS
END ENTITY;

ARCHITECTURE behavioral OF test_clock_generator IS
    COMPONENT clock_generator IS
        PORT(clock : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            clock_mode : IN STD_LOGIC;
            clk_res : OUT STD_LOGIC
            );
    END COMPONENT;
    signal clk : std_logic := '0';
    signal clk_mode,clk_out,rst : std_logic;
BEGIN
    clk_gen : clock_generator port map(clk,rst,clk_mode,clk_out);
    
    clk <= Not clk after 10 ns;
    rst <= '1','0' after 10 ns;
    clk_mode <= '0', '1' after 20 ns, '0' after 1000 ns;

END ;