library ieee;
use ieee.std_logic_1164.all;
entity tbConUnit is
end entity;
architecture behavioral of tbConUnit is
	signal start,clock,ConGreat,ConAdd,ConSelf:std_logic;
	--signal data,w:std_logic_vector(7 downto 0);
component ConUnit 
	port(Clock,start:in std_logic;ConGreat,ConAdd,ConSelf:Out std_logic);
end component;

begin
	UConUnit:ConUnit port map(start=>start,clock=>clock,ConGreat=>ConGreat,ConAdd=>ConAdd,ConSelf=>ConSelf);
	start<='0','1'after 20 ns,'1'after 29 ns,'0'after 39 ns,'1' after 49 ns,'1' after 59 ns,'1' after 69 ns;
	--data<="00000000","00001001" after 10ns,"00001111" after 30ns,"00000001" after 40ns;
	clock<='1','0' after 5 ns ,'1' after 10 ns,'0' after 15 ns,'1' after 20 ns,'0' after 25 ns,'1' after 30 ns,
	'0' after 35 ns,'1' after 40 ns,'0' after 45 ns,'1' after 50 ns,'0' after 55 ns,'1' after 60 ns;
	
end; 
