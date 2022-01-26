------ Controller

LIBRARY IEEE; USE IEEE.std_logic_1164.ALL; USE IEEE.std_logic_unsigned.ALL;

ENTITY controller IS
	PORT (ExternalReset, clk : IN std_logic;
		ResetPC, PCplusI, PCplus1, RplusI, Rplus0, Rs_on_AddressUnitRSide, Rd_on_AddressUnitRSide,
		EnablePC, B15to0,
		AaddB, AsubB, AmulB, AcmpB, RFLwrite,
		RFHwrite, WPreset, WPadd, IRload, SRload, Address_on_Databus, ALU_on_Databus, IR_on_LOpndBus,
		IR_on_HOpndBus, RFright_on_OpndBus, ReadMem, WriteMem,  
		Cset, Creset, Zset, Zreset, Shadow : OUT std_logic;
		Instruction : IN std_logic_vector (7 DOWNTO 0);
		Cflag, Zflag, memDataReady, ShadowEn : IN std_logic
		);
END controller;
ARCHITECTURE dataflow OF controller IS
	TYPE state IS (reset, halt, fetch, memread, exec1, exec2, exec1lda, exec1sta, exec2lda, exec2sta, incpc);
	
	CONSTANT b0000 : std_logic_vector (3 DOWNTO 0) := "0000";
	CONSTANT b1111 : std_logic_vector (3 DOWNTO 0) := "1111";
	
	CONSTANT nop : std_logic_vector (3 DOWNTO 0) := "0000";
	CONSTANT scf : std_logic_vector (3 DOWNTO 0) := "0100";
	CONSTANT cwp : std_logic_vector (3 DOWNTO 0) := "0110";
	CONSTANT brc : std_logic_vector (3 DOWNTO 0) := "1001";
	CONSTANT awp : std_logic_vector (3 DOWNTO 0) := "1010";
	CONSTANT lda : std_logic_vector (3 DOWNTO 0) := "0010";
	CONSTANT sta : std_logic_vector (3 DOWNTO 0) := "0011";

	CONSTANT add : std_logic_vector (3 DOWNTO 0) := "1011";
	CONSTANT sub : std_logic_vector (3 DOWNTO 0) := "1100";
	CONSTANT mul : std_logic_vector (3 DOWNTO 0) := "1101";
	CONSTANT cmp : std_logic_vector (3 DOWNTO 0) := "1110";
	
	CONSTANT mil : std_logic_vector (1 DOWNTO 0) := "00";
	CONSTANT mih : std_logic_vector (1 DOWNTO 0) := "01";
	CONSTANT jpa : std_logic_vector (1 DOWNTO 0) := "11";
	
	SIGNAL Pstate, Nstate : state;
	SIGNAL Regd_MemDataReady: std_logic;
	
