library ieee;
use ieee.std_logic_1164.all;
entity DCS	is
	port(start,clock:in std_logic;data:in std_logic_vector(7 downto 0);w:out std_logic_vector(7 downto 0));
end entity;
architecture behavioral of DCS is
	component DPUnit 
		port(data:in std_logic_vector(7 downto 0);clock,Great,Add,Self:in std_logic;w:out std_logic_vector(7 downto 0));
	end component;
	component ConUnit 
		port(Clock,start:in std_logic;ConGreat,ConAdd,ConSelf:Out std_logic);
	end component;
	signal intcgreat,intcadd,intcself:std_logic;
	--signal w:std_logic_vector(7 downto 0);
	begin
		UCon:ConUnit port map(start=>start,clock=>clock,ConGreat=>intcgreat,ConAdd=>intcadd,ConSelf=>intcself);
		UDP:DPUnit   port map(data=>data,clock=>clock,Great=>intcgreat,Add=>intcadd,Self=>intcself,w=>w);
end behavioral;
