library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
entity mux5_1 is
	port(inpmux:in std_logic_vector(4 downto 0);selmux:in integer;outmux:out std_logic);
end mux5_1;
architecture mux5_1 of mux5_1 is
	begin
	process(inpmux,selmux)
	begin
		outmux<=inpMux(selmux);
	end process;
end ;