BEGIN
	PROCESS (Instruction, Pstate, ExternalReset, Cflag, Zflag, Regd_MemDataReady, ShadowEn)
	BEGIN  
		ResetPC <= '0';
		PCplusI <= '0';
		PCplus1 <= '0';
		RplusI  <= '0';
		Rplus0 <= '0';
		EnablePC <= '0';
		B15to0 <= '0'; 
		AaddB <= '0'; 
		AsubB <= '0';
		AmulB <= '0';
		AcmpB <= '0';
		RFLwrite <= '0';
		RFHwrite <= '0'; 
		WPreset <= '0';
		WPadd <= '0';
		IRload <= '0';
		SRload <= '0';
		Address_on_Databus  <= '0';
		ALU_on_Databus <= '0';     
		IR_on_LOpndBus <= '0';
		IR_on_HOpndBus <= '0';
		RFright_on_OpndBus  <= '0';
		ReadMem <= '0';
		WriteMem   <= '0';
		Shadow <= '0';
		Cset <= '0';
		Creset <= '0';
		Zset <= '0';
		Zreset <= '0';
		Rs_on_AddressUnitRSide <= '0';
		Rd_on_AddressUnitRSide <= '0';
		
		CASE Pstate IS
			WHEN reset => 
			IF (ExternalReset = '1') THEN
				WPreset <= '1';
				ResetPC <= '1';
				EnablePC <= '1';
				Creset <= '1';
				Zreset <= '1';
				Nstate <= reset;
			ELSE
				Nstate <= fetch;
			END IF; 
			WHEN halt => 
			IF (ExternalReset = '1') THEN
				Nstate <= fetch;
			ELSE
				Nstate <= halt;
			END IF; 
			WHEN fetch => 
			IF (ExternalReset = '1') THEN
				Nstate <= reset;
			ELSE
				ReadMem <= '1';
				Nstate <= memread;
			END IF; 
			WHEN memread =>
			IF (ExternalReset = '1') THEN
				Nstate <= reset;
			ELSE
				IF (Regd_MemDataReady = '0') THEN
					ReadMem <= '1';
					Nstate <= memread;
				ELSE  
					ReadMem <= '1';
					IRload <= '1';  
					Nstate <= exec1;
				END IF;
			END IF;
			WHEN exec1 => 
			IF (ExternalReset = '1') THEN
				Nstate <= reset;
			ELSE
				CASE Instruction (7 DOWNTO 4)is
					WHEN b0000 =>
					CASE Instruction (3 DOWNTO 0) IS
						WHEN nop =>
							IF (ShadowEn='1') THEN 
								Nstate <= exec2;
							ELSE
								PCplus1 <= '1';
								EnablePC <= '1';
								Nstate <= fetch;
							END IF;
						WHEN scf =>
							cset <= '1';
							IF (ShadowEn='1') THEN 
								Nstate <= exec2;
							ELSE
								PCplus1 <= '1';
								EnablePC <= '1';
								Nstate <= fetch; 
							END IF;
						WHEN cwp =>
							WPreset <= '1';
							IF (ShadowEn='1') THEN 
								Nstate <= exec2;
							ELSE
								PCplus1 <= '1';
								EnablePC <= '1';
								Nstate <= fetch; 
							END IF;
						WHEN brc =>
						IF (Cflag = '1') THEN
							PCplusI <= '1';
							EnablePC <= '1';
						ELSE
							PCplus1 <= '1';
							EnablePC <= '1';
						END IF; 
						Nstate <= fetch; 
						WHEN awp =>
						PCplus1 <= '1';
						EnablePC <= '1';
						WPadd <= '1';
						Nstate <= fetch; 
						WHEN OTHERS =>
						PCplus1 <= '1';
						EnablePC <= '1';
						Nstate <= fetch;
					END CASE;
					WHEN lda =>
						Rplus0 <= '1';
						Rs_on_AddressUnitRSide <= '1';
						ReadMem <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						Nstate <= exec1lda;
					WHEN sta =>
						Rplus0 <= '1';
						Rd_on_AddressUnitRSide <= '1';
						RFright_on_OpndBus <= '1';
						B15to0 <= '1';
						ALU_on_Databus <= '1';
						WriteMem <= '1';
						Nstate <= exec1sta;

					WHEN add =>
						RFright_on_OpndBus <= '1';
						AaddB <= '1';
						ALU_on_Databus <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						SRload <= '1';
						IF (ShadowEn='1') THEN 
							Nstate <= exec2;
						ELSE
							Pcplus1 <= '1';
							EnablePC <= '1';
							Nstate <= fetch; 
						END IF;
					WHEN sub =>
						RFright_on_OpndBus <= '1';
						AsubB <= '1';
						ALU_on_Databus <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						SRload <= '1';
						IF (ShadowEn='1') THEN 
							Nstate <= exec2;
						ELSE
							Pcplus1 <= '1';
							EnablePC <= '1';
							Nstate <= fetch; 
						END IF;
					WHEN mul =>
						RFright_on_OpndBus <= '1';
						AmulB <= '1';
						ALU_on_Databus <= '1';
						RFLwrite <= '1';
						RFHwrite <= '1';
						SRload <= '1';
						IF (ShadowEn='1') THEN 
							Nstate <= exec2;
						ELSE
							Pcplus1 <= '1';
							EnablePC <= '1';
							Nstate <= fetch; 
						END IF;
					WHEN cmp =>
						RFright_on_OpndBus <= '1';
						AcmpB <= '1';
						SRload <= '1';
						IF (ShadowEn='1') THEN 
							Nstate <= exec2;
						ELSE
							Pcplus1 <= '1';
							EnablePC <= '1';
							Nstate <= fetch; 
						END IF;
					WHEN b1111 =>
					CASE Instruction (1 DOWNTO 0) IS
						WHEN mil =>
						IR_on_LOpndBus <= '1';
						ALU_on_Databus <= '1';
						B15to0 <= '1';
						RFLwrite <= '1';
						SRload <= '1';
						Pcplus1 <= '1';
						EnablePC <= '1';
						Nstate <= fetch;
						WHEN mih =>
						IR_on_HOpndBus <= '1';
						ALU_on_Databus <= '1';
						B15to0 <= '1';
						RFHwrite <= '1';
						SRload <= '1';
						Pcplus1 <= '1';
						EnablePC <= '1';
						Nstate <= fetch;

						WHEN jpa =>
						Rd_on_AddressUnitRSide <= '1';
						RplusI <= '1';
						EnablePC <= '1';
						Nstate <= fetch; 
						WHEN OTHERS =>
						Nstate <= fetch;
					END CASE;
					WHEN OTHERS =>  Nstate <= fetch;
				END CASE;
			END IF; 
			WHEN exec1lda => 
			IF (ExternalReset = '1') THEN
				Nstate <= reset;
			ELSE
				IF (Regd_MemDataReady = '0') THEN
					Rplus0 <= '1';
					Rs_on_AddressUnitRSide <= '1';
					ReadMem <= '1';
					RFLwrite <= '1';
					RFHwrite <= '1';
					Nstate <= exec1lda;
				ELSE  
					IF (ShadowEn='1') THEN 
						Nstate <= exec2;
					ELSE
						PCplus1 <= '1';
						EnablePC <= '1';
						Nstate <= fetch;
					END IF;
				END IF;
			END IF;
			WHEN exec1sta => 
			IF (ExternalReset = '1') THEN
				Nstate <= reset;
			ELSE
				IF (Regd_MemDataReady = '0') THEN
					Rplus0 <= '1';
					Rd_on_AddressUnitRSide <= '1';
					RFright_on_OpndBus <= '1';
					B15to0 <= '1';
					ALU_on_Databus <= '1';
					WriteMem <= '1';
					Nstate <= exec1sta;
				ELSE  
					--  WriteMem <= '1';
					IF (ShadowEn='1') THEN 
						Nstate <= exec2;
					ELSE
						Nstate <= incpc; 
					END IF;
				END IF;
			END IF;
			WHEN exec2 =>
			shadow <= '1';
			IF (ExternalReset = '1') THEN
				Nstate <= reset;
			ELSE
				CASE Instruction (7 DOWNTO 4)is
					WHEN b0000 =>
					CASE Instruction (3 DOWNTO 0) IS

						WHEN scf =>
						cset <= '1';
						PcPlus1 <= '1';
						EnablePC <= '1';
						Nstate <= fetch; 

						WHEN cwp =>
						WPreset <= '1';
						PcPlus1 <= '1';
						EnablePC <= '1';
						Nstate <= fetch; 
						WHEN OTHERS =>
						PcPlus1 <= '1';
						EnablePC <= '1';
						Nstate <= fetch;
					END CASE;
 
					WHEN lda =>
					Rplus0 <= '1';
					Rs_on_AddressUnitRSide <= '1';
					ReadMem <= '1';
					RFLwrite <= '1';
					RFHwrite <= '1';
					Nstate <= exec2lda;
					WHEN sta =>
					Rplus0 <= '1';
					Rd_on_AddressUnitRSide <= '1';
					RFright_on_OpndBus <= '1';
					B15to0 <= '1';
					ALU_on_Databus <= '1';
					WriteMem <= '1';
					Nstate <= exec2sta;


					

					WHEN add =>
					RFright_on_OpndBus <= '1';
					AaddB <= '1';
					ALU_on_Databus <= '1';
					RFLwrite <= '1';
					RFHwrite <= '1';
					SRload <= '1';
					PcPlus1 <= '1';
					EnablePC <= '1';
					Nstate <= fetch; 
					WHEN sub =>
					RFright_on_OpndBus <= '1';
					AsubB <= '1';
					ALU_on_Databus <= '1';
					RFLwrite <= '1';
					RFHwrite <= '1';
					SRload <= '1';
					PcPlus1 <= '1';
					EnablePC <= '1';
					Nstate <= fetch; 
					WHEN mul =>
					RFright_on_OpndBus <= '1';
					AmulB <= '1';
					ALU_on_Databus <= '1';
					RFLwrite <= '1';
					RFHwrite <= '1';
					SRload <= '1';
					PcPlus1 <= '1';
					EnablePC <= '1';
					Nstate <= fetch; 
					WHEN cmp =>
					RFright_on_OpndBus <= '1';
					AcmpB <= '1';
					SRload <= '1';
					PcPlus1 <= '1';
					EnablePC <= '1';
					Nstate <= fetch; 
					WHEN OTHERS =>  Nstate <= fetch;
				END CASE;
			END IF; 
			WHEN exec2lda => 
			shadow <= '1';
			IF (ExternalReset = '1') THEN
				Nstate <= reset;
			ELSE
				IF (Regd_MemDataReady = '0') THEN
					Rplus0 <= '1';
					Rs_on_AddressUnitRSide <= '1';
					ReadMem <= '1';
					RFLwrite <= '1';
					RFHwrite <= '1';
					Nstate <= exec2lda;
				ELSE 
					PcPlus1 <= '1';
					EnablePC <= '1';
					Nstate <= fetch;
				END IF;
			END IF;
			WHEN exec2sta => 
			shadow <= '1';
			IF (ExternalReset = '1') THEN
				Nstate <= reset;
			ELSE
				IF (Regd_MemDataReady = '0') THEN   
					Rplus0 <= '1';
					Rd_on_AddressUnitRSide <= '1';
					RFright_on_OpndBus <= '1';
					B15to0 <= '1';
					ALU_on_Databus <= '1';
					WriteMem <= '1';
					Nstate <= exec2sta;
				ELSE  
					Nstate <= incpc;
				END IF;
			END IF;
			WHEN incpc => 
			PcPlus1 <= '1';
			EnablePC <= '1';
			Nstate <= fetch;
			WHEN OTHERS => Nstate <= reset;
		END CASE;
	END PROCESS;
	
	PROCESS (clk)
	BEGIN
		IF (clk = '1') THEN
			Regd_MemDataReady <= memDataReady;
			Pstate <= Nstate;
		END IF;
	END PROCESS;
END dataflow;
