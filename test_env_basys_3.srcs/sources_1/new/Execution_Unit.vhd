

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Execution_Unit is
Port ( 
    PCOut: in std_logic_vector(15 downto 0);
    Ext_Imm: in std_logic_vector(15 downto 0);
    RD1: in std_logic_vector(15 downto 0);
    RD2: in std_logic_vector(15 downto 0);
    ALUOp: in std_logic_vector(2 downto 0);
    func: in std_logic_vector(2 downto 0);
    sa : in std_logic;
    ALUSrc: in std_logic;
    BranchAdress: out std_logic_vector(15 downto 0);
    ALURes: out std_logic_vector(15 downto 0);
    zero: out std_logic

);
end Execution_Unit;

architecture Behavioral of Execution_Unit is

signal AluInput:std_logic_vector(15 downto 0);
signal ALUCtrl: std_logic_vector(3 downto 0);  --4 biti ca am nevoie la jump
signal ALURes2:std_logic_vector(15 downto 0);
signal zero2: std_logic;

begin

BranchAdress<=PCOut+Ext_Imm;

with ALUSrc select
	AluInput<=RD2 when '0',
			  Ext_Imm when others;
			  

process(ALUOp,func)
begin
	case (ALUOp) is
		when "000"=>
				case (func) is
					when "000"=> ALUCtrl<="0000"; 	    --ADD
					when "001"=> ALUCtrl<="0001";		--SUB
					when "010"=> ALUCtrl<="0010";		--SLL
					when "011"=> ALUCtrl<="0011";		--SRL
					when "100"=> ALUCtrl<="0100";		--AND
					when "101"=> ALUCtrl<="0101";		--OR
					when "110"=> ALUCtrl<="0110";		--XOR
					when "111"=> ALUCtrl<="0111";		--SetOnLessThan
					when others=> ALUCtrl<="0000";	
				end case;
		when "001"=> ALUCtrl<="0000";		--ADDI
		when "010"=> ALUCtrl<="0001";		--BEQ
		when "101"=> ALUCtrl<="0100";		--ANDI
		when "110"=> ALUCtrl<="0101";		--ORI
		when "111"=> ALUCtrl<="1000";		--JUMP
		when others=> ALUCtrl<="0000";	
	end case;
end process;

process(ALUCtrl,RD1,AluInput,SA)
begin
	case(ALUCtrl) is
		when "0000" => ALURes2<=RD1+AluInput; --ADD				
		when "0001" => ALURes2<=RD1-AluInput;	--SUB					
		when "0010" => 	--SLL
					case (SA) is
						when '1' => ALURes2<=RD1(14 downto 0) & "0";
						when others => ALURes2<=RD1;	
					end case;							
		when "0011" => 	--SRL
					case (SA) is
						when '1' => ALURes2<="0" & RD1(15 downto 1);
						when others => ALURes2<=RD1;
					end case;						
		when "0100" => ALURes2<=RD1 and AluInput;--AND			
		when "0101" => ALURes2<=RD1 or AluInput;	--OR							
		when "0110" => ALURes2<=RD1 xor AluInput;	--XOR					
		when "0111" =>      --SET ON LESS THAN
				if RD1<AluInput then
					ALURes2<=X"0001";
				else ALURes2<=X"0000";
				end if;		
		when "1000" => ALURes2<=X"0000";--JUMP			
		when others => ALURes2<=X"0000";
	end case;

	case (ALURes2) is	--zero
		when X"0000" => zero2<='1';
		when others => zero2<='0';
	end case;

end process;
zero<=zero2;	--zeroout
ALURes<=ALURes2;	--aluout


end Behavioral;
