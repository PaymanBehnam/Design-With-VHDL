library ieee;
use ieee.std_logic_1164.all; 
use ieee.std_logic_unsigned.all;

ENTITY fifo_access IS
  PORT (data_in : IN std_logic_vector;
        clk : IN std_logic;
        rst, rd, wr : IN std_logic;
        empty, full : OUT std_logic;
        data_out : OUT std_logic_vector);
END ENTITY ;

ARCHITECTURE procedural OF fifo_access IS
  TYPE lklist;
  TYPE pointertolklist IS ACCESS lklist;
  TYPE lklist IS RECORD
    data : std_logic;
    link : pointertolklist;
  END RECORD;

  TYPE fifo_element;
  TYPE pointer IS ACCESS fifo_element;
  TYPE fifo_element IS RECORD
    data : pointertolklist;
    link : pointer;
  END RECORD;
  
  SHARED VARIABLE head, tail : pointer := NULL;
  SHARED VARIABLE headlklist, taillklist,headrd : pointertolklist := NULL;
  SHARED VARIABLE fifo_cnt : INTEGER ;
  SIGNAL full_temp, empty_temp : std_logic;
  signal cntlklist : integer:= 0;
  

PROCEDURE write_fifo(VARIABLE head, tail : INOUT pointer;VARIABLE datain : in pointertolklist) IS
  BEGIN
    IF (head=NULL) THEN
      head := NEW fifo_element;
      head.data := datain; head.link := NULL;
      tail := head;
      fifo_cnt := 1;
    ELSE
      tail.link := NEW fifo_element;
      tail := tail.link; tail.data := datain;
      tail.link := NULL;
    END IF;
    fifo_cnt := fifo_cnt+1;
    REPORT "FIFO SIZE : "&INTEGER'IMAGE(fifo_cnt);
END write_fifo;


  PROCEDURE read_fifo (VARIABLE head, tail : INOUT pointer;VARIABLE headrd:OUT pointertolklist) IS
    BEGIN
      IF (head=NULL) THEN REPORT "FIFO IS EMPTY!";
      ELSIF (head=tail) THEN
          REPORT "HEAD=TAIL CASE";
          headrd := head.data;
          head := NULL; tail := NULL;
          fifo_cnt := 0;
      ELSE
          REPORT "ELSE CASE";
          headrd := head.data;
          head := head.link;
          fifo_cnt := fifo_cnt - 1;
      END iF;
      REPORT "FIFO SIZE: "&Integer'Image(fifo_cnt);
    END read_fifo;

  PROCEDURE convdataintouncons (VARIABLE headrd : INOUT pointertolklist;signal data_out:OUT std_logic_vector) IS
    BEGIN
      if(headrd /= null)then
        for i in data_out'range loop       
          if(headrd /= null)then
            data_out(i) <= headrd.data;
            headrd := headrd.link;
          else exit;
          end if;
        end loop;
      end if;
    END convdataintouncons;


PROCEDURE convunconsttodata(VARIABLE headlklist, taillklist : INOUT pointertolklist;signal data_in : IN std_logic_vector) IS
  BEGIN
    for i in data_in'range loop
      IF (headlklist = NULL) THEN
         headlklist := NEW lklist;
         headlklist.data := data_in(i); headlklist.link := NULL;
         taillklist := headlklist;
      else
         taillklist.link := NEW lklist;
         taillklist := taillklist.link; taillklist.data := data_in(i);
         taillklist.link := NULL;
     END IF;
  end loop;
END convunconsttodata;

    
BEGIN

read: PROCESS (clk) BEGIN
  IF (clk='1' AND clk'EVENT) THEN
      IF rst='1' THEN
        fifo_cnt := 0;
      ELSE
      
        IF (rd='1' AND empty_temp='0') THEN
          read_fifo(head, tail, headrd);
          convdataintouncons(headrd,data_out);
        ELSIF (rd='1' AND wr='1' AND empty_temp='1')THEN
          read_fifo(head, tail, headrd);
          convdataintouncons(headrd,data_out);
        END IF;
      END IF;
      IF fifo_cnt=0 THEN empty_temp <= '1';
      ELSE empty_temp <= '0'; END IF;
    END IF;
END PROCESS;
write : PROCESS (clk) BEGIN
       
        IF (clk='1' AND clk'EVENT) THEN
            IF rst='1' THEN
              fifo_cnt := 0;
              headlklist := NULL;
            ELSE
               
            IF (wr='1' AND full_temp='0' ) THEN
                headlklist := NULL;
                convunconsttodata(headlklist, taillklist, data_in);
                write_fifo(head, tail,headlklist );
            ELSIF (wr='1' AND rd='1') THEN
                headlklist := NULL;
                convunconsttodata(headlklist, taillklist,data_in);
                write_fifo(head, tail, headlklist);
            END IF;
        END IF;
      END IF;
END PROCESS;

    cntlklist<= 0 when (rst = '1' and clk = '1' and clk'event) else cntlklist+1 when (wr = '1' and clk = '1' and rd = '0' and clk'event and full_temp = '0') else cntlklist-1 when (wr = '0'and rd = '1' and clk = '1' and clk'event)else cntlklist;
    full_temp <='1' when(cntlklist = 3) else '0';
    empty <= empty_temp;
    full <= full_temp;
    
   end procedural;

