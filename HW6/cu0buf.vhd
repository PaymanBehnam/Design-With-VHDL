	
library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity cu0buf is
port(request,full,clk:in std_logic;ack,push:out std_logic);
end cu0buf;
architecture cu0buf of cu0buf is
	type states is(mood1,mood2);
	signal current:states;
	begin	
	clock:process(clk)
	begin
	if (clk'event and clk='1') then
		case current is
			when mood1=>if (request='1' and full='0') then
								current<=mood2;
						else 
								current<=mood1;
						end if;
			when mood2 =>	current<=mood1;
						
			end case;
		  end if;
		end process;
	output:process(current)
			begin
			case current is
					when mood1=>
						ack<='0';
						push<='0';
					when mood2=>
						ack<='1';
						push<='1';
			end case;
			end process;
	end cu0buf;
