LIBRARY IEEE; USE IEEE.std_logic_1164.ALL;  USE IEEE.std_logic_unsigned.ALL;  

ENTITY memory2 IS
	GENERIC (blocksize : integer := 4096; segmentsno : integer := 64);
	PORT (
		clk : in std_logic;
		addressbus : IN  STD_LOGIC_VECTOR (11 DOWNTO 0);
		databus : inOUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		readmem : in std_logic;
		WriteMem : in std_logic;
		memdataready : OUT std_logic
		);
END memory2;


ARCHITECTURE behavioral OF memory2 IS
	signal data :STD_LOGIC_VECTOR (15 DOWNTO 0);
	TYPE mem_TYPE IS ARRAY (0 TO blocksize-1) OF STD_LOGIC_VECTOR (15 DOWNTO 0);   --Data TYPE for a seqment OF memory
	signal mem_array : mem_TYPE:= (	others => (others => '0'));
	
	
BEGIN
	memdataready <= '1';
	databus <= data when readmem='1' else (others => 'Z');
	
	process	(clk)
	begin
		if (WriteMem='1') and (clk='1' and clk'event) then
			mem_array (conv_integer (addressbus)) <=  databus;
		end if;
	end process;
	
	
	process	(addressbus, ReadMem)
	begin
		if (ReadMem='1') then
			data <= mem_array (conv_integer (addressbus));
		end if;
	end process;
	
END behavioral;
