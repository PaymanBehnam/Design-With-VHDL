library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
entity Adder is
	--generic(m:INTEGER:=4);
	port(inadd1:in std_logic_vector(2*m-1 downto 0);inadd2:in std_logic_vector(2*m-1 downto 0);
	outadd:out std_logic_vector(2*m-1 downto 0));
end Adder;
architecture behavioral of Adder is
	begin
	outadd<=inadd1+inadd2;
end behavioral;