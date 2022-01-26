library IEEE;
use IEEE.std_logic_1164.all;
use ieee.std_logic_arith;
use ieee.std_logic_unsigned;
entity tb is
end tb;  
architecture bahavioral of tb is
signal clk:STD_LOGIC;
signal load:STD_LOGIC;
signal serin:STD_LOGIC;
signal pardata:STD_LOGIC_VECTOR(7 downto 0);
component ShiftReg
  port (clk,load,serin: in STD_LOGIC;
        pardata: in STD_LOGIC_VECTOR (0 to 7);
        qout: buffer STD_LOGIC_VECTOR (0 to 7);
        serout:out STD_LOGIC);
end component;
begin
    U1:ShiftReg port map(clk=>clk,load=>Load,serin=>serin,pardata=>pardata);
        clock:process
                variable clock:STD_lOGIC:='0';
            begin
            clock:=not clock;
            clk<=clock;
            wait for 10 ps;
        end process;
        stimulus:process 
            variable x:integer:=128;
            begin
            Load<='0','1' after 20 ps;
            
            pardata<=conv_std_logic_vector(x,8);
            serin<='0';
            wait;
        end process;
    end;