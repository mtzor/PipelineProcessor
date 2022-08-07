----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2020 04:37:59 PM
-- Design Name: 
-- Module Name: Main_Control - Behavioral
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

entity Main_Control is
Port (
 Instr :in signed(31 downto 0); 
 --IF
 PCWrite:out std_logic;
 PCWriteCondBeq:out std_logic;
 PCWriteCondBne:out std_logic;
 --DEC
 ImmExt :out std_logic_vector(1 downto 0);
 RF_B_sel:out std_logic;
 IDEX_WrEn:out std_logic;
--EX
 ALUop:out signed(2 downto 0);
 ImmCalc:out std_logic;
 EXMEM_WrEn:out std_logic;
 --MEM
 Mem_WrEn :out std_logic;
 Mem_Read:out std_logic;
 MEMWB_WrEn:out StD_LoGiC;

 ByteOp :out std_logic;
 
 --WB
 RF_WrData_sel:out std_logic;
 RF_WrEn:out std_logic

 );
end Main_Control;

architecture Behavioral of Main_Control is
signal op : signed(5 downto 0);
begin
ALUop<= "000" when (op="111000" or op="111001"or op="110000" or op="000011"or op="000111"or op="001111"or op="011111") else--add 
        "001" when (op="000000" or op="000001" or op="111111") else
        "010" when (op="110011") else 
        "011" when (op="110010") else
        "100" when (op="100000") else
        "111";

ImmCalc<='0' when (op="100000") else--add 
         '1'; 

ByteOp<= '1' when (op="000011" or op="000111") else--sb lb 
         '0';
         

RF_WrEn<='1' when (op="100000" or op="111000" or op="111001"or op="110000" or
                   op="110010" or op="110011"or op="000011"or op="001111") else       
         '0';

PCWriteCondBeq<= '1' when (op="000000" ) else 
              '0';
PCWriteCondBne<= '1' when (op="000001" ) else 
              '0';              
              
PCWrite<= '1' when op="111111"  else 
          '0';              
Mem_WrEn <= '1' when (op="000111" or op="011111") else
            '0';
    
RF_B_sel<='1'  when ( op="000000" or op="000001" or op="000111" or op="011111") else
          '0';  

RF_WrData_sel<='1' when ( op="000011" or op="001111" ) else
               '0'; 
Mem_Read<='1' when ( op="000011" or op="001111" ) else
               '0';        
             
ImmExt<= "00" when (op="100000" or op="110010" or op="110011") else
         "11" when (op="111001") else
         "10" when (op="000000" or op="000001" or op="111111") else
         "01";

IDEX_WrEn<='1';
EXMEM_WrEn<='1';
MEMWB_WrEn<='1';                  
op<=Instr(31 downto 26);        
end Behavioral;
