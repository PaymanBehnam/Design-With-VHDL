library ieee;
use ieee.std_logic_1164.all;

ENTITY tb_fifo_Uncons IS
END ENTITY ;

architecture tb_fifo_Uncons of tb_fifo_Uncons is

component fifo_access IS
  PORT (data_in : IN std_logic_vector;
        clk : IN std_logic;
        rst, rd, wr : IN std_logic;
        empty, full : OUT std_logic;
        data_out : OUT std_logic_vector);
end component;

signal data_in,data_out : std_logic_vector(3 downto 0);
signal        clk : std_logic := '1';
signal        rst, rd, wr : std_logic;
signal        empty, full : std_logic;
         

begin
    unit:fifo_access PORT map(data_in,clk,rst, rd, wr,empty, full,data_out);
  
     clk <= not clk after 10 ps;
     rst <= '1','0' after 20 ps;
     wr <= '0','1' after 20 ps,'0' after 160 ps;
     rd<='0','1' after 40 ps,'0' after 60 ps,'1' after 160 ps;
     data_in<="0001" ,"1001" after 20 ps,"0010" after 40 ps,"0011" after 60 ps,"0100" after 80 ps,"0101" after 100 ps,
     "0110" after 120 ps,"1111" after 140 ps; 
      
end ;
