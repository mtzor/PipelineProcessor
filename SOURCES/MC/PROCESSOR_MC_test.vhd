----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2020 06:42:38 PM
-- Design Name: 
-- Module Name: PROC_SC_test - Behavioral
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

entity PROCESSOR_MC_test is
--  Port ( );
end PROCESSOR_MC_test;

architecture Behavioral of PROCESSOR_MC_test is


COMPONENT PROCESSOR_MC IS 
Port (
Reset:in std_logic;
Clk:in std_logic

 );
 END COMPONENT;
 
 signal Reset,Clk: std_logic;
 constant clk_period : time := 22 ns;

Begin 

 Uut:PROCESSOR_MC PORT MAP(
 Reset=>Reset,
 Clk=>Clk
 );
 
 clk_process :process
   begin
		Clk <= '0';
		wait for clk_period/2;
		Clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
           Reset<='1';
      wait for 22 ns;	
Reset<='0';
      wait for 22 ns;	

wait;
   end process;
end Behavioral;
