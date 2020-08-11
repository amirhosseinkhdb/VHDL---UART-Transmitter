LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY test IS
END test;
 
ARCHITECTURE behavior OF test IS 
  
    COMPONENT uart IS
        PORT(
            clk       :   IN STD_LOGIC;
            rst       :   IN STD_LOGIC;
            --clk_mode  :   IN STD_LOGIC;
            cs          :   IN STD_LOGIC;
            wr          :   IN STD_LOGIC;
            rd          :   IN STD_LOGIC;
            --address_bus :   IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_bus    :   INOUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            transmit_out:   OUT STD_LOGIC
        );
    END COMPONENT;
    

   
   signal clk : std_logic := '0';
   signal rst,wr,rd,cs : std_logic;

   signal data : std_logic_vector(7 downto 0);

   signal transmit_out : std_logic;

   CONSTANT high_impedance : STD_LOGIC_VECTOR(7 DOWNTO 0) :=(OTHERS => 'Z');
 
BEGIN
 
   uut: uart PORT MAP (
          clk => clk,
          rst => rst,
          --clk_mode => clk_mode,
          cs => cs,
          wr => wr,
          rd => rd,
          ----address => --address,
          data_bus=> data,
          transmit_out => transmit_out
        );

    clk <= NOT clk AFTER 5 NS;
    --clk_mode <= '0';
    rst <='1', '0' AFTER 20 NS;
    cs <= '1';
 
    --wr<= '1' after 20 ns,'0' after 90 ns,'1' after 945 ns,'0' after 955 ns;
    wr<= '1' after 20 ns,'0' after 90 ns,'1' after 225 ns,'0' after 235 ns;
    data<= X"11" after 20 ns,
           X"22" after 30 ns,
           X"33" after 40 ns,
           X"44" after 50 ns,
           X"55" after 60 ns,
           X"66" after 70 ns,
           X"77" after 80 ns,
           --X"88" after 90 ns,
           high_impedance after 100 ns,
           X"88" after 220 ns,
           high_impedance after 245 ns;
    --rd <= '0',
    --      '1' after 110 ns, '0' after 120 ns,
    --      '1' after 225 ns, '0' after 235 ns,
    --      '1' after 345 ns, '0' after 355 ns,
    --      '1' after 465 ns, '0' after 475 ns,
    --      '1' after 585 ns, '0' after 595 ns,
    --      '1' after 705 ns, '0' after 715 ns,
    --      '1' after 825 ns, '0' after 835 ns,
    --      '1' after 975 ns, '0' after 985 ns;

    rd <= '0',
          '1' after 110 ns, '0' after 120 ns;

END;
