----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/17/2020 07:30:18 PM
-- Design Name: 
-- Module Name: PROCESSOR_PIPELINE - Behavioral
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

entity PROCESSOR_PIPELINE is
  Port ( 
     Clk:in std_logic;
     Reset:in std_logic
);
end PROCESSOR_PIPELINE;

architecture Behavioral of PROCESSOR_PIPELINE is
signal PC_temp,Instr_IFID:signed(31 downto 0);
signal Instr_temp,MM_RdData_temp:std_logic_vector(31 downto 0);
signal MM_WrEn_temp,ImmCalc_IDEX,IFID_WrEn_temp,Mem_WrEn_temp,RF_WrData_sel_temp,RF_B_sel_temp,RF_WrEn_temp:std_logic;
signal IDEX_WrEn_temp,ALU_zero_temp,EXMEM_WrEn_temp,MEMWB_WrEn_temp,ByteOp_temp,PC_sel_temp,PC_LdEn_temp:std_logic;
signal MM_Addr_temp, MM_WrData_temp:signed(31 downto 0);
signal ALU_Ain_Sel_temp,ALU_Bin_Sel_temp,ImmExt_temp:std_logic_vector(1 downto 0);
signal ALU_func_temp:signed(3 downto 0);
signal RF_B_out_Reg_temp,rd_IDEX_temp,RF_B_out_mux_temp,rs_IDEX_temp,rd_EXMEM_temp,rd_MEMWB_temp:signed(4 downto 0);

Component DATAPATH_PIPELINE
Port (
 Instr :in signed(31 downto 0);
 MM_RdData :in signed(31 downto 0);
 
 ImmCalc_IDEX:in std_logic;  
 Mem_WrEn :in std_logic;
 RF_WrData_sel:in std_logic;
 RF_B_sel:in std_logic;
 RF_WrEn:in std_logic;
 IFID_WrEn:in std_logic;
 IDEX_WrEn:in std_logic;
 EXMEM_WrEn:in std_logic;
 MEMWB_WrEn:in std_logic;
 
 ALU_Bin_Sel:in std_logic_vector(1 downto 0);
 ALU_Ain_Sel:in std_logic_vector(1 downto 0);
 ImmExt :in std_logic_vector(1 downto 0);
 ByteOp :in std_logic;
 ALU_func:in signed(3 downto 0);
 PC_sel:in std_logic;
 Reset:in std_logic;
 PC_LdEn:in std_logic;
 Clk:in std_logic;

 RF_B_out_Reg:out signed(4 downto 0);
 RF_B_out_mux:out signed(4 downto 0);
 rd_EXMEM:out signed(4 downto 0);
 rd_MEMWB:out signed(4 downto 0);
 rs_IDEX:out signed(4 downto 0);
 rd_IDEX:out signed(4 downto 0);
 
 MM_Addr: out signed(31 downto 0);
 MM_WrEn : out std_logic;
 MM_WrData: out signed(31 downto 0);
 PC:out signed(31 downto 0);
 
 
 ALU_zero:out std_logic;
 InstrRegOut :out signed(31 downto 0)

  );

    END COMPONENT;
    
    
  component RAM IS 
  port (
    clk : in std_logic;
    inst_addr : in std_logic_vector(10 downto 0);
    inst_dout : out std_logic_vector(31 downto 0);
    data_we : in std_logic;
    data_addr : in std_logic_vector(10 downto 0);
    data_din : in std_logic_vector(31 downto 0);
    data_dout : out std_logic_vector(31 downto 0));
 end component;  
