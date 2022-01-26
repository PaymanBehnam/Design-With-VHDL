-- FIR SAMPLES INPUT ENGINE MODEL
LIBRARY IEEE; USE IEEE.STD_LOGIC_1164.ALL; USE IEEE.STD_LOGIC_UNSIGNED.ALL;	use ieee.std_logic_arith.all;

ENTITY FIR_INPUT IS
	PORT (
		RST, CLK : IN STD_LOGIC;
		ADDR_OUT, DATAOUT : OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		
		SEND : IN STD_LOGIC;
		WR : OUT STD_LOGIC;
		
		REQUEST : BUFFER STD_LOGIC
		);
END FIR_INPUT;

ARCHITECTURE BEHAV OF FIR_INPUT IS
	SIGNAL SAMPLE1 :  STD_LOGIC_VECTOR (15 DOWNTO 0):= ("0000000000010111");
	SIGNAL SAMPLE2 :  STD_LOGIC_VECTOR (15 DOWNTO 0):= ("0000000000001110");
	SIGNAL SAMPLE3 :  STD_LOGIC_VECTOR (15 DOWNTO 0):= ("0000000000010100");
	SIGNAL SAMPLE4 :  STD_LOGIC_VECTOR (15 DOWNTO 0):= ("0000000000010101");
	SIGNAL COUNT   :  STD_LOGIC_VECTOR (15 DOWNTO 0):= ("0000000000000100");
	SIGNAL START   :  STD_LOGIC;
	
	signal counter   : std_logic_vector (2 downto 0);
	
BEGIN
	
	START <= '0', '1' AFTER 25 US, '0' AFTER 25.01 US,  '1' AFTER 55 US, '0' AFTER 55.01 US;
	
	PROCESS  (RST, CLK )
	BEGIN
		IF RST='1' THEN
			REQUEST 		<= '0';
			WR				<= '0';
			counter			<= "000";
		ELSIF (CLK='1' AND CLK'EVENT) THEN
			DATAOUT <= (others => 'Z');
			ADDR_OUT<= (others => 'Z');
			IF START='1' THEN
				REQUEST 	<= '1';
			END IF;
			IF REQUEST='1' AND SEND='1' THEN
				if counter ="000" then
					WR <= '1';
					DATAOUT		<= COUNT;
					counter		<= counter + "001";
					ADDR_OUT	<= conv_std_logic_vector (128, 16);
				elsif counter ="001" then
					WR <= '1';
					DATAOUT 	<= sample1 ;
					counter		<= counter + "001";
					ADDR_OUT 	<= conv_std_logic_vector (132, 16);
				elsif counter ="010" then
					WR <= '1';
					DATAOUT 	<= sample2 ;
					counter		<= counter + "001";
					ADDR_OUT 	<= conv_std_logic_vector (131, 16);
				elsif counter ="011" then
					WR <= '1';
					DATAOUT 	<= sample3 ;
					counter		<= counter + "001";
					ADDR_OUT 	<= conv_std_logic_vector (130, 16);
				elsif counter ="100" then
					WR <= '1';
					DATAOUT 	<= sample4 ;
					counter		<= counter + "001";
					ADDR_OUT 	<= conv_std_logic_vector (129, 16);
				elsif counter ="101" then
					WR <= '0';
					REQUEST 	<= '0';
					counter		<= "000";
					sample1		<= sample1 + "001";
					sample2		<= sample2 + "001";
					sample3		<= sample3 + "001";
					sample4		<= sample4 + "001";
					
				end if;
				
				
			END IF;
			
		END IF ;
	END PROCESS;
	
END BEHAV;