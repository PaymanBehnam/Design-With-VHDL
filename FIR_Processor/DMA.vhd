-- DMA Master MODEL  (arbiter)
LIBRARY IEEE; USE IEEE.STD_LOGIC_1164.ALL; USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY DMA IS
	PORT (
		RST, CLK : IN STD_LOGIC;
		
		ADDR_in1, ADDR_iN2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		ADDR_OUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		
		READ_in1, READ_iN2 : IN STD_LOGIC;
		READ_OUT : OUT STD_LOGIC;
		
		WR_in1, WR_iN2 : IN STD_LOGIC;
		WR_OUT : OUT STD_LOGIC;
		
		REQUEST1, REQUEST2 : IN STD_LOGIC;
		MEMREADY_IN : IN STD_LOGIC;
		MEMREADY_OUT1, MEMREADY_OUT2: OUT STD_LOGIC
		);
END DMA;

ARCHITECTURE DATAFLOW OF DMA IS
	SIGNAL CHANNEL1_BUSY, CHANNEL2_BUSY: STD_LOGIC;
	
BEGIN
	
	PROCESS  (RST, CLK )
	BEGIN
		IF RST='1' THEN
			CHANNEL1_BUSY <= '0';
			CHANNEL2_BUSY <= '0';
		ELSIF (CLK='1' AND CLK'EVENT) THEN
			IF (CHANNEL1_BUSY='0') AND (CHANNEL2_BUSY='0') THEN
				IF REQUEST1='1' THEN
					CHANNEL1_BUSY <= '1';
				ELSIF REQUEST2='1' THEN
					CHANNEL2_BUSY <= '1';
				END IF;
			END IF;
			IF (CHANNEL1_BUSY='1') AND (REQUEST1='0') THEN
				CHANNEL1_BUSY <= '0';
			END IF;
			IF (CHANNEL2_BUSY='1') AND (REQUEST2='0') THEN
				CHANNEL2_BUSY <= '0';
			END IF;
		END IF ;
	END PROCESS;
	
	ADDR_OUT <= ADDR_in2 WHEN CHANNEL2_BUSY='1' ELSE ADDR_in1;
	READ_OUT <= READ_in2 WHEN CHANNEL2_BUSY='1' ELSE READ_in1;
	WR_OUT   <= WR_in2   WHEN CHANNEL2_BUSY='1' ELSE WR_in1  ;
		
		MEMREADY_OUT1 <=  CHANNEL1_BUSY;
		MEMREADY_OUT2 <=  CHANNEL2_BUSY;
		
	
END DATAFLOW;