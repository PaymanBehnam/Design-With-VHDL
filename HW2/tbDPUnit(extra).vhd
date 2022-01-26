library ieee;
use ieee.std_logic_1164.all;
entity tbDPU is
end entity;
architecture behavioral of tbDPU is
	signal Great,ADD,Self,clock:std_logic;
	signal data,w:std_logic_vector(7 downto 0);
	component DPUnit 
		port(data:in std_logic_vector(7 downto 0);clock,Great,Add,Self:in std_logic;w:out std_logic_vector(7 downto 0));
	end component;
	begin
    	UPunit:DPUnit port map(clock=>clock,data=>data,Great=>Great,Add=>Add,Self=>Self,w=>w);
		data<="00000000","00001001" after 10ns,"00001111" after 30ns,"00000001" after 40ns;
		clock<='1','0' after 5 ns ,'1' after 10 ns,'0' after 15 ns,'1' after 20 ns,'0' after 25 ns,'1' after 30 ns,
		'0' after 35 ns,'1' after 40 ns,'0' after 45 ns,'1' after 50 ns,'0' after 55 ns,'1' after 60 ns;
    	--Great<='0';
		--Self<='0';
		--Add<='1';
	end;    
