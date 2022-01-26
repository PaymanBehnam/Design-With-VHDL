library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;

entity cu1buff is  
	port(push,pop,reset,clk:in std_logic;datain:in std_logic_vector(7 downto 0);
	isempty,full:out std_logic;dataout:inout std_logic_vector(7 downto 0));
end cu1buff;

architecture cu1buff of cu1buff is
	signal buf: array2;
	type states is(waitst,pushst,popst,pushpopst,resst);
	signal current:states;
	begin	
	clock:process(clk)
	begin
	if (clk'event and clk='1') then
		case current is
			when waitst=>if (push='1' and pop='0'   and reset='0') then
								current<=pushst;
						elsif (push='0' and pop='1' and reset='0') then
								current<=popst;
						elsif (push='0' and pop='0' and reset='1') then
								current<=resst;
			         	elsif (push='1' and pop='1' and reset='0') then
							 current<=pushpopst;
						else 
							current<=waitst;
						end if;
			when pushst => If(reset='1') then	
								current<=resst;
							else
							   current<= waitst;
							end if;
			when popst =>If(reset='1') then	
								current<=resst;
							else
							   current<= waitst;
							 end if;
			when pushpopst =>	If(reset='1') then	
									current<=resst;
								else
							   		current<= waitst;
								end if;
			when resst =>if( reset='0') then
							current<=waitst;
						else
							current<=resst;
						end if;
		  	end case;
		end if;
	end process;
	output:process(current)
		variable tail,head:std_logic_vector(n-1 downto  0):=(others=>'0');
		begin
			case current is
			when pushst=>
						buf(conv_integer(tail))<=datain;
						tail:=tail+1;
						if buf(conv_integer(head))=buf(conv_integer(tail)) then
							isempty<='1'; 
						end if;
						if buf(conv_integer(tail+1))=buf(conv_integer(head)) then
							full<='1';
						end if;
			when popst=>
						
						dataout<=buf(conv_integer(head));
						head:=head+1;
						if buf(conv_integer(head))=buf(conv_integer(tail))then
							isempty<='1';
						end if;
						if buf(conv_integer(tail+1))=buf(conv_integer(head)) then
							full<='1';
						end if;
			when pushpopst=>
						buf(conv_integer(tail))<=datain;
						tail:=tail+1;
						dataout<=buf(conv_integer(head));
						head:=head+1;
						if buf(conv_integer(head))=buf(conv_integer(tail)) then
							isempty<='1';
						end if;
						if buf(conv_integer(tail))=buf(conv_integer(tail)) then
							full<='1';
						end if;
			when resst=>
					head:=(others=>'0');
					tail:=(others=>'0');
						if buf(conv_integer(tail))=buf(conv_integer(tail)) then
							isempty<='1';
						end if;
						if buf(conv_integer(tail+1))=buf(conv_integer(head)) then
							full<='1';
						end if;
			when waitst=>
					null ;
			
			end case;
			end process;
end cu1buff;
