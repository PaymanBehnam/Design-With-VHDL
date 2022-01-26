library IEEE;
use IEEE.STD_LOGIC_1164.all;   
use ieee.std_logic_unsigned.all;



package my_pack is
		CONSTANT m:INTEGER:=8;
		CONSTANT n:INTEGER:=8;
		CONSTANT logn:INTEGER:=3;
		CONSTANT address_size : INTEGER := 1;		-- Address Size (Bytes)
		CONSTANT max_data_size : INTEGER := 35;		-- Max data size (Bytes)
		CONSTANT max_packet_size : INTEGER := 1 + address_size*2 + max_data_size;
		CONSTANT max_frame_size : INTEGER := 2 + max_packet_size;
		CONSTANT frame_start_byte : bit_vector := "00000000";
		CONSTANT frame_end_byte : bit_vector := "11111111";

		TYPE array2  is array (n-1 downto 0)of std_logic_vector(m-1 downto 0);
		TYPE array2d  is array (4 downto 0)of std_logic_vector(7 downto 0);
		TYPE bytes is array  (natural range <>) of std_logic;
		TYPE address IS RECORD
			x : INTEGER;
			y : INTEGER;
		END RECORD;
		
		TYPE packet IS RECORD
			size : INTEGER;			-- Packet Size (Bytes)
			dst_addr : address;
			src_addr : address;
			data : bytes( 1 TO max_data_size );
	    END RECORD;
	   FUNCTION create_address( x, y : INTEGER ) RETURN address; 
	   FUNCTION create_packet( dst_addr, src_addr : address; data : bytes ) RETURN packet;
	   FUNCTION FindOutputInterface( a : address ;my_address:address) RETURN integer ;
	
		
	   END PAckage my_pack;
	  
	   
	   package body	 my_pack is
		   FUNCTION create_address( x, y : INTEGER ) RETURN address IS
				VARIABLE a : address;
				BEGIN
				a.x := x;
				a.y := y;
				RETURN a;
			END create_address;
		   FUNCTION create_packet( dst_addr, src_addr : address; data : bytes ) RETURN packet IS
			VARIABLE p : packet;
				BEGIN
				p.size := 1 + 2 * address_size + data'LENGTH;
				p.dst_addr := dst_addr;
				p.src_addr := src_addr;
				p.data( 1 TO data'LENGTH ) := data;
				RETURN p;
			END create_packet; 
			-- IF 1)	UPPER LEFT (Myself)
		-- IF 2)	UP
		-- IF 3)	DOWN
		-- IF 4)	RIGHT
		-- IF 5)	LEFT
		-- IF = -1:	Illegal Output
		
		FUNCTION FindOutputInterface( a : address;my_address: address ) RETURN integer IS
	
			VARIABLE selection : integer;
		
		BEGIN
	
		IF ( a.x = my_address.x AND a.y = my_address.y ) THEN
			selection := 1;	-- Myself (Upper Left)
		ELSIF ( a.x > my_address.x ) then --and a.y >= my_address.y) THEN
			selection := 4;	-- Right
		ELSIF ( a.x < my_address.x) then -- and a.y >= my_address.y) THEN
			selection := 5;	-- Left
		elsIF ( a.y > my_address.y ) THEN
			selection := 2;	-- Up		 						  
		ELSIF ( a.y < my_address.y ) THEN
			selection := 3;	-- Down
		end if;
	
		RETURN selection;
	END FindOutputInterface;
end my_pack;
