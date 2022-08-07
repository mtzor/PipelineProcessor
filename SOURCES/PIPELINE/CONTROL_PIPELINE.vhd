----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2020 07:14:00 PM
-- Design Name: 
-- Module Name: CONTROL_PIPELINE - Behavioral
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

entity CONTROL_PIPELINE is
Port ( 
 Instr_IFID :in signed(31 downto 0);--
 ALU_zero_EXMEM:in std_logic;
 Reset:in std_logic;--
 Clk:in std_logic;--
 
 rs_IDEX:in signed(4 downto 0);--
 RF_B_Mux_out_IDEX: in signed(4 downto 0);--
 RF_B_mux_out_IFID: in signed(4 downto 0);--
 rd_EXMEM: in signed(4 downto 0);--
 rd_MEMWB: in signed(4 downto 0);--
 
 rd_IDEX:in signed(4 downto 0);--
  
ImmCalc_IDEX:out std_logic;  
 Mem_WrEn :out std_logic;
 RF_WrData_sel:out std_logic;
 RF_B_sel:out std_logic;--
 RF_WrEn:out std_logic;
 IFID_WrEn:out std_logic;--
 IDEX_WrEn:out std_logic;--
 EXMEM_WrEn:out std_logic;--
 MEMWB_WrEn:out std_logic;--
 
 ALU_Bin_Sel:out std_logic_vector(1 downto 0);--
 ALU_Ain_Sel:out std_logic_vector(1 downto 0);--
 ImmExt :out std_logic_vector(1 downto 0);--
 ByteOp :out std_logic;
 ALU_func:out signed(3 downto 0);--
 PC_sel:out std_logic;
 PC_LdEn:out std_logic--

);
end CONTROL_PIPELINE;

architecture Behavioral of CONTROL_PIPELINE is
signal ALUop_IDEX,ALUop_C: signed(2 downto 0);
signal PCWrite_C,PCWriteCondBeq_C,PCWriteCondBne_C,IDEX_WrEn_C: std_logic;
signal ImmCalc_C,EXMEM_WrEn_C,Mem_WrEn_C,Mem_Read_C,MEMWB_WrEn_C: std_logic;
signal ByteOp_C,RF_WrData_sel_C,RF_WrEn_C : std_logic;
signal IDEX_WrEn_mux,Mem_WrEn_mux,Mem_WrEn_IDEX: std_logic;
signal MEMWB_WrEn_mux,MEMWB_WrEn_IDEX,Mem_Read_mux,Mem_Read_IDEX: std_logic;
signal PCWrite_IDEX,PCWriteCondBne_IDEX,PCWriteCondBeq_IDEX: std_logic;
signal RF_WrData_sel_IDEX,RF_WrEn_mux,RF_WrEn_IDEX: std_logic;
signal EXMEM_WrEn_mux,EXMEM_WrEn_IDEX,Mem_WrEn_EXMEM: std_logic;
signal func_IDEX : signed(5 downto 0);
signal MEMWB_WrEn_EXMEM,PCWrite_EXMEM,PCWriteCondBeq_EXMEM: std_logic;
signal PCWriteCondBne_EXMEM,RF_WrData_sel_EXMEM,RF_WrEn_EXMEM : std_logic;
signal RF_WrEn_WB,ControlMux_sel,ByteOp_IDEX : std_logic;
  


