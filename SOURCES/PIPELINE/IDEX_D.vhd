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

entity IDEX_D is
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           PC:in  signed  (31 downto 0);
           PC_Reg:out  signed  (31 downto 0);
           Immed: in  signed  (31 downto 0);
           Immed_Reg: out  signed  (31 downto 0);
           RF_A: in  signed  (31 downto 0);
           RF_A_Reg: out signed  (31 downto 0);
           RF_B: in  signed  (31 downto 0);
           RF_B_Reg: out signed  (31 downto 0);
           rs: in  signed  (4 downto 0);
           rs_Reg : out  signed  (4 downto 0);
           rd : in  signed  (4 downto 0);
           rd_Reg : out  signed  (4 downto 0);
           RF_B_out : in  signed  (4 downto 0);
           RF_B_out_Reg: out  signed  (4 downto 0)
           
           
           );
end IDEX_D;

architecture Behavioral of IDEX_D is
 Component RegisterModule
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (31 downto 0);
           DataOut : out signed (31 downto 0));
           end component;
           

Component Register5bit
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (4 downto 0);
           DataOut : out signed (4 downto 0));
           end component;           
begin
PC_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => PC,
          DataOut => PC_Reg  
        );
RFA_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => RF_A,
          DataOut => RF_A_Reg
         
        );
        
RFB_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => RF_B,
          DataOut => RF_B_Reg
         
        );
        
 Immed_Register: RegisterModule PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => Immed,
          DataOut =>Immed_Reg
         
        );
 rd_Register: Register5bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => rd,
          DataOut => rd_Reg 
        );   
 rs_Register: Register5bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => rs,
          DataOut => rs_Reg 
        );       
  RF_B_out_mux_Register: Register5bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => RF_B_out,
          DataOut => RF_B_out_Reg 
        );        
end Behavioral;
