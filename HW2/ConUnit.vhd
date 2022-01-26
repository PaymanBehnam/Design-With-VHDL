library ieee;
use ieee.std_logic_1164.all;
entity ConUnit is
	port(Clock,start:in std_logic;ConGreat,ConAdd,ConSelf:Out std_logic);
end ConUnit;
architecture behavioral of ConUnit is
	type states is(init,onset,middle1,middle2,greatstate,addstate,selfstate,e0,e1,failurestate);
	signal current:states;
	begin	
	clk:process(clock)
	begin
	if (clock'event and clock='1') then
		case current is
			when init =>if (start='0') then
							current<=init;
							ConGreat<='0';
							ConAdd<='0';
							ConSelf<='0';
						else 
							current<=onset;
							ConGreat<='0';
							ConAdd<='0';
							ConSelf<='0';
						end if;
			when onset =>if (start='0') then
							current<=middle1;
						else 
							current<=middle2;
						end if;
			when middle1 =>if (start='0') then
								current<=selfstate;
								ConGreat<='0';
								ConAdd<='0';
								ConSelf<='1';
							else 
								current<=greatstate;
								ConGreat<='1';
								ConAdd<='0';
								ConSelf<='0';
							end if;
			when middle2 =>if (start='0') then
								current<=addstate;
								ConGreat<='0';
								ConAdd<='1';
								ConSelf<='0';
							else 
								current<=middle2;
							end if;
			when selfstate=>if (start='0') then
								current<=selfstate;
								ConGreat<='0';
								ConAdd<='0';
								ConSelf<='1';
							else 
								current<=e0;
							end if;
			when greatstate=>if (start='0') then
								current<=greatstate;
							    ConGreat<='1';
								ConAdd<='0';
								ConSelf<='0';
							else 
								current<=e0;
							end if;
			when addstate=>if (start='0') then
								current<=addstate;
								ConGreat<='0';
								ConAdd<='1';
								ConSelf<='0';
							else 
								current<=e0;
							end if;
			when e0=>if (start='0') then
								current<=failurestate;
								ConGreat<='0';
								ConAdd<='0';
								ConSelf<='0';
							else 
								current<=e1;
							end if;
			when e1=>if (start='0') then
								current<=failurestate;
								ConGreat<='0';
								ConAdd<='0';
								ConSelf<='0';
							else 
								current<=init;
								ConGreat<='0';
								ConAdd<='0';
								ConSelf<='0';
							end if;
				when failurestate=>if (start='0') then
								current<=failurestate;
								ConGreat<='0';
								ConAdd<='0';
								ConSelf<='0';
							else 
								current<=failurestate;
								ConGreat<='0';
								ConAdd<='0';
								ConSelf<='0';
								end if;
			end case;
		end if;
	end process;
end behavioral;
			