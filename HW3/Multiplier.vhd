library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
entity Multiplier is
	--generic(m:INTEGER:=4);
	port(inmp1:in std_logic_vector(m-1 downto 0);inmp2:in std_logic_vector(m-1 downto 0);outmp:out std_logic_vector(2*m-1 downto 0));
end Multiplier;
architecture behavioral of Multiplier is
	begin
	outmp<=inmp1*inmp2;
end behavioral;