COMPONENT ALU_Control IS
 Port ( 
 ALUop:in signed(2 downto 0);
 func:in signed(5 downto 0);
 ALU_func:out signed(3 downto 0)
 );
 END COMPONENT;
 
 COMPONENT Main_Control IS
     Port (
    
     Instr :in signed(31 downto 0); 
 --IF
 PCWrite:out std_logic;
 PCWriteCondBeq:out std_logic;
 PCWriteCondBne:out std_logic;
 --DEC
 ImmExt :out std_logic_vector(1 downto 0);
 RF_B_sel:out std_logic;
 IDEX_WrEn:out std_logic;
--EX
 ALUop:out signed(2 downto 0);
 ImmCalc:out std_logic;
 EXMEM_WrEn:out std_logic;
 --MEM
 Mem_WrEn :out std_logic;
 Mem_Read:out std_logic;
  MEMWB_WrEn:out StD_LoGiC;

 ByteOp :out std_logic;
 
 --WB
 RF_WrData_sel:out std_logic;
 RF_WrEn:out std_logic
   );
 END COMPONENT;
 
 COMPONENT IDEX_C is
  Port (
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           IDEX_WrEn : in STD_LOGIC;
          
           Mem_WrEn:in std_logic;
           Mem_WrEn_IDEX:out std_logic;
           MEMWB_WrEn:in std_logic;
           MEMWB_WrEn_IDEX:out std_logic;
           Mem_Read:in std_logic;
           Mem_Read_IDEX:out std_logic;
           ByteOp :in std_logic;
           ByteOp_IDEX :out std_logic;
           PCWrite:in std_logic;
           PCWrite_IDEX:out std_logic;
           PCWriteCondBeq:in std_logic;
           PCWriteCondBeq_IDEX:out std_logic;
           PCWriteCondBne:in std_logic;
           PCWriteCondBne_IDEX:out std_logic;


           RF_WrData_sel:in std_logic;
           RF_WrData_sel_IDEX:out std_logic;
           RF_WrEn:in std_logic;
           RF_WrEn_IDEX:out std_logic;

           
           ImmCalc:in std_logic;
           ImmCalc_IDEX:out std_logic;
           func:in signed(5 downto 0);
           func_IDEX:out signed(5 downto 0);
           ALUop:in signed(2 downto 0);
           ALUop_IDEX:out signed(2 downto 0);
           
           EXMEM_WrEn:in std_logic;
           EXMEM_WrEn_IDEX: out std_logic
           
            );
end COMPONENT;
 
 COMPONENT EXMEM_C is

 Port (
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           EXMEM_WrEn_IDEX : in STD_LOGIC;
          
           Mem_WrEn_IDEX:in std_logic;
           Mem_WrEn_EXMEM:out std_logic;
           MEMWB_WrEn_IDEX:in std_logic;
           MEMWB_WrEn_EXMEM:out std_logic;
           Mem_Read_IDEX:in std_logic;
           Mem_Read_EXMEM:out std_logic;
           ByteOp_IDEX:in std_logic;
           ByteOp_EXMEM :out std_logic;
           PCWrite_IDEX:in std_logic;
           PCWrite_EXMEM:out std_logic;
           PCWriteCondBeq_IDEX:in std_logic;
           PCWriteCondBeq_EXMEM:out std_logic;
           PCWriteCondBne_IDEX:in std_logic;
           PCWriteCondBne_EXMEM:out std_logic;


           RF_WrData_sel_IDEX:in std_logic;
           RF_WrData_sel_EXMEM:out std_logic;
           RF_WrEn_IDEX:in std_logic;
           RF_WrEn_EXMEM:out std_logic

           
           
           
            );
end COMPONENT;


COMPONENT WB_C is
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           RF_WrData_sel:in std_logic;
           RF_WrData_sel_reg:out std_logic;
           RF_WrEn:in std_logic;
           RF_WrEn_reg:out std_logic
           );
end COMPONENT;

COMPONENT ForwardingUnit is 
Port ( 
  rs_IDEX:in signed(4 downto 0);
 RF_B_Mux_out_IDEX: in signed(4 downto 0);
 
 rd_EXMEM: in signed(4 downto 0);
 rd_MEMWB: in signed(4 downto 0);
 
 EXMEM_RF_WrEn:in STD_LOGIC;
 MEMWB_RF_WrEn:in STD_LOGIC;
 
 ForwardA:out std_logic_vector(1 downto 0);
 ForwardB:out std_logic_vector(1 downto 0)
 );
end COMPONENT;


COMPONENT HazardDetectionUnit is
Port (
    Mem_Read_IDEX:in std_logic;
    rd_IDEX:in signed(4 downto 0);
    rs_IFID:in signed(4 downto 0);
    RF_B_mux_out_IFID:in signed(4 downto 0);
    
    PC_LdEn:out std_logic;
    IFID_WrEn:out std_logic;
    ControlMux_sel:out std_logic;
  
  
    Clk: in std_logic;
    Reset:in std_logic
 );
end COMPONENT;

