LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL ;

ENTITY uart IS
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
END ENTITY;


ARCHITECTURE behavioral OF uart IS

    --Clock Generator
   --COMPONENT clock_generator IS
   --    PORT(clock : IN STD_LOGIC;
   --         rst : IN STD_LOGIC;
   --         clock_mode : IN STD_LOGIC;
   --         clk_res : OUT STD_LOGIC
   --        );
   --END COMPONENT;
   --SIGNAL clk_out : STD_LOGIC;

    --FSM
    TYPE state IS (idle, start, data0, data1, data2, data3, data4, data5, data6, data7, stop);
    SIGNAL current_state    : state:=idle;
    SIGNAL next_state       : state:=idle;

    --FIFO
    TYPE RAM_TYPE IS ARRAY (0 TO (2**3)-1) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL fifo             : RAM_TYPE;
    SIGNAL nextwrite        : UNSIGNED(2 DOWNTO 0);
    SIGNAL nextread         : UNSIGNED(2 DOWNTO 0);
    SIGNAL data_in,data_out :   STD_LOGIC_VECTOR(7 DOWNTO 0);

    SIGNAL send_empty       :   STD_LOGIC;
    SIGNAL send_full        :   STD_LOGIC;
    
    SIGNAL bit_count    : UNSIGNED(3 DOWNTO 0);

    CONSTANT high_impedance : STD_LOGIC_VECTOR(7 DOWNTO 0) :=(OTHERS => 'Z');
BEGIN

   --clk_gen: clock_generator PORT MAP (
   --    clock => clk,
   --    rst => rst,
   --    clock_mode => clk_mode,
   --    clk_res => clk_out
   --);
    send_empty <= '1' WHEN (nextwrite=nextread) ELSE '0';
    send_full <= '1' WHEN (nextwrite+1=nextread) ELSE '0';

    PROCESS(clk)
    BEGIN
        IF ( clk='1' AND clk'EVENT) THEN
            IF (rst='1') THEN
                nextread <= (OTHERS => '0');
            ELSIF (rd='1' AND cs='1') THEN 
                data_out <= fifo(TO_INTEGER(nextread));
            END IF;
            --IF (current_state = stop AND next_state=idle)THEN
            IF (current_state = start AND next_state=data0)THEN
                nextread <= nextread + 1;
            END IF;
        END IF;
    END PROCESS;

    PROCESS(clk)
    BEGIN
        IF (clk='1' AND clk'EVENT) THEN
            IF (rst='1') THEN
                nextwrite <= (OTHERS => '0');
            ELSIF (wr='1' AND cs='1') THEN
                fifo ( to_integer ( nextwrite )) <= data_in ;
                nextwrite <= nextwrite +1;
            END IF;
        END IF;
    END PROCESS;


    PROCESS (clk)
    BEGIN
        IF (clk='1' AND clk'EVENT) THEN
            IF (rst='1') THEN
                current_state <= idle;
            ELSE
                current_state <= next_state;
            END IF;
        END IF;
    END PROCESS; 


    PROCESS(current_state,rst,nextread,rd)
    BEGIN
            CASE current_state IS
                WHEN idle =>
                     IF (rst='1') THEN
                        bit_count <= (OTHERS => '0');
                        transmit_out <='1';
                        next_state <= idle;
                    END IF;
                    IF (rd='1' AND cs='1') THEN
                        IF (nextwrite /= nextread) THEN
                            next_state <= start;
                            bit_count <= (OTHERS => '0');
                            transmit_out <= '1'; 
                        ELSE
                            transmit_out <= '1';
                        END IF;
                    END IF;
                WHEN start => 
                            next_state <= data0;
                            transmit_out <= '0';
                            bit_count <= (OTHERS => '0');
                WHEN data0 => 
                            next_state <= data1;
                            transmit_out <= data_out(0);
                            bit_count <= bit_count + 1;
                WHEN data1 => 
                            next_state <= data2;
                            transmit_out <= data_out(1);
                            bit_count <= bit_count + 1;
                WHEN data2 => 
                            next_state <= data3;
                            transmit_out <= data_out(2);
                            bit_count <= bit_count + 1;
                WHEN data3 => 
                            next_state <= data4;
                            transmit_out <= data_out(3);
                            bit_count <= bit_count + 1;
                WHEN data4 => 
                            next_state <= data5;
                            transmit_out <= data_out(4);
                            bit_count <= bit_count + 1;
                WHEN data5 => 
                            next_state <= data6;
                            transmit_out <= data_out(5);
                            bit_count <= bit_count + 1;
                WHEN data6 => 
                            next_state <= data7;
                            transmit_out <= data_out(6);
                            bit_count <= bit_count + 1;
                WHEN data7 => 
                            next_state <= stop;
                            transmit_out <= data_out(7);
                            bit_count <= bit_count + 1;
                            IF (bit_count = "1000") THEN
                                bit_count <= (OTHERS => '0');
                            END IF;
                WHEN stop => 
                            next_state <= idle;
                            bit_count <= (OTHERS => '0');
                            transmit_out <= '1';  
                                              
                WHEN OTHERS => NULL;
            END CASE;
    END PROCESS;
    data_in <= data_bus;
    data_bus <= data_out WHEN (rd='1') ELSE high_impedance;


END behavioral;