library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.all;
use work.my_pack.all;
entity MuxParam1 is
	--generic(logn:INTEGER:=3);
	port(inpMux1:IN arries_in2;selmux1:IN std_logic_vector(logn-1 downto 0);outMux1:out std_logic_vector(m-1 downto 0));
end MuxParam1;
architecture behavioral of MuxParam1 is
	begin
	process(inpMux1,selmux1)
	begin
		outMux1<=inpMux1(conv_integer(selmux1));
	end process;
end behavioral;
