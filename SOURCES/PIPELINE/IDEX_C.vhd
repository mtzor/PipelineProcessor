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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IDEX_C is
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
end IDEX_C;

architecture Behavioral of IDEX_C is
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


component EX_C 
Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           ImmCalc:in std_logic;
           ImmCalc_reg:out std_logic;
           func:in signed(5 downto 0);
           func_reg:out signed(5 downto 0);
           ALUop:in signed(2 downto 0);
           ALUop_reg:out signed(2 downto 0);
           
           EXMEM_WrEn:in std_logic;
           EXMEM_WrEn_reg: out std_logic
           
           );
      end component;
begin


IDEX_MEM_C:MEM_C
Port map (    
           CLK=>CLK,
           RST=>RST,
           WE=>IDEX_WrEn,
           
           Mem_WrEn=>Mem_WrEn,
           Mem_WrEn_reg=>Mem_WrEn_IDEX,
           MEMWB_WrEn=>MEMWB_WrEn,
           MEMWB_WrEn_reg=>MEMWB_WrEn_IDEX,
           Mem_Read=>Mem_Read,
           Mem_Read_reg=>Mem_Read_IDEX,
           ByteOp=>ByteOp,
           ByteOp_reg =>ByteOp_IDEX,
           PCWrite=>PCWrite,
           PCWrite_reg=>PCWrite_IDEX,
           PCWriteCondBeq=>PCWriteCondBeq,
           PCWriteCondBeq_reg=>PCWriteCondBeq_IDEX,
           PCWriteCondBne=>PCWriteCondBne,
           PCWriteCondBne_reg=>PCWriteCondBne_IDEX

           );
           
IDEX_WB_C:WB_C
Port map (   
           CLK=>CLK,
           RST=>RST,
           WE=>IDEX_WrEn,
           RF_WrData_sel=>RF_WrData_sel,
           RF_WrData_sel_reg=>RF_WrData_sel_IDEX,
           RF_WrEn=>RF_WrEn,
           RF_WrEn_reg=>RF_WrEn_IDEX
           );


IDEX_EX_C: EX_C
Port map (
            CLK=>CLK,
           RST=>RST,
           WE=>IDEX_WrEn,
           ImmCalc=>ImmCalc,
           ImmCalc_reg=>ImmCalc_IDEX,
           func=>func,
           func_reg=>func_IDEX,
           ALUop=>ALUop,
           ALUop_reg=>ALUop_IDEX,
           
           EXMEM_WrEn=>EXMEM_WrEn,
           EXMEM_WrEn_reg=>EXMEM_WrEn_IDEX
           
           );           
end Behavioral;
