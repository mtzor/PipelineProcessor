
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/22/2020 12:13:46 PM
-- Design Name: 
-- Module Name: MUX_Address - Behavioral
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

entity MUX_32_4_1 is
 Port ( 
         A:in signed (31 downto 0) ;
         B:in signed (31 downto 0) ;
         C :in signed (31 downto 0) ;
         D:in signed(31 downto 0);
         sel:in std_logic_vector(1 downto 0);
         MUX_Out: out signed (31 downto 0) );
end MUX_32_4_1;

architecture Behavioral of MUX_32_4_1 is

begin
MUX_Out<= A when (sel="00") else 
		 B when (sel="01") else 
		 C when (sel="10") else
		 D;
	

end Behavioral;
