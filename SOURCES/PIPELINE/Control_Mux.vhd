----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/17/2020 03:14:43 PM
-- Design Name: 
-- Module Name: Control_Mux - Behavioral
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

entity Control_Mux is
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
end Control_Mux;

architecture Behavioral of Control_Mux is

begin

Mem_WrEn_mux<=Mem_WrEn WHEN ControlMux_sel='0' ELSE '0';
Mem_Read_mux<=Mem_Read WHEN ControlMux_sel='0' ELSE '0';
RF_WrEn_mux<= RF_WrEn WHEN ControlMux_sel='0' ELSE '0';
IDEX_WrEn_mux<=IDEX_WrEn WHEN ControlMux_sel='0' ELSE '0';
MEMWB_WrEn_mux<= MEMWB_WrEn WHEN ControlMux_sel='0' ELSE '0';
EXMEM_WrEn_mux<=EXMEM_WrEn WHEN ControlMux_sel='0' ELSE '0';

end Behavioral;
