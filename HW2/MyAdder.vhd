library ieee;
use ieee.std_logic_1164.all;
--use work.my_pack.all;
use ieee.std_logic_unsigned.all;
entity Myadder is
	port(inadd1,inadd2:in std_logic_vector(7 downto 0);outadd:out std_logic_vector(7 downto 0));
end entity;
architecture behavioral of Myadder is
	begin
	outadd<=inadd1+inadd2;
end behavioral;
