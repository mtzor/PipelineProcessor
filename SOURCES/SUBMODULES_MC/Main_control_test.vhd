----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2020 03:45:55 PM
-- Design Name: 
-- Module Name: Control_test - Behavioral
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

entity Main_control_test is
--  Port ( );
end Main_control_test;

architecture Behavioral of Main_control_test is
Component Main_Control
Port (
 Instr :in signed(31 downto 0); 
 Clk:in std_logic;
 ALU_zero:in std_logic;
 Reset:in std_logic;

 
 Mem_WrEn :out std_logic;
 RF_WrData_sel:out std_logic;
 RF_B_sel:out std_logic;
 RF_WrEn:out std_logic;
 InstReg_WrEn:out std_logic;
 ALU_Bin_Sel:out std_logic_vector(1 downto 0);
 ALU_Ain_Sel:out std_logic;
 ImmExt :out std_logic_vector(1 downto 0);
 ByteOp :out std_logic;
 ALUop:out signed(2 downto 0);
 PC_sel:out std_logic_vector(1 downto 0);
 PC_LdEn:out std_logic
  );
     END COMPONENT;
     --Inputs
 signal Instr:signed(31 downto 0):= (others => '0');    
 signal ALU_Zero,Reset,Clk,InstReg_WrEn:std_logic:= '0';
    --Outputs
  signal Mem_WrEn,RF_WrData_sel,ALU_Ain_Sel,RF_B_sel,RF_WrEn,ByteOp,PC_LdEn:std_logic;   
  signal ImmExt,ALU_Bin_Sel,PC_sel : std_logic_vector(1 downto 0);
  signal  ALUop: signed(2 downto 0);
 constant clk_period : time := 200 ns;

begin
uut:Main_Control
Port Map (
    
     Instr =>Instr,
     Clk=>Clk,
     ALU_Zero=>ALU_Zero,
     Reset=>Reset,

     Mem_WrEn =>Mem_WrEn,
     RF_WrData_sel=>RF_WrData_sel,
     RF_B_sel=>RF_B_sel,
     RF_WrEn=>RF_WrEn,
     InstReg_WrEn=>InstReg_WrEn,
     ALU_Bin_Sel=>ALU_Bin_Sel,
     ALU_Ain_Sel=>ALU_Ain_Sel,
     ImmExt=>ImmExt,
     ByteOp=>ByteOp,
     ALUop=>ALUop,
     PC_sel=>PC_sel,
     PC_LdEn=>PC_LdEn
     
     
     );
     
       -- Clock process definitions
   clk_process :process
   begin
		CLK <= '0';
		wait for clk_period/2;
		CLK <= '1';
		wait for clk_period/2;
   end process;
 
 stim_proc: process
   begin		
           Reset<='1';
   
      wait for clk_period ;
      
     
      
      --add
      Instr<="10000000010000110000100000110000";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns  ;
      
      --sub
    
      Instr<="10000000010001000000100000110001";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      
      --and
      
      Instr<="10000000011001010000100000110010";
      ALU_Zero<='0';
      Reset<='0';
       wait for 800 ns;
       
      --or
   
      Instr<="10000000011001100000100000110011";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;

      --not
      Instr<="10000000001001110000000000110100";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      --nand
       
      Instr<="10000000001010000001100000110101";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;

      --nor
      
      Instr<="10000000001010010001100000110110";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;

      --sra
 
      Instr<="10000001001010100000000000111000";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      
      --srl
      
      Instr<="10000001001010110000000000111001";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      
      --sll
 
      Instr<="10000000001011000000000000111010";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      --rol
      
       
      Instr<="10000000001011010000000000111100";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      
      --ror
      
 
      Instr<="10000000001011100000000000111101";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      
        --li
    
      Instr<="11100000000000010000000000000001";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      
      --lui
     
      Instr<="11100100000011110000000000000001";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
     
      --addi
   
      Instr<="11000000001100000000000000000001";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      
      --nandi
       
      Instr<="11001000001100010000000000000010";
      ALU_Zero<='0';
      Reset<='0';
       wait for 800 ns;
      --ori
     
      Instr<="11001100001100100000000000000011";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;
      
      --b
     
      Instr<="11111100000000000000000000000011";
      ALU_Zero<='1';
      Reset<='0';
      wait for 600 ns;
      
      --beq
     
      Instr<="00000000001001000000000000000010";
      ALU_Zero<='1';
      Reset<='0';
      wait for 600 ns;

      --bne
  
      Instr<="00000100001000100000000000000011";
      ALU_Zero<='0';
      Reset<='0';
      wait for 600 ns;

   
      --lb
       
      Instr<="00001100011100110000000000000001";
      ALU_Zero<='0';
      Reset<='0';
      wait for 1000 ns;

      --sb
       
      Instr<="00011100001010000000000000000111";
      ALU_Zero<='0';
      Reset<='0';
      wait for 800 ns;

      --lw
      Instr<="00111100001101010000000000000111";
      ALU_Zero<='0';
      Reset<='0';
     wait for 1000 ns;

      --sw
   
      Instr<="01111100011010000000000000000001";
      ALU_Zero<='0';
      Reset<='0';
      wait for 1000 ns;

       
      wait;
   end process;
end Behavioral;

