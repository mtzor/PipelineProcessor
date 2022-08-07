----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2020 08:33:29 PM
-- Design Name: 
-- Module Name: HazardDetectionUnit - Behavioral
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

entity HazardDetectionUnit is
Port (
    Clk: in std_logic;
    Reset:in std_logic;
    Mem_Read_IDEX:in std_logic;
    rd_IDEX:in signed(4 downto 0);
    rs_IFID:in signed(4 downto 0);
    RF_B_mux_out_IFID:in signed(4 downto 0);
    
    PC_LdEn:out std_logic;
    IFID_WrEn:out std_logic;
    ControlMux_sel:out std_logic
    
 );
end HazardDetectionUnit;

architecture Behavioral of HazardDetectionUnit is

TYPE State_type IS (S0,S1) ;
SIGNAL currentS, nextS : State_type ;
BEGIN

fsm_synch: process (clk, Reset)  begin 
if (Reset = '1') THEN 
    currentS <= S0 ;
elsif (rising_edge(clk))  then     
    currentS <= nextS; 
end if;
end process fsm_synch; 

fsm_comb: process (currentS, Mem_Read_IDEX,rd_IDEX,rs_IFID,RF_B_mux_out_IFID)  begin

CASE currentS IS

 WHEN S0 =>         IF (Mem_Read_IDEX='1' and 
                    ((rd_IDEX=rs_IFID) or rd_IDEX = RF_B_mux_out_IFID)) THEN
                    nextS<= S1 ;
                    ELSE    
                    nextS<= S0;
                    END IF;
 
 WHEN S1 =>         nextS<= S0; 

 WHEN others=>      nextS <= S0;    
 
 end case;  
 end process fsm_comb; 

PC_Lden<='0' when currentS=S1 else
         '1';

IFID_WrEn<='0' when currentS=S1 else
           '1';
           
ControlMux_sel<='1' when currentS=S1 else
                '0';
end Behavioral;
