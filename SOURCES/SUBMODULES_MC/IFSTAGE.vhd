----------------------------------------------------------------------------------
--!!!!!!!!!!!CHANGES!!!!!!!!!!!!
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
--The PC incremmentor and PC immediate incremmentor were removed.The input instr was added.The module extender shift 
--was added to calculate the jump address based on the instruction.The multiplexer changed into a 4to1 multiplexer.
--It now chooses betwween the two new inputs alu_result and aluout and the output of the extender_shift.Also PC_sel 
--became 2 bits.
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

entity IFSTAGE is
    Port ( PC_Sel : in STD_LOGIC_VECTOR(1 downto 0);
           PC_LdEn : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Instr : in signed (31 downto 0);
           ALU_Out: in signed (31 downto 0);
           ALU_result: in signed (31 downto 0);      
           PC : out signed (31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is

signal Jump_Address_temp,PC_temp: signed(31 downto 0);


COMPONENT MUX_32_4_1
Port ( 
         A:in signed (31 downto 0) ;
         B:in signed (31 downto 0) ;
         C :in signed (31 downto 0) ;
         D:in signed(31 downto 0);
         sel:in std_logic_vector(1 downto 0);
         MUX_Out: out signed (31 downto 0) );

END COMPONENT;

COMPONENT Extender_shift
Port ( 
Instr: in signed (31 downto 0);
Jump_Address: out signed (31 downto 0)
 );
end COMPONENT;


COMPONENT  PCRegisterModule is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (31 downto 0);
           DataOut : out signed (31 downto 0));
end COMPONENT;

begin

Ex_shift: Extender_shift PORT MAP (
            Instr=>Instr,
            Jump_Address=>Jump_Address_temp
 );

MUX: MUX_32_4_1 PORT MAP (
          A => ALU_result,
          B =>ALU_Out ,
          C => Jump_Address_temp,
          D =>ALU_result ,
          sel => PC_Sel,
          MUX_Out =>PC_temp
        );
        
PC_register: PCRegisterModule PORT MAP (
          CLK=> CLK,
          RST => Reset,
          WE => PC_LdEn,
          DataIn => PC_temp,
          DataOut => PC
         
        );
end Behavioral;
