library ieee;
use ieee.std_logic_1164.all;
--use work.my_pack.all;
entity MyReg is
	port(inreg:in std_logic_vector(7 downto 0);clk,enable:in std_logic;outreg:out std_logic_vector(7 downto 0));
end entity;
architecture  behavioral of MyReg is
	begin
	process(clk)
	begin
		if(clk='1' and clk'event and enable='1') then
			outreg<=inreg;
		end if;
	end process;
	end behavioral;
