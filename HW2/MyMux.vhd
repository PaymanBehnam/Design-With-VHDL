library ieee;
use ieee.std_logic_1164.all;
--use work.my_pack.all;
use ieee.std_logic_unsigned.all;
entity MyMux is
	port(inmux1,inmux2,inmux3:in std_logic_vector(7 downto 0);G,A,s:in std_logic;outmux:out std_logic_vector(7 downto 0));
end entity;
architecture behavioral of MyMux is
	begin
	outmux<=inmux1 when (G='1' and A='0' and S='0') else inmux2 when (G='0' and A='1' and S='0') else inmux3 when (G='0' and A='0' and S='1') else "00000000";
end behavioral;
