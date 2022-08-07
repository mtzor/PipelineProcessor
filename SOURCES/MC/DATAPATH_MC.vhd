----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/27/2020 09:31:30 PM
-- Design Name: 
-- Module Name: DATAPATH - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
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

entity DATAPATH_MC is
 Port (
 Instr :in signed(31 downto 0);
 MM_RdData :in signed(31 downto 0);
 
 Mem_WrEn :in std_logic;
 RF_WrData_sel:in std_logic;
 RF_B_sel:in std_logic;
 RF_WrEn:in std_logic;
 InstReg_WrEn:in std_logic;
 ALU_Bin_Sel:in std_logic_vector(1 downto 0);
 ALU_Ain_Sel:in std_logic;
 ImmExt :in std_logic_vector(1 downto 0);
 ByteOp :in std_logic;
 ALU_func:in signed(3 downto 0);
 PC_sel:in std_logic_vector(1 downto 0);
 Reset:in std_logic;
 PC_LdEn:in std_logic;
 Clk:in std_logic;


 MM_Addr: out signed(31 downto 0);
 MM_WrEn : out std_logic;
 MM_WrData: out signed(31 downto 0);
 PC:out signed(31 downto 0);
 
 ALU_zero:out std_logic;
 InstrRegOut :out signed(31 downto 0)

  );
end DATAPATH_MC;

architecture Behavioral of DATAPATH_MC is
signal Immed_temp,ALU_result,PC_temp,ALU_out_temp,RF_A_temp,RF_B_temp,MEM_out_temp,AReg_temp,Instr_temp,MM_RdData_temp,BReg_temp:signed(31 downto 0);



Component DECSTAGE
Port ( Instr : in STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in STD_LOGIC;
           Rst : in STD_LOGIC;
           ALU_out : in signed (31 downto 0);
           MEM_out : in signed (31 downto 0);
           RF_WrData_sel : in STD_LOGIC;
           RF_B_sel : in STD_LOGIC;
           ImmExt : in STD_LOGIC_VECTOR (1 downto 0);
           Clk : in STD_LOGIC;
           Immed : out signed (31 downto 0);
           RF_A : out signed (31 downto 0);
           RF_B : out signed (31 downto 0));
End component;   


 
 COMPONENT MEMSTAGE
  Port (
     ByteOp:in std_logic;
     clk:in std_logic;
     Mem_WrEn:in std_logic;
     ALU_MEM_Addr:in signed(31 downto 0); 
     MEM_DataIn:in signed(31 downto 0);
     MEM_DataOut:out signed(31 downto 0);
     MM_Addr:out signed(31 downto 0);
     MM_WrEn:out std_logic;
     MM_WrData:out signed(31 downto 0);
     MM_RdData:in signed(31 downto 0)
 );
    END COMPONENT;
    
    COMPONENT  IFSTAGE is
Port ( PC_Sel : in STD_LOGIC_VECTOR(1 downto 0);
           PC_LdEn : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Instr : in signed (31 downto 0);
           ALU_Out: in signed (31 downto 0);
           ALU_result: in signed (31 downto 0);      
           PC : out signed (31 downto 0));
end COMPONENT;

COMPONENT EXSTAGE
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
END COMPONENT;


COMPONENT RegisterModule is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (31 downto 0);
           DataOut : out signed (31 downto 0));
end COMPONENT;


begin


Instruction_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => Reset,
          WE => InstReg_WrEn,
          DataIn => Instr,
          DataOut => Instr_temp
         
        );--
        
MemData_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => Reset,
          WE => '1',--MemReg_WrEn,
          DataIn => MM_RdData,
          DataOut => MM_RdData_temp
         
        );--  
             
A_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => Reset,
          WE =>'1', --AReg_WrEn,
          DataIn => RF_A_temp,
          DataOut => AReg_temp
         
        );--   

B_Register:RegisterModule PORT MAP (
          CLK=> CLK,
          RST => Reset,
          WE =>'1',--BReg_WrEn,
          DataIn => RF_B_temp,
          DataOut => BReg_temp
         
        );-- 

ALU_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => Reset,
          WE =>'1',-- ALUReg_WrEn,
          DataIn => ALU_result,
          DataOut => ALU_out_temp
         
        );-- 
instance_ex: EXSTAGE PORT MAP (
          Reg_A => AReg_temp,
          Reg_B => BReg_temp,
          Immed => Immed_temp,
          PC=>PC_temp,
          ALU_Bin_sel => ALU_Bin_sel,
          ALU_Ain_sel => ALU_Ain_sel,
          ALU_func => ALU_func,
          ALU_out => ALU_result,
          ALU_zero => ALU_zero
        );
        
instance_if: IFSTAGE 
PORT MAP ( PC_Sel => PC_Sel,
           PC_LdEn => PC_LdEn,
           Reset => Reset,--
           Instr=>Instr_temp,
           ALU_Out=>ALU_out_temp,
           ALU_result=>ALU_result,
           Clk => Clk,--
           PC => PC_temp --
           );
           
instance_dec: DECSTAGE PORT MAP ( 
        Instr =>std_logic_vector(Instr_temp) ,--
        RF_WrEn => RF_WrEn ,--
        Rst=>Reset,

        ALU_out => ALU_out_temp,--
        MEM_out => MEM_out_temp,--
        RF_WrData_sel =>RF_WrData_sel,--
        RF_B_sel => RF_B_sel,--
        ImmExt => ImmExt,--
        Clk =>Clk,--
        Immed =>Immed_temp,--
        RF_A => RF_A_temp,--
        RF_B => RF_B_temp--
        );
        
 
  uut: MEMSTAGE PORT MAP (
          ByteOp => ByteOp,--
          clk=>Clk,--
          Mem_WrEn=>Mem_WrEn,--
          ALU_MEM_Addr=>ALU_out_temp,
          MEM_DataIn=>BReg_temp,
          MM_RdData=>MM_RdData_temp,--
          MM_WrData=>MM_WrData,
          MM_Addr=>MM_Addr,
          MEM_DataOut=>MEM_out_temp,
          MM_WrEn=>MM_WrEn  
        ); 
        PC<=PC_temp ;    
        InstrRegOut<=Instr_temp;        
end Behavioral;
