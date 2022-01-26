library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
entity Flip_Flop is
	port(dff,resetff,clkff,enableff:IN std_logic;qff,qbarff:OUT std_logic);
end Flip_Flop;
architecture  behavioral of flip_flop is
	begin
	process(resetff,clkff)
	begin
		if(resetff='1')then
				qff<='0';
				qbarff<='1';
		elsif(clkff='0' and clkff'event and enableff='1') then
			qff <= dff;
			qbarff<=not dff;
		end if;
		
	end process;
end behavioral;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;

entity RegParam is
	--generic(n:Integer:=8);
	port(inprp:IN std_logic_VECTOR(m-1 downto 0 );resetrp,clockrp,enablerp:IN std_logic;outrp:OUT std_logic_VECTOR(m-1 downto 0));
end RegParam;
architecture behavioral of RegParam is
	component flip_flop 
		port(dff,resetff,clkff,enableff:IN std_logic;qff,qbarff:OUT std_logic);
	end component;
	signal Regclkrp:std_logic;
	begin
	--Regclkrp<=clockrp and enablerp;
	lb: for i in 0 to m-1 generate
	least_Reg:if i=0 generate
			least: flip_flop port map(inprp(i),resetrp,clockrp,enablerp,outrp(i));
	end generate;
	most_Reg:if i=m-1 generate
		most: flip_flop port map(inprp(i),resetrp,clockrp,enablerp,outrp(i));
	end generate;
	rest_Reg:if i/=0 and i/=m-1 generate
		rest:flip_flop  port map(inprp(i),resetrp,clockrp,enablerp,outrp(i));
	end generate;		
	end generate;
end behavioral;		
