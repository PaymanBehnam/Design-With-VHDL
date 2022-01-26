library ieee;
use ieee.std_logic_1164.all;
--use work.my_pack.all;
use ieee.std_logic_unsigned.all;
entity DPUnit is
	port(data:in std_logic_vector(7 downto 0);clock,Great,Add,Self:in std_logic;w:out std_logic_vector(7 downto 0));
end entity;
architecture behavioral of DPUnit is
	component MyReg 
		port(inreg:in std_logic_vector(7 downto 0);clk,enable:in std_logic;outreg:out std_logic_vector(7 downto 0));
	end component;
	component MyComprator
	port(incmp1,incmp2:in std_logic_vector(7 downto 0);outcmp:out std_logic_vector(7 downto 0));
	end component;
	component Myadder 
	port(inadd1,inadd2:in std_logic_vector(7 downto 0);outadd:out std_logic_vector(7 downto 0));
	end component;
	component MyMux 
		port(inmux1,inmux2,inmux3:in std_logic_vector(7 downto 0);G,A,s:in std_logic;outmux:out std_logic_vector(7 downto 0));
	end component;
	signal Soutreg,Soutcmp,Soutadd,Soutmux:std_logic_vector(7 downto 0);
	begin
	UReg:MyReg port map(inreg=>Soutmux,clk=>clock,enable=>'1',outreg=>Soutreg);
	UCmp:MyComprator port map(incmp1=>data,incmp2=>Soutreg,outcmp=>Soutcmp);
	UAdd:Myadder port map(inadd1=>data,inadd2=>Soutreg,outadd=>Soutadd);
	UMux:Mymux port map(inmux1=>Soutcmp,inmux2=>Soutadd,inmux3=>data,G=>Great,A=>Add,S=>Self,outmux=>Soutmux);
	w<=Soutmux;
	end behavioral;
	

		