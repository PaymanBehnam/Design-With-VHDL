library ieee;
use ieee.std_logic_1164.all;
use work.my_pack.all;
entity DPUnit is
	--generic(logn:integer:=3);
	PORT(clockDP,resetDP,enableDPRegIn,enableDPRegOut,resetflushout: in STD_LOGIC;inputDP : in STD_LOGIC_vector (m-1 DOWNTO 0);
		cons:in arries_in2;selDP:in std_logic_vector(logn-1 downto 0);
		outputDP:out STD_LOGIC_vector(2*m-1 DOWNTO 0)); 
END DPUnit;
architecture behavioral of  DPUnit is
	component RegArray 
		--generic(n:Integer:=8);
		port(inpra:in std_logic_vector(m-1 downto 0);clockra,resetra,enablera:in std_logic;
		outra:out arries_in2);
	end component;
	
	--component RegParam is
	--generic(m:INTEGER:=4;n:Integer:=4);
	--port(inpra:IN std_logic_VECTOR(m-1 downto 0 );reset,clock,enable:IN std_logic;outrp:OUT std_logic_VECTOR(m-1 downto 0));
	--end component;
	
	component MuxParam2 
	--generic(logn:INTEGER:=3);
	port(inpmux2:IN arries_in2;selmux2:IN std_logic_vector(logn-1 downto 0);outmux2:out std_logic_vector(m-1 downto 0));
	end component;
	
	component MuxParam1 
	--generic(logn:INTEGER:=3);
	port(inpMux1:IN arries_in2;selmux1:IN std_logic_vector(logn-1 downto 0);outMux1:out std_logic_vector(m-1 downto 0));
	end component;
	
	component Multiplier 
	--generic(m:INTEGER:=4);
	port(inmp1:in std_logic_vector(m-1 downto 0);inmp2:in std_logic_vector;outmp:out std_logic_vector(2*m-1 downto 0));
	end component;
	
	component Adder 
	--generic(m:INTEGER:=4);
	port(inadd1:in std_logic_vector(2*m-1 downto 0);inadd2:in std_logic_vector(2*m-1 downto 0);outadd:out std_logic_vector(2*m-1 downto 0));
	end component;
	
	component OutReg 
	--generic(m:INTEGER:=4);
	port(inpOutReg:in std_logic_vector(2*m-1 downto 0 );resetOutReg,clockOutReg,enableOutReg:in std_logic;
	outOutReg:out std_logic_VECTOR(2*m-1 downto 0));
	end component;
	--type arries_in22  is array (n-1 downto 0)of std_logic_vector(m-1 downto 0);
	signal sigoutra:arries_in2;
	signal sigoutmux2,sigoutmux1:std_logic_vector(m-1 downto 0 );
	signal sigoutmp:std_logic_vector(2*m-1 downto 0);
	signal sigoutadd,sigoutOutreg :std_logic_vector(2*m-1 downto 0);
	begin
	unitRA:RegArray   	 port map(inpra=>inputDP,clockra=>clockDP,resetra=>resetDP,enablera=>enableDPRegIn,outra=>sigoutra);
	unitMuxP2:MuxParam2  port map(inpmux2=>sigoutra,selmux2=>selDP,outmux2=>sigoutmux2);
	unitMuxP1:MuxParam1  port map(inpmux1=>cons,selmux1=>selDP,outmux1=>sigoutmux1);
	unitMul:Multiplier 	 port map(inmp1=>sigoutmux2,inmp2=>sigoutmux1,outmp=>sigoutmp);
	unitadd:Adder 		 port map(inadd1=>sigoutmp,inadd2=>sigoutOutReg,outadd=>sigoutadd);
	unitOutReg:OutReg    port map(inpOutReg=>sigoutadd,resetOutReg=>resetflushout,clockOutReg=>ClockDP,
									enableOutReg=>enableDPRegOut,outOutReg=>sigoutOutReg);
	outputDP<=sigoutOutReg;
end behavioral;





