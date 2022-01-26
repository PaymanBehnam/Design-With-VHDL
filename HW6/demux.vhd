library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
entity demux is
	port(inpdemux:in std_logic_vector(7 downto 0);seldemux:in integer;outdemux:out array2d);
end demux;
architecture demux of demux is
	begin
	process(inpdemux,seldemux)
	begin
		outdemux(seldemux)<=inpdemux;
	end process;
end ;
