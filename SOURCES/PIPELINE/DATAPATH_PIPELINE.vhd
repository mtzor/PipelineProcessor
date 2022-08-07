

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DATAPATH_PIPELINE is
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
end DATAPATH_PIPELINE;

architecture Behavioral of DATAPATH_PIPELINE is
signal Immed_DEC,RF_A_DEC,RF_B_DEC,RF_A_IDEX,RF_B_IDEX,ALU_out_temp,ALU_result_temp,MEM_out_temp,Instr_temp:signed(31 downto 0);
signal rd_EXMEM_temp,rs_DEC,rd_MEMWB_temp,RF_B_out_mux_temp,rd_DEC,rd_IDEX_temp:signed(4 downto 0);
signal Immed_IDEX,PC_Immed_EX,PC_IDEX,PC_Immed_EXMEM,PC_Inc_IF,PC_Inc_IFID,RF_WrData_WB,RF_B_EXMEM,ALU_out_MEMWB,MEM_out_MEMWB,MEMWrData_temp:signed(31 downto 0);
signal ALU_zero_EX:STD_LOGIC;

Component DECSTAGE
 Port ( Instr : in STD_LOGIC_VECTOR (31 downto 0);
           RF_WrEn : in STD_LOGIC;
           Rst : in STD_LOGIC;
           RF_WrData : in signed (31 downto 0);
           rd_MEMWB: in signed (4 downto 0);
           RF_B_sel : in STD_LOGIC;
           ImmExt : in STD_LOGIC_VECTOR (1 downto 0);
           Clk : in STD_LOGIC;
           Immed : out signed (31 downto 0);
           RF_B_out_mux: out signed (4 downto 0);
           rd : out signed (4 downto 0);
           rs : out signed (4 downto 0);
           RF_A : out signed (31 downto 0);
           RF_B : out signed (31 downto 0)
           );
End component;   

Component IDEX_D
 Port (    CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           PC:in  signed  (31 downto 0);
           PC_Reg:out  signed  (31 downto 0);
           Immed: in  signed  (31 downto 0);
           Immed_Reg: out  signed  (31 downto 0);
           RF_A: in  signed  (31 downto 0);
           RF_A_Reg: out signed  (31 downto 0);
           RF_B: in  signed  (31 downto 0);
           RF_B_Reg: out signed  (31 downto 0);
           rs: in  signed  (4 downto 0);
           rs_Reg : out  signed  (4 downto 0);
           rd : in  signed  (4 downto 0);
           rd_Reg : out  signed  (4 downto 0);
           RF_B_out : in  signed  (4 downto 0);
           RF_B_out_Reg: out  signed  (4 downto 0)
           
           );
End component;  

 COMPONENT MEMSTAGE
  Port (
     ByteOp:in std_logic;
     clk:in std_logic;
     Mem_WrEn:in std_logic;
     ALU_MEM_Addr:in signed(31 downto 0); 
     MEM_DataIn:in signed(31 downto 0);
     MEM_DataOut:out signed(31 downto 0);
     MM_Addr:out signed(31 downto 0);
     MM_WrEn:out std_logic;
     MM_WrData:out signed(31 downto 0);
     MM_RdData:in signed(31 downto 0)
 );
    END COMPONENT;
    
    COMPONENT  IFSTAGE is
 Port (    PC_Sel : in STD_LOGIC;
           PC_LdEn : in STD_LOGIC;
           Reset : in STD_LOGIC;
           Clk : in STD_LOGIC;
           PC_Immed : in signed (31 downto 0);
           PC_Inc :out signed (31 downto 0);
           PC : out signed (31 downto 0));
end COMPONENT;

