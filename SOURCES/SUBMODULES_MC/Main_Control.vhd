----------------------------------------------------------------------------------
--!!!!!!!!!!!CHANGES!!!!!!!!!!!!
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--WE ADDED THE FSM FOR THE MULTICYCLE CONTROL.Now the outputs depend on the state of the machine.
--PC_sel,ALU_Bin_Sel became 2 bits.
-- Added these inputs and outputs:ALU_Ain_Sel,PCWrite, PCWriteCond,InstReg_WrEn


----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Main_Control is
Port (
 Instr :in signed(31 downto 0); 
 Clk:in std_logic;
 ALU_zero:in std_logic;
 Reset:in std_logic;

 
 Mem_WrEn :out std_logic;
 RF_WrData_sel:out std_logic;
 RF_B_sel:out std_logic;
 RF_WrEn:out std_logic;
 InstReg_WrEn:out std_logic;
 ALU_Bin_Sel:out std_logic_vector(1 downto 0);
 ALU_Ain_Sel:out std_logic;
 ImmExt :out std_logic_vector(1 downto 0);
 ByteOp :out std_logic;
 ALUop:out signed(2 downto 0);
 PC_sel:out std_logic_vector(1 downto 0);
 PCWrite:out std_logic;
 PCWriteCond:out std_logic
  );
end Main_Control;

architecture Behavioral of Main_Control is
signal op : signed(5 downto 0);

TYPE State_type IS (SR,S0, S1, S2,S3,S4,S5,S6,S7,S8,S9,S10,S11,S12,S13,S14) ;
SIGNAL currentS, nextS : State_type ;
BEGIN

fsm_synch: process (clk, Reset)  begin 
if (Reset = '1') THEN 
    currentS <= SR ;
elsif (falling_edge(clk))  then     
    currentS <= nextS; 
end if;
end process fsm_synch; 

fsm_comb: process (currentS, op)  begin

CASE currentS IS
 WHEN SR =>         nextS<=S0;
 
 WHEN S0 =>         nextS<= S1 ;
               
 WHEN S1 =>     IF op = "100000" THEN
                     nextS  <= S6 ;
                ELSIF op="111000" or op="110000" or op= "000111" or op= "001111" THEN
                     nextS <= S2;
                ELSIF op="111001" THEN
                      nextS  <= S10;
                ELSIF op="110010" THEN
                     nextS  <= S11;
                ELSIF op="110011" THEN
                     nextS  <= S12;
                ELSIF op="111111" THEN
                     nextS  <= S9;    
                ELSIF op="000000" or op="000001"THEN
                     nextS  <= S8;    
                ELSIF op="011111" THEN
                    nextS  <= S2;  
                ELSIF op="000011" THEN
                    nextS<= S2; 
                ELSE    
                    nextS<= S0; 
                END IF;
                
 WHEN S2 =>     IF (op = "111000" or op="110000") THEN
                      nextS <= S7 ;
                ELSIF op="011111" THEN
                      nextS <= S5;   
                ELSIF op="000011" THEN
                     nextS <= S13;   
                ELSIF op="000111" THEN
                     nextS <= S14;     
                ELSIF op="001111" THEN
                     nextS <= S3;  
                ELSE    
                    nextS<= S0;                 
                END IF ;
    
 WHEN S3 =>         nextS <= S4 ;
 
 WHEN S4 =>         nextS <= S0 ;
 
 WHEN S5 =>         nextS <= S0 ;
 
 WHEN S6 =>         nextS <= S7 ;
 
 WHEN S7 =>         nextS <= S0 ;
 
 WHEN S8 =>         nextS <= S0 ; 

 WHEN S9 =>         nextS <= S0 ;     

 WHEN S10 =>        nextS <= S7 ; 
 
 WHEN S11 =>        nextS <= S7 ;  

 WHEN S12 =>        nextS <= S7 ;
 
 WHEN S13 =>        nextS <= S4 ; 
 
 WHEN S14 =>        nextS <= S0;        
 
 WHEN others=>      nextS <= S0;    
 
 end case;  
 end process fsm_comb; 



 InstReg_WrEn<='1' WHEN currentS = S0 ELSE '0' ;
 
 ALU_Bin_Sel<="10" WHEN (currentS = S1 or currentS = S2 or currentS =S10  or currentS =S11 or currentS =S12) ELSE 
              "01" WHEN currentS = S0 ELSE
              "00" WHEN (currentS = S6 or currentS = S8)ELSE
              "11";


 Mem_WrEn <='1' WHEN (currentS = S5 or  currentS = S14) ELSE '0';
 
 ByteOp<='1' WHEN (currentS = S13 or currentS = S14 or (currentS = S4 and op="000011")) ELSE '0';
 
 ImmExt<="10"  WHEN (currentS = S1  or currentS=S8) ELSE 
         "01" WHEN (currentS = S6 or currentS = S2) ELSE
         "11" WHEN currentS = S10  ELSE
         "00" WHEN  (currentS = S12 or currentS =S11) ELSE "00"  ;
          
 ALU_Ain_Sel<='1' WHEN (currentS = S6 or currentS =S2  or currentS =S10  or currentS =S11  or currentS =S12 or currentS=S8) ELSE
              '0' ;
              
 PCWrite<='1' WHEN  currentS = S0 or currentS =S9 ELSE '0';
 
 PCWriteCond<='1' WHEN  currentS=S8 ELSE '0';
              
 RF_WrEn<='1' WHEN (currentS=S7 or currentS=S4) ELSE '0';
 
 PC_sel<="00" WHEN  currentS=S0 ELSE
         "01" WHEN  (currentS=S9 or currentS=S8)ELSE
         "00" ;
         
 RF_B_sel<='1' WHEN (currentS=S2 or currentS=S8 or (currentS=S1 AND op="000000")) ELSE '0';
 
 RF_WrData_sel<='1' WHEN  currentS = S4 ELSE '0';
 
 ALUop<="000" when currentS = S0 or currentS = S2 or currentS = S1 or currentS =S10  else--add 
        "001" when currentS=S8 else--SUB
        "010" when  currentS =S12 else --ORI
        "011" when  currentS =S11  else--NAND
        "100" when  currentS = S6 else --RTYPE
        "111";
        
op<=Instr(31 downto 26);        
end Behavioral;
