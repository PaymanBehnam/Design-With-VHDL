library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;


entity TBnoc is
end TBnoc;



architecture TBnoc of TBnoc is
component total
	port(neighborfull,neighborack,neighborrequest:in std_logic_vector(4 downto 0);clock,mainreset:in std_logic;
	neighbordatain:in std_logic_vector(7 downto 0);mainaddress:in address;neighbordataout:out array2d;mainrequest:out std_logic_vector(4 downto 0));
end component;
	signal clock,mainreset:std_logic;
	signal neighborfull,neighborack,neighborrequest,mainrequest :std_logic_vector(4 downto 0);
	signal mainaddress:address;
	signal neighbordataout:array2d; 
	signal neighbordatain:std_logic_vector(7 downto 0);
	begin
unit:total port map(neighborfull=>neighborfull,neighborack=>neighborack,neighborrequest=>neighborack,clock=>clock,
mainreset=>mainreset,neighbordatain=>neighbordatain,mainaddress=>mainaddress,neighbordataout=>neighbordataout,mainrequest=>mainrequest);	
	
	 clock<=not clock after 100 ps when now<=1000 ps;
	 mainreset<='1','0' after 100 ps;
	 mainaddress.x<=0;
	 mainaddress.y<=0;
	 neighbordatain<="00010001","00010001" after 100 ps,"00010001" after 200 ps,"00011111" after 300 ps,"10010001" after 400 ps,
	 "10010001" after 500 ps,"00011111" after 600 ps,"10010001" after 700 ps;
	 neighborfull<="00000";
	 neighborack<="00001";
	 neighborrequest<="00001";


end TBnoc;
