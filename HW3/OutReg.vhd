library ieee;
use ieee.std_logic_1164.all;
use work.my_pack.all;
entity OutReg is
	--generic(m:INTEGER:=4);
	port(inpOutReg:in std_logic_vector(2*m-1 downto 0 );resetOutReg,clockOutReg,enableOutReg:in std_logic;
	outOutReg:out std_logic_VECTOR(2*m-1 downto 0));
end OutReg;
architecture behavioral of OutReg is
	signal clkOutReg:std_logic;
	begin
	--clkOutReg<=clockOutReg and enableOutReg;
	process(resetOutReg,clockOutReg)
	begin
		if(resetOutReg='1')then
				outOutReg<=(0=>'0',others=>'0');
		elsif (clockOutReg='1' and enableOutReg='1' and clockOutReg'event) then
				outOutReg <= inpOutReg;
		end if;
	end process;
end behavioral;

	
		
