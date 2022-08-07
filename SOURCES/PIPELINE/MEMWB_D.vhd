----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2020 08:43:58 PM
-- Design Name: 
-- Module Name: MEMWB_D - Behavioral
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

entity MEMWB_D is
  Port ( 
           CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
         rd : in  signed  (4 downto 0);
           rd_Reg : out  signed  (4 downto 0);
            ALU_out: in  signed  ( 31 downto 0);
           ALU_out_Reg: out  signed  ( 31 downto 0);
            MEM_out: in  signed  ( 31 downto 0);
            MEM_out_Reg: out  signed  ( 31 downto 0)
  );
end MEMWB_D;

architecture Behavioral of MEMWB_D is
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
begin

ALU_out_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => ALU_out,
          DataOut => ALU_out_Reg
         
        );
MEM_out_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => MEM_out,
          DataOut => MEM_out_Reg
         
        );
rd_Register: Register5bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => rd,
          DataOut => rd_Reg 
        );   
end Behavioral;
