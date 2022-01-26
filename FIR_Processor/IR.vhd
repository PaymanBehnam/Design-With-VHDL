
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL; 
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY INSTRUNCTIONREGISTER IS
	PORT (
		INPUT : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		IRLOAD, CLK : IN STD_LOGIC;
		OUTPUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
		);
END INSTRUNCTIONREGISTER;

ARCHITECTURE DATAFLOW OF INSTRUNCTIONREGISTER IS
BEGIN
	
	PROCESS (CLK)
	BEGIN
		IF (CLK = '1') THEN
			IF (IRLOAD = '1') THEN
				OUTPUT <= INPUT;
			END IF;
		END IF;
	END PROCESS;
	
END DATAFLOW;