COMPONENT EXSTAGE
     Port ( RF_A : in  signed  (31 downto 0);
           RF_B : in  signed  (31 downto 0);
           Immed : in  signed  (31 downto 0);
           ImmCalc_IDEX:in std_logic;
           RF_WrData: in  signed  (31 downto 0);
           ALU_Reg_Dout: in  signed  (31 downto 0);
           PC: in  signed  (31 downto 0);
           PC_Immed: out  signed  (31 downto 0);
           ALU_Ain_sel : in  STD_LOGIC_VECTOR(1 downto 0);
           ALU_Bin_sel : in  STD_LOGIC_VECTOR(1 downto 0);
           ALU_func: in  signed  (3 downto 0);
           ALU_out:out  signed  (31 downto 0);
           MEMWrData:out  signed  (31 downto 0);
           ALU_zero : out  STD_LOGIC
            );
END COMPONENT;
COMPONENT WBSTAGE is
 Port (    ALU_out : in signed (31 downto 0);
           MEM_out : in signed (31 downto 0);
           RF_WrData_sel : in STD_LOGIC;
           RF_WrData: out signed (31 downto 0)
            );
END COMPONENT;

COMPONENT EXMEM_D
  Port ( 
             CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           PC_Immed:in  signed  ( 31 downto 0);
           PC_Immed_Reg:out signed  ( 31 downto 0);
           ALU_out: in  signed  ( 31 downto 0);
           ALU_out_Reg: out  signed  ( 31 downto 0);
           Zero: in  STD_LOGIC;
           Zero_Reg:out  STD_LOGIC;
           RF_B:in  signed  ( 31 downto 0);
           RF_B_Reg:out  signed  ( 31 downto 0);
           rd : in  signed  (4 downto 0);
           rd_Reg : out  signed  (4 downto 0)
  );
end COMPONENT;

COMPONENT RegisterModule is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (31 downto 0);
           DataOut : out signed (31 downto 0));
end COMPONENT;

COMPONENT InstructionRegisterModule is
    Port ( CLK : in STD_LOGIC;
           RST : in STD_LOGIC;
           WE : in STD_LOGIC;
           DataIn : in signed (31 downto 0);
           DataOut : out signed (31 downto 0));
end COMPONENT;

COMPONENT MEMWB_D is
    Port (
            CLK : in STD_LOGIC;
            RST : in STD_LOGIC;
            WE : in STD_LOGIC;
            rd : in  signed  (4 downto 0);
            rd_Reg : out  signed  (4 downto 0);
            ALU_out: in  signed  ( 31 downto 0);
            ALU_out_Reg: out  signed  ( 31 downto 0);
            MEM_out: in  signed  ( 31 downto 0);
            MEM_out_Reg: out  signed  ( 31 downto 0));
end COMPONENT;

begin

instance_if: IFSTAGE 
PORT MAP ( 
           PC_Sel => PC_Sel,
           PC_LdEn => PC_LdEn,
           Reset => Reset,--
           Clk => Clk,--
           PC_Immed=>PC_Immed_EXMEM,
           PC_Inc=>PC_Inc_IF,
           PC => PC 
           );
           

IFID_InstrD_Register: InstructionRegisterModule PORT MAP (
          CLK=> Clk,
          RST => Reset,
          WE => IFID_WrEn,
          DataIn => Instr,
          DataOut => Instr_temp
         
        );--checked
        
IFID_PCD_Register: RegisterModule PORT MAP (
          CLK=> Clk,
          RST => Reset,
          WE => IFID_WrEn,
          DataIn => PC_Inc_IF,
          DataOut => PC_Inc_IFID
         
        );--checked
        
  instance_dec: DECSTAGE PORT MAP ( 
           Instr=>STD_LOGIC_VECTOR(Instr_temp),
           RF_WrEn =>RF_WrEn,
           Rst =>Reset,

           RF_WrData =>RF_WrData_WB,
           rd_MEMWB=>rd_MEMWB_temp,
           RF_B_sel =>RF_B_sel,
           ImmExt =>ImmExt,
           Clk =>Clk,
           Immed =>Immed_DEC,
           RF_B_out_mux=>RF_B_out_mux_temp,
           rd =>rd_DEC,
           rs =>rs_DEC,
           RF_A=>RF_A_DEC,
           RF_B=>RF_B_DEC
           );--checked
           
 IDEX:IDEX_D PORT MAP ( 
           CLK =>Clk,
           RST =>Reset,
           WE =>IDEX_WrEn,
           PC=> PC_Inc_IFID,--IFID
           PC_Reg=>PC_IDEX,
           Immed=>Immed_DEC,
           Immed_Reg=>Immed_IDEX,
           RF_A=>RF_A_DEC,
           RF_A_Reg=>RF_A_IDEX,
           RF_B=>RF_B_DEC,
           RF_B_Reg=>RF_B_IDEX,
           rs=>rs_DEC,
           rs_Reg =>rs_IDEX,
           rd =>rd_DEC,
           rd_Reg =>rd_IDEX_temp,
           RF_B_out=>RF_B_out_mux_temp,
           RF_B_out_Reg=>RF_B_out_Reg          
           );--checked
           
