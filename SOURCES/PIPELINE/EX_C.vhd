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

entity EX_C is
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           ImmCalc:in std_logic;
           ImmCalc_reg:out std_logic;
           ALUop:in signed(2 downto 0);
           ALUop_reg:out signed(2 downto 0);
           func:in signed(5 downto 0);
           func_reg:out signed(5 downto 0);
           EXMEM_WrEn:in std_logic;
           EXMEM_WrEn_reg: out std_logic
           
           );
end EX_C;

architecture Behavioral of EX_C is


Component Register1bit
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in std_logic;
           DataOut : out std_logic);
           end component; 


Component Register3bit          
            Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (2 downto 0);
           DataOut : out signed (2 downto 0));      
            end component;   
            
            
Component Register6bit          
            Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (5 downto 0);
           DataOut : out signed (5 downto 0));      
            end component;  
begin
ImmCalc_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => ImmCalc,
          DataOut => ImmCalc_reg  
        );
EXMEM_WrEn_register: Register1bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => EXMEM_WrEn,
          DataOut => EXMEM_WrEn_reg
         
        );
 ALUop_register: Register3bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => ALUop,
          DataOut => ALUop_reg
         
        );      
func_register: Register6bit PORT MAP (
          CLK=> CLK,
          RST => RST,
          WE => WE,
          DataIn => func,
          DataOut => func_reg
         
        );
end Behavioral;
