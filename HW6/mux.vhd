library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
entity mux is
	port(inpmux:in array2d;selmux:in integer;outmux:out std_logic_vector(7 downto 0));
end mux;
architecture mux of mux is
	begin
	process(inpmux,selmux)
	begin
		outmux<=inpMux(selmux);
	end process;
end ;
