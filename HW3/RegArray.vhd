library ieee;
use ieee.std_logic_1164.all;
use work.my_pack.all;
entity RegArray is
	--generic(n:Integer:=8);
	port(inpra:in std_logic_vector(m-1 downto 0);clockra,resetra,enablera:in std_logic;
	outra:out arries_in2);
end RegArray;
architecture behavioral of RegArray is
	component RegParam 
	--generic(m:INTEGER:=4);
	port(inprp:IN std_logic_VECTOR(m-1 downto 0 );resetrp,clockrp,enablerp:IN std_logic;outrp:OUT std_logic_VECTOR(m-1 downto 0));
	end component;
	--type arries_in2  is array (natural range<>)of std_logic_vector(m-1 downto 0);
	signal tempinout:arries_in2;
	begin
	lb:for i in 0 to n-1 generate
		lb0:if i=0 generate
		least_ra:RegParam port map(inprp=>inpra,resetrp=>resetra,clockrp=>clockra,enablerp=>enablera,outrp=>tempinout(0));
		end generate;
		lb1:if i=n-1 generate
		most_ra:RegParam port map(inprp=>tempinout(n-2),resetrp=>resetra,clockrp=>clockra,enablerp=>enablera,outrp=>tempinout(n-1));
		end generate;
		lb2:if i/=0 and i/=n-1 generate
		rest_ra:RegParam port map(inprp=>tempinout(i-1),resetrp=>resetra,clockrp=>clockra,enablerp=>enablera,outrp=>tempinout(i));
		end generate;
	end generate;
	outra<=tempinout;
	end behavioral;
		

