----------------------------------------------------------------------------------
--!!!!!!!!!!!CHANGES!!!!!!!!!!!!
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- The multiplexer of input A of ALU was added to choose between the PC and RF_A output.
-- The multiplexer of input B of ALU was changed to choose between four inputs: RF_B output,4,immediate
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

entity EXSTAGE is
    Port ( RF_A : in  signed  (31 downto 0);
           RF_B : in  signed  (31 downto 0);
           ImmCalc_IDEX: in  STD_LOGIC;
           Immed : in  signed  (31 downto 0);
           RF_WrData: in  signed  (31 downto 0);
           ALU_Reg_Dout: in  signed  (31 downto 0);
           PC: in  signed  (31 downto 0);
           PC_Immed: out  signed  (31 downto 0);
           ALU_Ain_sel : in  STD_LOGIC_VECTOR(1 downto 0);
           ALU_Bin_sel : in  STD_LOGIC_VECTOR(1 downto 0);
           ALU_func: in  signed  (3 downto 0);
           ALU_out:out  signed  (31 downto 0);
           MEMWrData:out  signed  (31 downto 0);
           ALU_zero : out  STD_LOGIC
            );
end EXSTAGE;

architecture Behavioral of EXSTAGE is

signal MUX_OUT,A_temp,B_temp,Immed_temp,forward_b:  signed (31 downto 0);
 
COMPONENT MUX32_2_1 is
 Port (A:in  signed  (31 downto 0);
       B: in signed  (31 downto 0);
       Sel: in  STD_LOGIC;
       Output: out signed  (31 downto 0)
  );
end COMPONENT;
Component ImmedIncrementor 
    Port ( PC_Immed : in  signed (31 downto 0);
           PCInc : in  signed (31 downto 0);
           PC_ImmedInc : out  signed (31 downto 0)
           );
end Component;

 Component ALU
 Port ( A : in  signed (31 downto 0);
           B : in  signed (31 downto 0);
           Op : in  signed (3 downto 0);
           Zero : out  STD_LOGIC;
           Output : out  signed (31 downto 0);
           Cout : out  STD_LOGIC;
			  Ovf: out  STD_LOGIC
			  );
end component;

Component MUX_32_4_1
Port ( 
         A:in signed (31 downto 0) ;
         B:in signed (31 downto 0) ;
         C :in signed (31 downto 0) ;
         D:in signed(31 downto 0);
         sel:in std_logic_vector(1 downto 0);
         MUX_Out: out signed (31 downto 0) );
  end Component;

Component Extender_shift
 Port ( 
Instr: in signed (31 downto 0);
Jump_Address: out signed (31 downto 0)
 );
end Component;
begin
Instance_A: MUX_32_4_1 PORT MAP (
          A =>RF_A ,
          B =>RF_WrData,
          C => ALU_Reg_Dout,
          D =>"00000000000000000000000000000000",
          sel => ALU_Ain_sel,
          MUX_Out => A_temp
        );
        
Instance_B: MUX_32_4_1 PORT MAP (
          A =>RF_B ,
          B =>RF_WrData,
          C =>ALU_Reg_Dout ,
          D =>"00000000000000000000000000000000" ,
          sel => ALU_Bin_sel,
          MUX_Out =>forward_b
        );
   
MUX_IMM: MUX32_2_1 
 Port MAP(A=>forward_b,
          B=>Immed,
          Sel=>ImmCalc_IDEX,
          Output=>B_temp
  );
               
Instance_ALU: ALU PORT MAP (
          A => A_temp,
          B => B_temp ,
          Op => ALU_func,
          Zero => ALU_Zero,
          Output => ALU_out,
          Cout => open,
          Ovf => open
        );
        
PC_ADDER: ImmedIncrementor  Port MAP( 
           PC_Immed=>Immed_temp,
           PCInc=>PC,
           PC_ImmedInc=>PC_Immed
           );
sll2:Extender_shift PORT MAP (
        Instr=>Immed,
        Jump_Address=>Immed_temp);
        
MEMWrData<=forward_b;
end Behavioral;
