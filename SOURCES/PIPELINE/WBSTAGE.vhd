----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/11/2020 04:11:33 PM
-- Design Name: 
-- Module Name: WBSTAGE - Behavioral
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

entity WBSTAGE is
 Port (    ALU_out : in signed (31 downto 0);
           MEM_out : in signed (31 downto 0);
           RF_WrData_sel : in STD_LOGIC;
           RF_WrData: out signed (31 downto 0)
            );
end WBSTAGE;

architecture Behavioral of WBSTAGE is
COMPONENT MUX32_2_1
    Port ( A : in signed(31 downto 0);
           B : in signed (31 downto 0);
           sel : in STD_LOGIC;
           Output : out signed (31 downto 0));
END COMPONENT;

begin

MUX_Write: MUX32_2_1 PORT MAP (
      A => ALU_out,
      B => MEM_out,
      sel => RF_wrData_sel,
      Output => RF_WrData
         );
end Behavioral;
