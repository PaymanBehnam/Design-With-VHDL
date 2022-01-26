library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
entity tbHW3 is end entity;
architecture behavioral of tbHW3 is 
	component FIR_top
	--generic(logn:integer:=3);
	PORT(clock,reset,input_enable: in STD_LOGIC;FIR_input: in STD_LOGIC_vector (m-1 DOWNTO 0);
		coefficient:in arries_in2;output_enable:Out std_logic;FIR_output:out STD_LOGIC_vector(2*m-1 DOWNTO 0));
	end component;
    signal clock,reset,input_enable:STD_LOGIC:='0';
	signal FIR_input,FIR_input2:STD_LOGIC_vector (m-1 DOWNTO 0);
	signal coefficient:arries_in2;
	signal output_enable:std_logic;
	signal FIR_output,FIR_output2:STD_LOGIC_vector(2*m-1 DOWNTO 0);
	begin
	--UtbHW3: FIR_top port map (clock=>clock,reset=>reset,input_enable=>input_enable,
			--					FIR_input=>FIR_input,coefficient=>coefficient,output_enable=>output_enable,
			--FIR_output=>FIR_Output);	
			Utb2HW3: FIR_top  port map (clock=>clock,reset=>reset,input_enable=>input_enable,
								FIR_input=>FIR_input2,coefficient=>coefficient,output_enable=>output_enable,
								FIR_output=>FIR_Output2);
	
			clock<=not clock after 10 ps when now<=1000 ps;
			reset<='1','0' after 30 ps; 
			input_enable<='0','1' after 40 ps,'0' after 60 ps,'1' after 210 ps,'0' after 270 ps,'1' after 350 ps,'0' after 400 ps;
			--FIR_input<="0110", "1001" after 200 ps,"1111" after 330 ps;
			FIR_input2<="01110", "10101" after 200 ps,"11011" after 330 ps,"01010" after 350 ps;
			coefficient<=("00001","01011","00111","00101");
		end;
			