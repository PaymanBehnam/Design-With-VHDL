library IEEE;
use IEEE.STD_LOGIC_1164.all;  
use ieee.std_logic_unsigned.all;
use work.my_pack.all;


entity router is
port(full,ack: in std_logic;isempty:in std_logic_vector(4 downto 0);myaddress:in address;enable :out std_logic;
request:out std_logic_vector(4 downto 0);clk:in std_logic;chooserin,selector:inout integer;dataout:inout std_logic_vector(7 downto 0));
end router;

architecture router of router is
	type states is(readyst,readheadst,readdatast,remainderst);
	signal current:states;
	signal addheader:address;
	begin	
	clock:process(clk)
	variable cnt1,cnt2:integer:=0;
	begin
	if (clk'event and clk='1') then
		case current is
			when readyst=>
				if isempty(cnt1)='0' then
					current<=readheadst;
					chooserin<=cnt1;
					--request<=(chooserin=>'1',others=>'0');
					cnt1:=0;
				else 
					current<=readyst;  
				 	cnt1:=cnt1+1;
				end if;
			
			when readheadst=> 
			if (ack='1' and full='0')then
				current<=readdatast; 
			end if;
			when readdatast=>
			if((cnt2< 7) and (isempty(chooserin)='0')and (ack='1') and (full='0')) then
				cnt2:=cnt2+1;
				current<=readdatast;
				--dataoutrouter <=buf(cnt);	
			elsif(isempty(chooserin)='1') then
				current<=remainderst;
			elsif (cnt2=7) then
				cnt2:=0; 
				current<=readyst ;
			end if;
			when remainderst=>
				if (isempty(chooserin)='1') then 
					current<=remainderst;
				else
					current<=readdatast;
				end if;
		
		end case;
	   end if;
	   end process;
	   output:process(current)
		begin
			case current is
			when readyst=> 
				enable<='0';
				request<=(others=>'0');
			when readheadst=>
			enable<='1';
			case chooserin is
				when 0 => request <= "00001";
				when 1 => request <= "00010";
				when 2 => request <= "00100";
				when 3 => request <= "01000";
				when 4 => request <= "10000";
				when others=> request  <="00000";
			  end case;
			
			addheader.x<=conv_integer(dataout(3 downto 0));
			addheader.y<=conv_integer(dataout(7 downto 4));
			selector<= FindOutputInterface(addheader,myaddress );
			when readdatast=>
				enable<='1';
			case chooserin is
				when 0 => request <= "00001";
				when 1 => request <= "00010";
				when 2 => request <= "00100";
				when 3 => request <= "01000";
				when 4 => request <= "10000";
				when others=> request  <="00000";
			  end case;
			when remainderst=>
				enable<='1';
			case chooserin is
				when 0 => request <= "00001";
				when 1 => request <= "00010";
				when 2 => request <= "00100";
				when 3 => request <= "01000";
				when 4 => request <= "10000";
				when others=> request  <="00000";
			end case;
		
			end case;
			end process output;
end router;
