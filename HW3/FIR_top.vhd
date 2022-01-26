library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
ENTITY FIR_top IS 
	--generic(logn:integer:=3);
	PORT(clock,reset,input_enable: in STD_LOGIC;FIR_input: in STD_LOGIC_vector (m-1 DOWNTO 0);
		coefficient:in arries_in2;output_enable:Out std_logic;FIR_output:out STD_LOGIC_vector(2*m-1 DOWNTO 0));
end entity;
architecture behavioral of FIR_top is
	component DPUnit 
	--generic(logn:integer:=3);
	PORT(clockDP,resetDP,enableDPRegIn,enableDPRegOut,resetflushout : in STD_LOGIC;inputDP : in STD_LOGIC_vector (m-1 DOWNTO 0);
		cons:in arries_in2;selDP:in std_logic_vector(logn-1 downto 0);
		outputDP:out STD_LOGIC_vector(2*m-1 DOWNTO 0)); 
	END component;
	component ConUnit 
	--generic(logn:Integer:=3);
	port(clockCU,input_enableCU,resetCU:in std_logic;enRegOutCU,enRegArrayCU,Output_EnableCU,flushout:Out std_logic;
	muxselCU:inout std_logic_vector(logn-1 downto 0));
	end Component;
	signal sigeninreg,sigenoutreg:std_logic_vector(2*m-1 downto 0);
	signal sigsel:std_logic_vector(logn-1 downto 0);
	signal sigenRegIn,sigenRegOut,sigflushout:std_logic;
	begin
	unitDataPath:DPUnit port map(clockDP=>clock,resetDP=>reset,resetflushout=>sigflushout,enableDPRegIn=>sigenRegIn,enableDPRegOut=>sigenRegOut
		,inputDP=>FIR_input,cons=>coefficient,selDP=>sigsel,outputDP=>FIR_output); 
	unitControlunit:Conunit port map(clockCU=>clock,input_enableCU=>input_enable,resetCU=>reset,enRegOutCU=>sigenRegOut,
	enRegArrayCU=>sigenRegIn,Output_EnableCU=>output_Enable,muxselCU=>sigsel,flushout=>sigflushout);
end behavioral;

	


