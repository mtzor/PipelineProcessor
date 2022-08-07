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
    Port ( Reg_A : in  signed  (31 downto 0);
           Reg_B : in  signed  (31 downto 0);
           Immed : in  signed  (31 downto 0);
           PC: in  signed  (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC_VECTOR(1 downto 0);
           ALU_Ain_sel : in  STD_LOGIC;
           ALU_func: in  signed  (3 downto 0);
           ALU_out:out  signed  (31 downto 0);
           ALU_zero : out  STD_LOGIC
            );
end EXSTAGE;

architecture Behavioral of EXSTAGE is

signal MUX_OUT,A_temp,B_temp:  signed (31 downto 0);

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

Component MUX32_2_1
 Port (A:in  signed  (31 downto 0);
       B: in signed  (31 downto 0);
       Sel: in  STD_LOGIC;
       Output: out signed  (31 downto 0)
  );
end Component;

COMPONENT MUX_32_4_1
Port ( 
         A:in signed (31 downto 0) ;
         B:in signed (31 downto 0) ;
         C :in signed (31 downto 0) ;
         D:in signed(31 downto 0);
         sel:in std_logic_vector(1 downto 0);
         MUX_Out: out signed (31 downto 0) );

END COMPONENT;

begin
Instance_MUX: MUX32_2_1 PORT MAP (
          A => PC,
          B =>Reg_A,
          Sel => ALU_Ain_sel,
          Output => A_temp
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
        
MUX: MUX_32_4_1 PORT MAP (
          A => Reg_B,
          B =>"00000000000000000000000000000100" ,
          C => Immed,
          D =>Immed ,
          sel => ALU_Bin_sel,
          MUX_Out =>B_temp
        );

end Behavioral;
