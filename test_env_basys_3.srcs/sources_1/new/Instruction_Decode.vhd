
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity Instruction_Decode is
	Port ( clk: in std_logic;
			Instr: in std_logic_vector(15 downto 0);
			WriteData: in std_logic_vector(15 downto 0);
			WA: in std_logic_vector(2 downto 0);
			RegWrite: in std_logic;
			RegDst: in std_logic;
			ExtOp: in std_logic;
			RD1: out std_logic_vector(15 downto 0);
			RD2: out std_logic_vector(15 downto 0);
			ExtImm : out std_logic_vector(15 downto 0);
			func : out std_logic_vector(2 downto 0);
			sa : out std_logic);		
end Instruction_Decode;

architecture Behavioral of Instruction_Decode is
component REG_FILE is
port (
clk : in std_logic;
ra1 : in std_logic_vector (2 downto 0);
ra2 : in std_logic_vector (2 downto 0);
wa : in std_logic_vector (2 downto 0);
wd : in std_logic_vector (15 downto 0);
wen : in std_logic;
rd1 : out std_logic_vector (15 downto 0);
rd2 : out std_logic_vector (15 downto 0)
);
end component;



signal ExtUnit: std_logic_vector(15 downto 0);

begin


process(ExtOp,Instr)   
begin
	case (ExtOp) is
		when '1' => 	
				case (Instr(6)) is
					when '0' => ExtUnit <= B"000000000" & Instr(6 downto 0);
					when '1' =>  ExtUnit <=	B"111111111" & Instr(6 downto 0);
					when others => ExtUnit <= ExtUnit;
				end case;
		when others => ExtUnit <= B"000000000" & Instr(6 downto 0);
	end case;
end process;





	
func<=Instr(2 downto 0);	  
sa<=Instr(3);					
ExtImm <= ExtUnit;				




RF1: REG_FILE port map (clk,Instr(12 downto 10),Instr(9 downto 7),WA,WriteData,RegWrite,RD1,RD2);



end Behavioral;

