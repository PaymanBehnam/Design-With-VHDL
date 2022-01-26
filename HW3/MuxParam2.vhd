library ieee;
use ieee.std_logic_1164.all;
use work.all;
package my_pack is
		constant m:INTEGER:=5;
		constant n:INTEGER:=4;
		constant logn:INTEGER:=3;
		--generic(m:Integer:=4;n:Integer:=4;logn:integer:=2);
		type arries_in2  is array (n-1 downto 0)of std_logic_vector(m-1 downto 0);
		--type arries_in1  is array (integer range<> )of std_logic;
		--type arries_in2  is array ()of std_logic_vector(m-1 downto 0);
		--type arries_in1  is array (n-1 downto 0)of Integer;
		function bin2int (bin:IN BIT_VECTOR )return INTEGER ;
	  end;
		package body my_pack is 
		function bin2int(bin:IN BIT_VECTOR )return INTEGER is
		variable result: INTEGER;
		begin
			result:= 0;
			for i in bin'range loop
				if bin(i) = '1' then
				result := result + 2**i;
				end if;
			  end loop;
			return result;
		END bin2int;
end my_pack;
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_pack.all;
entity MuxParam2 is
	--generic(n:INTEGER:=8;logn:INTEGER:=3);
	port(inpmux2:IN arries_in2;selmux2:IN std_logic_vector(logn-1 downto 0);outmux2:out std_logic_vector(m-1 downto 0));
end MuxParam2;
architecture behavioral of MuxParam2 is
	--type arries_in2  is array (n-1 downto 0)of std_logic_vector(m-1 downto 0);
	begin
	process(inpmux2,selmux2)
	--variable tempoutmux1:std_logic_vector(3 downto 0);
	--variable tempoutmux2:integer;
	begin
			  outmux2<=inpmux2(conv_integer(selmux2));
		--tempoutmux2:=conv_integer(tempoutmux1,4);
		--outmux2<=conv_std_logic_vector(tempoutmux2,4);
	end process;
end behavioral;
