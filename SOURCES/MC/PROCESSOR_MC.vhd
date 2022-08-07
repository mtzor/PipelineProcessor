----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/09/2020 05:05:32 PM
-- Design Name: 
-- Module Name: PROC_SC - Behavioral
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

entity PROCESSOR_MC is
Port (
Reset:in std_logic;
Clk:in std_logic

 );
end PROCESSOR_MC;

architecture Behavioral of PROCESSOR_MC is

signal ALU_Zero_temp,ALU_Ain_Sel_temp,Mem_WrEn_temp,InstReg_WrEn_temp,MM_WrEn_temp,RF_WrData_sel_temp,RF_B_sel_temp,RF_WrEn_temp,ByteOp_temp,PC_LdEn_temp:std_logic;
signal ImmExt_temp,ALU_Bin_Sel_temp,PC_sel_temp:std_logic_vector(1 downto 0);
signal MM_RdData_temp,Instr:std_logic_vector(31 downto 0);
signal MM_Addr_temp,MM_WrData_temp,PC_temp,InstrRegOut_temp:signed(31 downto 0);
signal ALU_func_temp:signed(3 downto 0);
COMPONENT CONTROL_MC
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

     END COMPONENT;
    
     component RAM
 port (
 clk : in std_logic;
 inst_addr : in std_logic_vector(10 downto 0);
 inst_dout : out std_logic_vector(31 downto 0);
 data_we : in std_logic;
 data_addr : in std_logic_vector(10 downto 0);
 data_din : in std_logic_vector(31 downto 0);
 data_dout : out std_logic_vector(31 downto 0));
 end COMPONENT;
 
 
 component DATAPATH_MC
 Port (
 Instr :in signed(31 downto 0);
 MM_RdData :in signed(31 downto 0);
 
 Mem_WrEn :in std_logic;
 RF_WrData_sel:in std_logic;
 RF_B_sel:in std_logic;
 RF_WrEn:in std_logic;
 InstReg_WrEn:in std_logic;
 ALU_Bin_Sel:in std_logic_vector(1 downto 0);
 ALU_Ain_Sel:in std_logic;
 ImmExt :in std_logic_vector(1 downto 0);
 ByteOp :in std_logic;
 ALU_func:in signed(3 downto 0);
 PC_sel:in std_logic_vector(1 downto 0);
 Reset:in std_logic;
 PC_LdEn:in std_logic;
 Clk:in std_logic;


 MM_Addr: out signed(31 downto 0);
 MM_WrEn : out std_logic;
 MM_WrData: out signed(31 downto 0);
 PC:out signed(31 downto 0);
 
 ALU_zero:out std_logic;
 InstrRegOut :out signed(31 downto 0)

  );
    END COMPONENT;
    
begin
CONTR:CONTROL_MC
Port Map (
    
     ALU_func=>ALU_func_temp,

     Instr=>InstrRegOut_temp,
     Clk=>Clk,
     ALU_zero=>ALU_zero_temp,
     Reset=>Reset,
    
     Mem_WrEn=>Mem_WrEn_temp,
     RF_WrData_sel=>RF_WrData_sel_temp,
     RF_B_sel=>RF_B_sel_temp,
     RF_WrEn=>RF_WrEn_temp,
     InstReg_WrEn=>InstReg_WrEn_temp,
     ALU_Bin_Sel=>ALU_Bin_Sel_temp,
     ALU_Ain_Sel=>ALU_Ain_Sel_temp,
     ImmExt=>ImmExt_temp,
     ByteOp=>ByteOp_temp,
     PC_sel=>PC_sel_temp,
     PC_LdEn=>PC_LdEn_temp
     
     
     );
     
     
 DATAP: DATAPATH_MC PORT MAP (
         Instr=>signed(Instr),
         MM_RdData=>signed(MM_RdData_temp),
         Mem_WrEn =>Mem_WrEn_temp,
         RF_WrData_sel=>RF_WrData_sel_temp,
         RF_B_sel=>RF_B_sel_temp,
         RF_WrEn=>RF_WrEn_temp,
 
         InstReg_WrEn=>InstReg_WrEn_temp,
         ALU_Ain_Sel=>ALU_Ain_Sel_temp,

        ALU_Bin_Sel=>ALU_Bin_Sel_temp,
        ImmExt=>ImmExt_temp,
        ByteOp=>ByteOp_temp,
        ALU_func=>ALU_func_temp,
        PC_sel=>PC_sel_temp,
        Reset=>Reset,
        PC_LdEn=>PC_LdEn_temp,
        Clk=>Clk,


        MM_Addr=>MM_Addr_temp,
        MM_WrEn=>MM_WrEn_temp,
        MM_WrData=>MM_WrData_temp,
        PC=>PC_temp,
        
         InstrRegOut=>InstrRegOut_temp,
        ALU_zero=>ALU_zero_temp
          
        );
        
      RAM_comp: RAM PORT MAP ( 
      clk=>Clk,
      inst_addr=>std_logic_vector(PC_temp(12 downto 2)), 
      inst_dout=>Instr, 
      data_we=>MM_WrEn_temp,    
      data_addr=>std_logic_vector(MM_Addr_temp(12 downto 2)),     
      data_din=>std_logic_vector(MM_WrData_temp), 
      data_dout=>MM_RdData_temp
            
            );    

end Behavioral;
