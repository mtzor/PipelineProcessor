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

entity WB_C is
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           RF_WrData_sel:in std_logic;
           RF_WrData_sel_reg:out std_logic;
           RF_WrEn:in std_logic;
           RF_WrEn_reg:out std_logic
           );
end WB_C;

architecture Behavioral of WB_C is


Component Register1bit
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in std_logic;
           DataOut : out std_logic);
           end component;           
begin
RF_WrEn_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => RF_WrEn,
          DataOut => RF_WrEn_reg  
        );
RF_WrData_sel_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => RF_WrData_sel,
          DataOut => RF_WrData_sel_reg
         
        );
        

end Behavioral;