COMPONENT Control_Mux is
  Port ( 
  
  Mem_WrEn:in std_logic;
  Mem_WrEn_mux:out std_logic;
  
  Mem_Read:in std_logic;
  Mem_Read_mux:out std_logic;
  
  RF_WrEn:in std_logic;
  RF_WrEn_mux:out std_logic;
  
  
  IDEX_WrEn:in std_logic;
  IDEX_WrEn_mux:out std_logic;
   
 MEMWB_WrEn:in std_logic;
  MEMWB_WrEn_mux:out std_logic;
  
  EXMEM_WrEn:in std_logic;
 EXMEM_WrEn_mux:out std_logic;
  
  ControlMux_sel:in std_logic
  );
end COMPONENT;

begin

ALU_CONTR: ALU_Control PORT MAP ( 
 ALUop=>ALUop_IDEX,
 func=>func_IDEX,
 ALU_func=>ALU_func
 
 );
 
 Main_Contr:Main_Control
 PORT MAP (
 Instr=>Instr_IFID,
 PCWrite=>PCWrite_C,
 PCWriteCondBeq=>PCWriteCondBeq_C,
 PCWriteCondBne=>PCWriteCondBne_C,
 ImmExt=>ImmExt,
 RF_B_sel=>RF_B_sel,
 IDEX_WrEn=>IDEX_WrEn_C,--MUX,
 ALUop=>ALUop_C,--?? ???? ???? c
 ImmCalc=>ImmCalc_C,--IDEX
 EXMEM_WrEn=>EXMEM_WrEn_C,--MUX
 Mem_WrEn=>Mem_WrEn_C,--IDEX
 Mem_Read=>Mem_Read_C,--MUX
 MEMWB_WrEn=>MEMWB_WrEn_C,--MUX
 ByteOp=>ByteOp_C,--IDEX
 RF_WrData_sel=>RF_WrData_sel_C,--IDEX
 RF_WrEn=>RF_WrEn_C--MUX
 );

IDEX:IDEX_C 
  Port MAP (
           CLK=>CLK,
           RST=>Reset,
           IDEX_WrEn =>IDEX_WrEn_mux,    
           Mem_WrEn=>Mem_WrEn_mux,
           Mem_WrEn_IDEX=>Mem_WrEn_IDEX,
           MEMWB_WrEn=>MEMWB_WrEn_mux,
           MEMWB_WrEn_IDEX=>MEMWB_WrEn_IDEX,
           Mem_Read=>Mem_Read_mux,
           Mem_Read_IDEX=>Mem_Read_IDEX,--hdu
           ByteOp=>ByteOp_C,
           ByteOp_IDEX=>ByteOp_IDEX,
           PCWrite=>PCWrite_C,
           PCWrite_IDEX=>PCWrite_IDEX,
           PCWriteCondBeq=>PCWriteCondBeq_C,
           PCWriteCondBeq_IDEX=>PCWriteCondBeq_IDEX,
           PCWriteCondBne=>PCWriteCondBne_C,
           PCWriteCondBne_IDEX=>PCWriteCondBne_IDEX,
           RF_WrData_sel=>RF_WrData_sel_C,
           RF_WrData_sel_IDEX=>RF_WrData_sel_IDEX,
           RF_WrEn=>RF_WrEn_mux,
           RF_WrEn_IDEX=>RF_WrEn_IDEX,         
           ImmCalc=>ImmCalc_C,
           ImmCalc_IDEX=>ImmCalc_IDEX,--FU
           func=>Instr_IFID(5 DOWNTO 0),
           func_IDEX=>func_IDEX,
           ALUop=>ALUop_C,
           ALUop_IDEX=>ALUop_IDEX,--ALUCONTROL
           EXMEM_WrEn=>EXMEM_WrEn_mux,
           EXMEM_WrEn_IDEX=>EXMEM_WrEn_IDEX
           
            );
      
