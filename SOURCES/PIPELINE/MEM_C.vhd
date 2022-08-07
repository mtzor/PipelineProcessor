----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2020 08:19:19 PM
-- Design Name: 
-- Module Name: IDEX_D - Behavioral
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

entity MEM_C is
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
end MEM_C;

architecture Behavioral of MEM_C is


Component Register1bit
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in std_logic;
           DataOut : out std_logic);
           end component;           
begin
Mem_WrEn_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => Mem_WrEn,
          DataOut => Mem_WrEn_reg  
        );
MEMWB_WrEn_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => MEMWB_WrEn,
          DataOut => MEMWB_WrEn_reg
         
        );
        
Mem_Read_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => Mem_Read,
          DataOut => Mem_Read_reg
         
        );
        
 PCWrite_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => PCWrite,
          DataOut => PCWrite_reg
         
        );       
 PCWriteCondBeq_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => PCWriteCondBeq,
          DataOut => PCWriteCondBeq_reg
         
        );       
PCWriteCondBne_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => PCWriteCondBne,
          DataOut => PCWriteCondBne_reg
         
        );            
ByteOP_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => ByteOp,
          DataOut => ByteOp_reg
         
        );       
end Behavioral;
