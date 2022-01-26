library	ieee;
use ieee.std_logic_1164.all;
use work.my_pack.all;  
use ieee.std_logic_unsigned.all;
entity decoder is
	--generic(n:INTEGER:=4;logn:INTEGER:=2);
	port(input:IN std_logic_VECTOR(2 downto 0);enable:in std_logic;output:OUT std_logic_vector(4 downto 0));
end decoder;
architecture  behavioral of decoder is
begin
	process(enable,input)
	begin
		if enable = '0' then
			output <= (others => '0');
		else
		case input is
				when "000" => output <= "00001";
				when "001" => output <= "00010";
				when "010" => output <= "00100";
				when "011" => output <= "01000";
				when "100" => output <= "10000";
				when others=> output<="00000";
			end case;
		end if;
		end process;
end behavioral;
