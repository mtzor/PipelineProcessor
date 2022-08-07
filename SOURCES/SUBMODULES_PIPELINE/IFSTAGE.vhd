----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2020 09:13:39 PM
-- Design Name: 
-- Module Name: PC_Calculator - Behavioral
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

entity IFSTAGE is
    Port ( PC_Sel : in STD_LOGIC;
           PC_LdEn : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           PC_Immed : in signed (31 downto 0);
           PC_Inc :out signed (31 downto 0);
           PC : out signed (31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is

signal PCInc_temp,PC_ImmedInc_temp,PC_temp,PC_mux_temp : signed(31 downto 0);

COMPONENT MUX32_2_1
    Port ( A : in signed(31 downto 0);
           B : in signed (31 downto 0);
           sel : in STD_LOGIC;
           Output : out signed (31 downto 0));
END COMPONENT;

           
COMPONENT Incrementor 
    PORT ( PC : in  signed (31 downto 0);
           PCInc : out  signed (31 downto 0)
           );
end COMPONENT;

COMPONENT  PCRegisterModule is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (31 downto 0);
           DataOut : out signed (31 downto 0));
end COMPONENT;

begin

Inc_inst: Incrementor PORT MAP (
         PC =>PC_temp,
         PCInc =>PCInc_temp          
        );
        

MUX: MUX32_2_1 PORT MAP (
          A => PCInc_temp,
          B => PC_Immed ,
          sel =>PC_Sel ,
          Output =>PC_mux_temp
        );
        
PC_register: PCRegisterModule PORT MAP (
          CLK=> CLK,
          RST => Reset,
          WE => PC_LdEn,
          DataIn => PC_mux_temp,
          DataOut => PC_temp
         
        );
        
        PC<=PC_temp;
        PC_Inc<= PCInc_temp;
        
end Behavioral;