component CONTROL_PIPELINE is
Port ( 
 Instr_IFID :in signed(31 downto 0);--
 ALU_zero_EXMEM:in std_logic;
 Reset:in std_logic;--
 Clk:in std_logic;--
 
 rs_IDEX:in signed(4 downto 0);--
 RF_B_Mux_out_IDEX: in signed(4 downto 0);--
 RF_B_mux_out_IFID: in signed(4 downto 0);--
 rd_EXMEM: in signed(4 downto 0);--
 rd_MEMWB: in signed(4 downto 0);--
 
 rd_IDEX:in signed(4 downto 0);--
 
ImmCalc_IDEX:out std_logic;   
 Mem_WrEn :out std_logic;
 RF_WrData_sel:out std_logic;
 RF_B_sel:out std_logic;--
 RF_WrEn:out std_logic;
 IFID_WrEn:out std_logic;--
 IDEX_WrEn:out std_logic;--
 EXMEM_WrEn:out std_logic;--
 MEMWB_WrEn:out std_logic;--
 
 ALU_Bin_Sel:out std_logic_vector(1 downto 0);--
 ALU_Ain_Sel:out std_logic_vector(1 downto 0);--
 ImmExt :out std_logic_vector(1 downto 0);--
 ByteOp :out std_logic;
 ALU_func:out signed(3 downto 0);--
 PC_sel:out std_logic;
 PC_LdEn:out std_logic

);
end component; 
 
 
begin
CONTROL:CONTROL_PIPELINE 
Port MAP ( 
 Instr_IFID=>Instr_IFID,
 ALU_zero_EXMEM=>ALU_zero_temp,
 Reset=>Reset,
 Clk=>Clk,
 
 rs_IDEX=>rs_IDEX_temp,
 RF_B_Mux_out_IDEX=>RF_B_out_Reg_temp,
 RF_B_mux_out_IFID=>RF_B_out_mux_temp,
 rd_EXMEM=>rd_EXMEM_temp,
 rd_MEMWB=>rd_MEMWB_temp,
 
 rd_IDEX=>rd_IDEX_temp,
  
 ImmCalc_IDEX=>ImmCalc_IDEX,
 Mem_WrEn=>Mem_WrEn_temp,
 RF_WrData_sel=>RF_WrData_sel_temp,
 RF_B_sel=>RF_B_sel_temp,
 RF_WrEn=>RF_WrEn_temp,
 IFID_WrEn=>IFID_WrEn_temp,
 IDEX_WrEn=>IDEX_WrEn_temp,
 EXMEM_WrEn=>EXMEM_WrEn_temp,
 MEMWB_WrEn=>MEMWB_WrEn_temp,
 
 ALU_Bin_Sel=>ALU_Bin_Sel_temp,
 ALU_Ain_Sel=>ALU_Ain_Sel_temp,
 ImmExt =>ImmExt_temp,
 ByteOp =>ByteOp_temp,
 ALU_func=>ALU_func_temp,
 PC_sel=>PC_sel_temp,
 PC_LdEn=>PC_LdEn_temp

);


DATAPATH: DATAPATH_PIPELINE PORT MAP (
 
 Instr=>signed(Instr_temp),
 MM_RdData=>signed( MM_RdData_temp),
 
 ImmCalc_IDEX=>ImmCalc_IDEX,
 Mem_WrEn=>Mem_WrEn_temp,
 RF_WrData_sel=>RF_WrData_sel_temp,
 RF_B_sel=>RF_B_sel_temp,
 RF_WrEn=>RF_WrEn_temp,
 IFID_WrEn=>IFID_WrEn_temp,
 IDEX_WrEn=>IDEX_WrEn_temp,
 EXMEM_WrEn=>EXMEM_WrEn_temp,
 MEMWB_WrEn=>MEMWB_WrEn_temp,
 ALU_Bin_Sel=>ALU_Bin_Sel_temp,
 ALU_Ain_Sel=>ALU_Ain_Sel_temp,
 ImmExt =>ImmExt_temp,
 ByteOp =>ByteOp_temp,
 ALU_func=>ALU_func_temp,
 PC_sel=>PC_sel_temp,
 Reset=>Reset,
 PC_LdEn=>PC_LdEn_temp,
 Clk=>Clk,
 RF_B_out_Reg=>RF_B_out_Reg_temp,
 RF_B_out_mux=>RF_B_out_mux_temp,
 rd_EXMEM=>rd_EXMEM_temp,
 rd_MEMWB=>rd_MEMWB_temp,
 
 rs_IDEX=>rs_IDEX_temp,
 rd_IDEX=>rd_IDEX_temp,
 MM_Addr=> MM_Addr_temp,
 MM_WrEn=> MM_WrEn_temp,
 MM_WrData=>MM_WrData_temp,
 PC=>PC_temp,
 
 
 
 ALU_zero=>ALU_zero_temp,
 InstrRegOut =>Instr_IFID
        );
       
 RAM_inst: RAM PORT MAP ( 
      clk=>Clk,
      inst_addr=>std_logic_vector(PC_temp(12 downto 2)), 
      inst_dout=>Instr_temp, 
      data_we=>MM_WrEn_temp,    
      data_addr=>std_logic_vector(MM_Addr_temp(12 downto 2)),     
      data_din=>std_logic_vector(MM_WrData_temp), 
      data_dout=>MM_RdData_temp);
      

end Behavioral;
