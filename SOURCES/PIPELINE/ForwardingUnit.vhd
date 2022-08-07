----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/15/2020 06:10:54 PM
-- Design Name: 
-- Module Name: ForwardingUnit - Behavioral
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

--use ieee.std_logic_arith.all;-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ForwardingUnit is 
Port ( 
 rs_IDEX:in signed(4 downto 0);
 RF_B_Mux_out_IDEX: in signed(4 downto 0);
 
 rd_EXMEM: in signed(4 downto 0);
 rd_MEMWB: in signed(4 downto 0);
 
 EXMEM_RF_WrEn:in STD_LOGIC;
 MEMWB_RF_WrEn:in STD_LOGIC;
 
 ForwardA:out std_logic_vector(1 downto 0);
 ForwardB:out std_logic_vector(1 downto 0)
 );
end ForwardingUnit;

architecture Behavioral of ForwardingUnit is

begin

ForwardA<=  "10" when ((EXMEM_RF_WrEn='1') and (rd_EXMEM /= "00000")and (rd_EXMEM = rs_IDEX ) ) else--AluRegOut
            "01" when ((MEMWB_RF_WrEn='1') and (rd_MEMWB /="00000")and (rd_MEMWB = rs_IDEX)) else--Rf_WrData
            "00";
            
ForwardB<=  "10" when (EXMEM_RF_WrEn='1' and (rd_EXMEM/="00000")and (rd_EXMEM = RF_B_Mux_out_IDEX)) else
            "01" when (MEMWB_RF_WrEn='1' and (rd_MEMWB/="00000")and (rd_MEMWB = RF_B_Mux_out_IDEX)) else
            "00";            
           

end Behavioral;