EXMEM:EXMEM_C 
  Port MAP (
           CLK=>CLK,
           RST=>Reset,
           EXMEM_WrEn_IDEX=>EXMEM_WrEn_IDEX,
           Mem_WrEn_IDEX=>Mem_WrEn_IDEX,
           Mem_WrEn_EXMEM=>Mem_WrEn_EXMEM,--meme
           MEMWB_WrEn_IDEX=>MEMWB_WrEn_IDEX,
           MEMWB_WrEn_EXMEM=>MEMWB_WrEn_EXMEM,
           Mem_Read_IDEX=>Mem_Read_IDEX,
           Mem_Read_EXMEM=>open,
           ByteOp_IDEX=>ByteOp_IDEX,
           ByteOp_EXMEM=>ByteOp,
           PCWrite_IDEX=>PCWrite_IDEX,
           PCWrite_EXMEM=>PCWrite_EXMEM,--and
           PCWriteCondBeq_IDEX=>PCWriteCondBeq_IDEX,
           PCWriteCondBeq_EXMEM=>PCWriteCondBeq_EXMEM,
           PCWriteCondBne_IDEX=>PCWriteCondBne_IDEX,
           PCWriteCondBne_EXMEM=>PCWriteCondBne_EXMEM,
           RF_WrData_sel_IDEX=>RF_WrData_sel_IDEX,
           RF_WrData_sel_EXMEM=>RF_WrData_sel_EXMEM,
           RF_WrEn_IDEX=>RF_WrEn_IDEX,
           RF_WrEn_EXMEM=>RF_WrEn_EXMEM        
);

MEMWB_C:WB_C
Port map (   
           CLK=>CLK,
           RST=>Reset,
           WE=>MEMWB_WrEn_EXMEM,
           RF_WrData_sel=>RF_WrData_sel_EXMEM,
           RF_WrData_sel_reg=>RF_WrData_sel,
           RF_WrEn=>RF_WrEn_EXMEM,
           RF_WrEn_reg=>RF_WrEn_WB
           );
           
           
 FORWARDING_UNIT:ForwardingUnit Port MAP ( 
         rs_IDEX=>rs_IDEX,
         RF_B_Mux_out_IDEX=>RF_B_Mux_out_IDEX,       
         rd_EXMEM=>rd_EXMEM,
         rd_MEMWB=>rd_MEMWB,      
         EXMEM_RF_WrEn=>RF_WrEn_EXMEM,
         MEMWB_RF_WrEn=>RF_WrEn_WB,         
         ForwardA=>ALU_Ain_Sel,
         ForwardB=>ALU_Bin_Sel
 );      
 
 
 HAZARD_DETECTION_UNIT:HazardDetectionUnit
Port MAP ( 
    Mem_Read_IDEX=>Mem_Read_IDEX,
    rd_IDEX=>rd_IDEX,
    rs_IFID=>Instr_IFID(25 downto 21),
    RF_B_mux_out_IFID=>RF_B_mux_out_IFID,  
    PC_LdEn=>PC_LdEn,  
    IFID_WrEn=>IFID_WrEn,  
    ControlMux_sel=>ControlMux_sel,
      Clk=>Clk,
      Reset=>Reset
    
    
 );
 
  Control_Multiplexor:Control_Mux Port MAP ( 
  Mem_WrEn=>Mem_WrEn_C,
  Mem_WrEn_mux=>Mem_WrEn_mux,
  Mem_Read=>Mem_Read_C,
  Mem_Read_mux=>Mem_Read_mux,  
  RF_WrEn=>RF_WrEn_C,
  RF_WrEn_mux=>RF_WrEn_mux, 
IDEX_WrEn=>IDEX_WrEn_C,
IDEX_WrEn_mux=>IDEX_WrEn_mux,   
  MEMWB_WrEn=>MEMWB_WrEn_C,
  MEMWB_WrEn_mux=>MEMWB_WrEn_mux, 
  EXMEM_WrEn=>EXMEM_WrEn_C,
 EXMEM_WrEn_mux=>EXMEM_WrEn_mux, 
  ControlMux_sel=>ControlMux_sel
  );
 
  
 EXMEM_WrEn<=EXMEM_WrEn_IDEX;   
 MEMWB_WrEn<=MEMWB_WrEn_EXMEM;
 Mem_WrEn<=Mem_WrEn_EXMEM;
 IDEX_WrEn<=IDEX_WrEn_mux;
 RF_WrEn<=RF_WrEn_WB;
 
 PC_sel<='1' WHEN  (PCWrite_EXMEM ='1')OR((PCWriteCondBeq_EXMEM ='1') AND (ALU_zero_EXMEM='1')) OR((PCWriteCondBne_EXMEM='1') AND (ALU_zero_EXMEM='0'))
    ELSE '0';
 
end Behavioral;
