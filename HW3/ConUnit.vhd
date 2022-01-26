library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;
entity ConUnit is
	--generic(logn:Integer:=3);
	port(clockCU,input_enableCU,resetCU:in std_logic;enRegOutCU,enRegArrayCU,Output_EnableCU,flushout:Out std_logic;
	muxselCU:inout std_logic_vector(logn-1 downto 0));
end ConUnit;
architecture behavioral of ConUnit is
	type states is(res,idle,onset,calc,finish);
	signal current:states;
	begin	
	clk:process(clockCU)
	begin
	if (clockCU'event and clockCU='1') then
		case current is
			when res=>if (resetCU='1') then
								current<=res;
								muxselCU<=(0=>'0',others=>'0');
						else 
								current<=idle;
								muxselCU<=(0=>'0',others=>'0');
						end if;
			when idle =>if (resetCU='1') then
							current<=res;
							muxselCU<=(0=>'0',others=>'0');
						elsif(input_enableCU='0') then 
							current<=idle;
							muxselCU<=(0=>'0',others=>'0');
						else
							current<=onset;
							muxselCU<=(0=>'0',others=>'0');
						end if;
			when onset => if(resetCU='1') then
							current<=res;
							muxselCU<=(0=>'0',others=>'0');
						else 
							current<=calc;
							muxselCU<=(0=>'0',others=>'0');
						end if;
			when calc =>if (resetCU='1') then
								current<=res;
								muxselCU<=(0=>'0',others=>'0');
						elsif((conv_integer(muxselCU))< n-1) then
								current<=calc;
								muxselCU<=muxselCU+'1';
						else
							current<=finish;
							muxselCU<=muxselCU;
						end if;
			when finish =>if (resetCU='1') then
								current<=res;
								muxselCU<=(0=>'0',others=>'0') ;
						else 
								current<=idle;
								 muxselCU<=(0=>'0',others=>'0');
						end if;
			
			end case;
		  end if;
		end process;
	output:process(current)
			begin
			case current is
					when res=>
					     --muxselCU<=(0=>'0',others=>'0');
 						 enRegArrayCU<='0';
						 enRegOutCU<='0';
						 OutPut_EnableCU<='0';
          				flushout<='0';
					when idle=>
						 --muxselCU<=(0=>'0',others=>'0');
						 enRegArrayCU<='0';
						 enRegOutCU<='0';
						 OutPut_EnableCU<='0';
						flushout<='0';
					when onset=>
						 --muxselCU<=(0=>'0',others=>'0');
						 enRegArrayCU<='1';
						 enRegOutCU<='0';
						 OutPut_EnableCU<='0';
						flushout<='1';	
				when calc=>
						--muxselCU<=muxselCU+'1';
						enRegArrayCU<='0';
						enRegOutCU<='1';
						OutPut_EnableCU<='0';
						flushout<='0';	
				when finish=>
						--muxselCU<=muxselCU;
						enRegArrayCU<='0';
						enRegOutCU<='1';
						OutPut_EnableCU<='1';
						flushout<='0';
				end case;
			
			end process;
	end behavioral;

