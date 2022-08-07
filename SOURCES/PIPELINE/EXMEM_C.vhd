----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/16/2020 05:50:09 PM
-- Design Name: 
-- Module Name: EXMEM_C - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EXMEM_C is
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
end EXMEM_C;

architecture Behavioral of EXMEM_C is
Component MEM_C 
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           
           
           Mem_WrEn:in std_logic;
           Mem_WrEn_reg:out std_logic;
           MEMWB_WrEn:in std_logic;
           MEMWB_WrEn_reg:out std_logic;
           Mem_Read:in std_logic;
           Mem_Read_reg:out std_logic;
           ByteOp :in std_logic;
           ByteOp_reg :out std_logic;
           PCWrite:in std_logic;
           PCWrite_reg:out std_logic;
           PCWriteCondBeq:in std_logic;
           PCWriteCondBeq_reg:out std_logic;
           PCWriteCondBne:in std_logic;
           PCWriteCondBne_reg:out std_logic

           );
end component;

component WB_C 
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           RF_WrData_sel:in std_logic;
           RF_WrData_sel_reg:out std_logic;
           RF_WrEn:in std_logic;
           RF_WrEn_reg:out std_logic
           );
end component;

begin

EXMEM_MEM_C:MEM_C
Port map (    
           CLK=>CLK,
           RST=>RST,
           WE=>EXMEM_WrEn_IDEX,
           
           Mem_WrEn=>Mem_WrEn_IDEX,
           Mem_WrEn_reg=>Mem_WrEn_EXMEM,
           MEMWB_WrEn=>MEMWB_WrEn_IDEX,
           MEMWB_WrEn_reg=>MEMWB_WrEn_EXMEM,
           Mem_Read=>Mem_Read_IDEX,
           Mem_Read_reg=>Mem_Read_EXMEM,
           ByteOp=>ByteOp_IDEX,
           ByteOp_reg=>ByteOp_EXMEM,
           PCWrite=>PCWrite_IDEX,
           PCWrite_reg=>PCWrite_EXMEM,
           PCWriteCondBeq=>PCWriteCondBeq_IDEX,
           PCWriteCondBeq_reg=>PCWriteCondBeq_EXMEM,
           PCWriteCondBne=>PCWriteCondBne_IDEX,
           PCWriteCondBne_reg=>PCWriteCondBne_EXMEM

           );
           
EXMEM_WB_C:WB_C
Port map (   
           CLK=>CLK,
           RST=>RST,
           WE=>EXMEM_WrEn_IDEX,
           RF_WrData_sel=>RF_WrData_sel_IDEX,
           RF_WrData_sel_reg=>RF_WrData_sel_EXMEM,
           RF_WrEn=>RF_WrEn_IDEX,
           RF_WrEn_reg=>RF_WrEn_EXMEM
           );
           
end Behavioral;
