library ieee;
use ieee.std_logic_1164.all;
--use work.my_pack.all;
use ieee.std_logic_unsigned.all;
entity MyComprator is
	port(incmp1,incmp2:in std_logic_vector(7 downto 0);outcmp:out std_logic_vector(7 downto 0));
end entity;
architecture behavioral of MyComprator is
	begin
	outcmp<=incmp1 when incmp1 >= incmp2 else incmp2;
end behavioral;
