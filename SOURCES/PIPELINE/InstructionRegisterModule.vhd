----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/25/2020 10:33:09 PM
-- Design Name: 
-- Module Name: Register - Behavioral
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

entity InstructionRegisterModule is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (31 downto 0);
           DataOut : out signed (31 downto 0));
end InstructionRegisterModule;

architecture Behavioral of InstructionRegisterModule is

begin

register_synch: process (CLK,RST,WE,DataIn) 
		begin 
		if (RST='1')                then     DataOut <= "10000000000000000000000000000000" after 10ns;
		elsif (rising_edge(CLK) AND WE='1') 	 then     DataOut <= DataIn after 10ns;
		end if; 
 
	end process register_synch;

end Behavioral;
