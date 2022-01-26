library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use work.my_pack.all;

entity total is
	port(neighborfull,neighborack,neighborrequest:in std_logic_vector(4 downto 0);clock,mainreset:in std_logic;
	neighbordatain:in std_logic_vector(7 downto 0);mainaddress:in address;neighbordataout:out array2d;mainrequest:out std_logic_vector(4 downto 0));
	
end total;

architecture total of total is
 component cu0buf 		  
	port(request,full,clk:in std_logic;ack,push:out std_logic);
 end component;
 component cu1buff   
port(push,pop,reset,clk:in std_logic;datain:in std_logic_vector(7 downto 0);
	isempty,full:out std_logic;dataout:inout std_logic_vector(7 downto 0));
end component;
component mux 
	port(inpmux:in array2d;selmux:in integer;outmux:out std_logic_vector(7 downto 0));
end component;
component decoder 
	--generic(n:INTEGER:=4;logn:INTEGER:=2);
	port(input:IN std_logic_VECTOR(2 downto 0);enable:in std_logic;output:OUT std_logic_vector(4 downto 0));
end component;
component demux 
	port(inpdemux:in std_logic_vector(7 downto 0);seldemux:in integer;outdemux:out array2d);
end component;	
component router 
port(full,ack: in std_logic;isempty:in std_logic_vector(4 downto 0);myaddress:in address;enable :out std_logic;
request:out std_logic_vector(4 downto 0);clk:in std_logic;chooserin,selector:inout integer;dataout:inout std_logic_vector(7 downto 0));
end component;

component mux5_1 
	port(inpmux:in std_logic_vector(4 downto 0);selmux:in integer;outmux:out std_logic);
end component;

signal impush1,impush2,impush3,impush4,impush5,impop1,impop2,impop3,impop4,impop5,imfull,imfull1,imfull2,imfull3,imfull4,imfull5,
imisempty1,imisempty2,imisempty3,imisempty4,imisempty5,imenable,imack:std_logic;
signal immuxout,imdataout1,imdataout2,imdataout3,imdataout4,imdataout5:std_logic_vector(7 downto 0);
signal imchooserin,imsel:integer;
signal tmpchooserin:std_logic_vector(2 downto 0);
signal imdataout:array2d;
signal impop,imisempty:std_logic_vector(4 downto 0);
begin
	unit1cu0buf: cu0buf port map(request=>neighborrequest(0),full=>imfull1,clk=>clock,push=>impush1);
	unit2cu0buf: cu0buf port map(request=>neighborrequest(1),full=>imfull2,clk=>clock,push=>impush2);
	unit3cu0buf: cu0buf port map(request=>neighborrequest(2),full=>imfull3,clk=>clock,push=>impush3);
	unit4cu0buf: cu0buf port map(request=>neighborrequest(3),full=>imfull4,clk=>clock,push=>impush4);
	unit5cu0buf: cu0buf port map(request=>neighborrequest(4),full=>imfull5,clk=>clock,push=>impush5);
	
	unit1cu1buf: cu1buff port map(push=>impush1,pop=>impop1,reset=>mainreset,clk=>clock,datain=>neighbordatain,
	isempty=>imisempty1,full=>imfull1,dataout=>imdataout1);
	unit2cu1buf: cu1buff port map(push=>impush2,pop=>impop2,reset=>mainreset,clk=>clock,datain=>neighbordatain,
	isempty=>imisempty2,full=>imfull2,dataout=>imdataout2);
	unit3cu1buf: cu1buff port map(push=>impush3,pop=>impop3,reset=>mainreset,clk=>clock,datain=>neighbordatain,
	isempty=>imisempty3,full=>imfull3,dataout=>imdataout3);
	unit4cu1buf: cu1buff port map(push=>impush4,pop=>impop4,reset=>mainreset,clk=>clock,datain=>neighbordatain,
	isempty=>imisempty4,full=>imfull4,dataout=>imdataout4);
	unit5cu1buf: cu1buff port map(push=>impush5,pop=>impop5,reset=>mainreset,clk=>clock,datain=>neighbordatain,
	isempty=>imisempty5,full=>imfull5,dataout=>imdataout5);
	
	
	
	--unitrouter:router port map(isempty=>(imisempty5,imisempty4,imisempty3,imisempty2,imisempty1),full=>imfull, selector=>imsel,
	--clk=>clock,chooserin=>imchooser);
	
	unitmux:mux port map(inpmux=>imdataout,outmux=>immuxout,selmux=>imchooserin);   
	unitdemuxdataout:demux port map(inpdemux=>immuxout,seldemux=>imsel,outdemux=>neighbordataout);
	tmpchooserin<=conv_std_logic_vector(imchooserin,3);
	unitdecoder:decoder port map(input=>tmpchooserin,output=>impop,enable=>imenable);
	
	unitmuxfull:mux5_1 port map(inpmux=>neighborfull,selmux=>imsel,
	outmux=>imfull); 
	unitmuxack :mux5_1 port map(inpmux=>neighborack,selmux=>imsel,
	outmux=>imack); 
	--unitmuxisempty:mux5_1 port map(inpmux=>(imisempty5,imisempty4,imisempty3,imisempty2,imisempty1),selmux=>imchooser,outmux=>imisempty)
	unitrouter:router port map(full=>imfull,ack=>imack,isempty=>imisempty,
	myaddress=>mainaddress,enable=>imenable,
	request=>mainrequest,
	clk=>clock,chooserin=>imchooserin,selector=>imsel,dataout=>immuxout);

	  
end total;
