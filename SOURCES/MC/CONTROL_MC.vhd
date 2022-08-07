----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2020 12:46:42 AM
-- Design Name: 
-- Module Name: CONTROL - Behavioral
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

entity CONTROL_MC is
 Port (
     ALU_func:out signed(3 downto 0);

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
     PC_sel:out std_logic_vector(1 downto 0);
     PC_LdEn:out std_logic
  );
end CONTROL_MC;

architecture Behavioral of CONTROL_MC is
signal alu_op:signed(2 downto 0);
signal PCWrite_temp,PCWriteCond_temp:STD_LOGIC;

COMPONENT ALU_Control IS
 Port ( 
 ALUop:in signed(2 downto 0);
 func:in signed(5 downto 0);
 ALU_func:out signed(3 downto 0)
 );
 END COMPONENT;
 
 COMPONENT Main_Control IS
     
    
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
 PCWrite:out std_logic;
 PCWriteCond:out std_logic
  );
  END COMPONENT;

begin



alu_contr: ALU_Control PORT MAP ( 
 ALUop=>alu_op,
 func=>Instr(5 downto 0),
 ALU_func=>ALU_func
 
 );
 
main_contr: Main_Control 
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
     ALUop=>alu_op,
     PC_sel=>PC_sel,
     PCWrite=>PCWrite_temp,
     PCWriteCond=>PCWriteCond_temp
     
     
     );
     
     
     PC_LdEn<='1' WHEN (PCWrite_temp='1' OR (PCWriteCond_temp='1' AND ALU_zero='1' AND Instr(31 downto 26)="000000") OR (PCWriteCond_temp='1' AND   ALU_zero='0' AND Instr(31 downto 26)="000001")) ELSE
              '0';

end Behavioral;
