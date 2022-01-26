library ieee;
use ieee.std_logic_1164.all;
entity tb is
end entity;
architecture behavioral of tb is
	signal start,clock:std_logic;
	signal data,w:std_logic_vector(7 downto 0);
component DCS
	port(start,clock:in std_logic;data:in std_logic_vector(7 downto 0);w:out std_logic_vector(7 downto 0));
end component;
begin
	UDCS:DCS port map(start=>start,clock=>clock,data=>data,w=>w);
	--for add-start<='0','1'after 20 ns,'1'after 30 ns,'0'after 40 ns,'0' after 50 ns,'0' after 60 ns,'1'after 70 ns,'1'after 80 ns
	--,'1'after 90 ns;
	start<='0','1'after 20 ns,'0'after 30 ns,'1'after 40 ns,'0' after 50 ns,'0' after 60 ns,'1'after 70 ns,'1'after 80 ns
	,'1'after 90 ns;
	--for self start<='0','1'after 20 ns,'0'after 30 ns,'0'after 40 ns,'0' after 50 ns,'0' after 60 ns,'1'after 70 ns,'1'after 80 ns
	--,'1'after 90 ns;
	data<= "00000000","00000010" after 10 ns,"00000011" after 20 ns,"00000111" after 30 ns,"00001111" after 40 ns,"00000000" after 50 ns,
	"00000111" after 60 ns,"00001011" after 70 ns,"10000011" after 80 ns,"00000001" after 90 ns,
	"00100011" after 100 ns;
	clock<='1','0' after 5 ns ,'1' after 10 ns,'0' after 15 ns,'1' after 20 ns,'0' after 25 ns,'1' after 30 ns,
	'0' after 35 ns,'1' after 40 ns,'0' after 45 ns,'1' after 50 ns,'0' after 55 ns,'1' after 60 ns,'0' after 65 ns,'1' after 70 ns
	,'0' after 75 ns,'1' after 80 ns,'0' after 85 ns,'1' after 90 ns,'0' after 95 ns,'1' after 100 ns;
end; 																	
