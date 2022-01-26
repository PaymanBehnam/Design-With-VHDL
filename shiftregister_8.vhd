library IEEE;
use IEEE.std_logic_1164.all;
use ieee.sts_logic_arith;
entity ShiftReg is
    port (
        clk,load,serin: in STD_LOGIC;
        pardata: in STD_LOGIC_VECTOR (0 to 7);
        qout: buffer STD_LOGIC_VECTOR (0 to 7);
        serout:out STD_LOGIC);
end shiftReg;
architecture bahavioral of ShiftReg is
begin
    process(clk)
      variable count:Integer range 0 to 8;
      begin
       if load='0' then
       qout<=pardata;
       count:=0;
       elsif(clk'event and clk='1' and count<7) then
       count:=count+1;
       serout<=qout(7);
       qout<=qout(0 to 6) & serin;
       end if;
    end process;   
end bahavioral;