instance_ex: EXSTAGE PORT MAP (
           RF_A =>RF_A_IDEX,
           RF_B =>RF_B_IDEX,
           Immed =>Immed_IDEX,
           ImmCalc_IDEX=>ImmCalc_IDEX,
           RF_WrData=>RF_WrData_WB,
           ALU_Reg_Dout=>ALU_out_temp,
           PC=>PC_IDEX,
           PC_Immed=>PC_Immed_EX,
           ALU_Ain_sel=>ALU_Ain_sel,
           ALU_Bin_sel=>ALU_Bin_sel,
           ALU_func=>ALU_func,
           ALU_out=>ALU_result_temp,
           MEMWrData=>MEMWrData_temp,
           ALU_zero=>ALU_zero_EX
        );
        
EXMEM_D_inst: EXMEM_D Port MAP( 
           CLK =>Clk,
           RST =>Reset,
           WE =>EXMEM_WrEn,
           PC_Immed=>PC_Immed_EX,
           PC_Immed_Reg=>PC_Immed_EXMEM,
           ALU_out=>ALU_result_temp,
           ALU_out_Reg=>ALU_out_temp,
           Zero=>ALU_zero_EX,
           Zero_Reg=>ALU_zero,
           RF_B=>MEMWrData_temp,
           RF_B_Reg=>RF_B_EXMEM,
           rd =>rd_IDEX_temp,
           rd_Reg=>rd_EXMEM_temp  );
 
              
MEMSTAGE_inst: MEMSTAGE PORT MAP (
          ByteOp => ByteOp,
          clk=>Clk,
          Mem_WrEn=>Mem_WrEn,
          ALU_MEM_Addr=>ALU_out_temp,
          MEM_DataIn=>RF_B_EXMEM,--
          MM_RdData=>MM_RdData,
          MM_WrData=>MM_WrData,
          MM_Addr=>MM_Addr,
          MEM_DataOut=>MEM_out_temp,
          MM_WrEn=>MM_WrEn  
        ); 
        
MEMWB_D_inst: MEMWB_D PORT MAP(
            CLK=>Clk,
            RST =>Reset,
            WE =>MEMWB_WrEn,
            rd =>rd_EXMEM_temp,
            rd_Reg =>rd_MEMWB_temp,
            ALU_out=>ALU_out_temp,
            ALU_out_Reg=>ALU_out_MEMWB,
            MEM_out=>MEM_out_temp,
            MEM_out_Reg=>MEM_out_MEMWB


);    

WBSTAGE_inst: WBSTAGE  PORT MAP(
           ALU_out=>ALU_out_MEMWB,
           MEM_out =>MEM_out_MEMWB,
           RF_WrData_sel=>RF_WrData_sel,
           RF_WrData=>RF_WrData_WB
            );

  InstrRegOut<=Instr_temp;       
  RF_B_out_mux<=RF_B_out_mux_temp; 
  rd_EXMEM<= rd_EXMEM_temp ;   
  rd_MEMWB<=rd_MEMWB_temp; 
  rd_IDEX<=rd_IDEX_temp;   
  
  
end Behavioral;
