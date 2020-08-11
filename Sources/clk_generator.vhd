LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

ENTITY clock_generator IS
    PORT(clock : IN STD_LOGIC;
         rst : IN STD_LOGIC;
         clock_mode : IN STD_LOGIC;
         clk_res : OUT STD_LOGIC
         );
END ENTITY;

ARCHITECTURE behavioral OF clock_generator IS
    
BEGIN

    PROCESS(clock,rst)
        VARIABLE COUNT : INTEGER:=0;
        VARIABLE TEMP : STD_LOGIC:='0';
    BEGIN
            IF (clock='1' AND clock'EVENT) THEN
                IF (rst='1') THEN
                    COUNT:=0;
                    TEMP:='0';
                ELSIF (clock_mode='1') THEN
                    COUNT:=COUNT+1;
                    IF (COUNT=1) THEN
                        TEMP:=NOT TEMP;
                        COUNT:=0;
                    END IF;
                    clk_res<=TEMP;
                ELSE
                    clk_res <= clock; 
                END IF;
            END IF;
    END PROCESS;
END behavioral;