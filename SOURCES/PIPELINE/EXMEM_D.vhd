----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2020 08:37:36 PM
-- Design Name: 
-- Module Name: EXMEM_D - Behavioral
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

entity EXMEM_D is
  Port ( 
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           PC_Immed:in  signed  ( 31 downto 0);
           PC_Immed_Reg:out signed  ( 31 downto 0);
           ALU_out: in  signed  ( 31 downto 0);
           ALU_out_Reg: out  signed  ( 31 downto 0);
           Zero: in  STD_LOGIC;
           Zero_Reg:out  STD_LOGIC;
           RF_B:in  signed  ( 31 downto 0);
           RF_B_Reg:out  signed  ( 31 downto 0);
           rd : in  signed  (4 downto 0);
           rd_Reg : out  signed  (4 downto 0)
  );
end EXMEM_D;

architecture Behavioral of EXMEM_D is
Component RegisterModule
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (31 downto 0);
           DataOut : out signed (31 downto 0)
           );
           end component;

Component Register5bit
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (4 downto 0);
           DataOut : out signed (4 downto 0));
           end component;       
 
 Component Register1bit
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in STD_LOGIC;
           DataOut : out STD_LOGIC);
           end component;                    
begin
ALU_out_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => ALU_out,
          DataOut => ALU_out_Reg
         
        );
PC_Immed_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => PC_Immed,
          DataOut => PC_Immed_Reg
         
        );
        
RF_B_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => RF_B,
          DataOut => RF_B_Reg
         
        );
               
rd_Register: Register5bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => rd,
          DataOut => rd_Reg 
        );   

zero_Register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => Zero,
          DataOut => Zero_Reg 
        );  
end Behavioral;
