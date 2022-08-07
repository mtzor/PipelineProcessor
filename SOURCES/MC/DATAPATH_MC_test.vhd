----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2020 01:17:11 PM
-- Design Name: 
-- Module Name: DATAPATH_test2 - Behavioral
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

entity DATAPATH_MC_test is
--  Port ( );
end DATAPATH_MC_test;

architecture Behavioral of DATAPATH_MC_test is
Component DATAPATH_MC
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

   --Inputs
   signal PC_temp,MM_WrData_temp, MM_Addr_temp,InstrRegOut: signed(31 downto 0) := (others => '0');
   signal  MM_WrEn_temp,InstReg_WrEn,ALU_Ain_Sel: std_logic:= '0';
   signal Instr_temp,MM_RdData_temp: std_logic_vector(31 downto 0):= (others => '0');
   
   signal ImmExt,ALU_Bin_Sel,PC_sel : std_logic_vector(1 downto 0):= (others => '0');
   signal ALU_func : signed(3 downto 0) := (others => '0');
   --signal PC_sel: signed(1 downto 0) := (others => '0');
   signal Mem_WrEn,RF_WrData_sel,RF_B_sel,RF_WrEn,ByteOp,Reset,PC_LdEn,Clk:std_logic:= '0';
   signal Instr,MM_RdData: signed(31 downto 0) := (others => '0');
 	--Outputs
   signal MM_Addr,MM_WrData,PC: signed(31 downto 0);
   signal MM_WrEn,ALU_zero: std_logic:= '0';
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
    constant clk_period : time := 200 ns;

BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DATAPATH_MC PORT MAP (
         Instr=>signed(Instr_temp),
         MM_RdData=>signed(MM_RdData_temp),
         Mem_WrEn =>Mem_WrEn,
         RF_WrData_sel=>RF_WrData_sel,
         RF_B_sel=>RF_B_sel,
         RF_WrEn=>RF_WrEn,
 
         InstReg_WrEn=>InstReg_WrEn,
         ALU_Ain_Sel=>ALU_Ain_Sel,

        ALU_Bin_Sel=>ALU_Bin_Sel,
        ImmExt=>ImmExt,
        ByteOp=>ByteOp,
        ALU_func=>ALU_func,
        PC_sel=>PC_sel,
        Reset=>Reset,
        PC_LdEn=>PC_LdEn,
        Clk=>Clk,


        MM_Addr=>MM_Addr_temp,
        MM_WrEn=>MM_WrEn_temp,
        MM_WrData=>MM_WrData_temp,
        PC=>PC_temp,
        ALU_zero=>ALU_zero,
        InstrRegOut=>InstrRegOut  
        );
 RAM_inst: RAM PORT MAP ( 
      clk=>Clk,
      inst_addr=>std_logic_vector(PC_temp(12 downto 2)), 
      inst_dout=>Instr_temp, 
      data_we=>MM_WrEn_temp,    
      data_addr=>std_logic_vector(MM_Addr_temp(12 downto 2)),     
      data_din=>std_logic_vector(MM_WrData_temp), 
      data_dout=>MM_RdData_temp);
      
 PC<=PC_temp;           
 MM_WrEn<=MM_WrEn_temp;
 MM_WrData<=MM_WrData_temp;
 MM_RdData<=signed(MM_RdData_temp);
 MM_Addr<=MM_Addr_temp;
 Instr<=signed(Instr_temp);
  -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
           Reset<='1';
      wait for 200 ns;	

	  --li done
	    
	    -- -1 state
	       	ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";   
	        InstReg_WrEn<='1';
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	   
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --2 state  
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="01";
	        ALU_func<="0000";  
	        RF_B_sel<='1';
	   wait for 200 ns;	
	     --7 state 

	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
       wait for 200 ns;	   
         
       
      
	  --li done
	    
	    -- 0 state
	      	ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        InstReg_WrEn<='1';
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --2 state  
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="01";
	        ALU_func<="0000";  
	        RF_B_sel<='1';
	   wait for 200 ns;	
	     --7 state   
	     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0';
	        RF_B_sel<='0'; 
       wait for 200 ns;	   
       
       
       
       --add done
	    
	    -- 0 state
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        InstReg_WrEn<='1';
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	  
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="0000";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	   
	     --7 state 
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
       wait for 200 ns;	   
      
       --sub done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="0001";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	   
  
  --AND done
	    
	    -- 0 state
	      	ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        InstReg_WrEn<='1';
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="0010";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	     
       wait for 200 ns;	           
       
      --or done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="0011";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	   
       
        --not done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="0100";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	   
     --nand done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="0101";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	   
       
       --nor done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="0110";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	   
          --sra done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="1000";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	    
       
        --srl done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="1001";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	   
	    
	    
	   --sll done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="1010";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	       
         --rol done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="1100";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	   
       	           
       	  --ror done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --6 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="00";
	        ImmExt<="01";
	        ALU_func<="1101";  
	        RF_B_sel<='0';
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	   
       
       
         --lui done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	 
	    
	     --10 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="11";
	        ALU_func<="0000";  
	      
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	  
           
          --addi done
	   
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	  
	    --2 state  
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="01";
	        ALU_func<="0000";  
	        RF_B_sel<='1';
	        
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;		  
        
     --nandi done
	    
	    -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	  
	   
	    --11 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="00";
	        ALU_func<="0101";  

	           
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	     
       --ori done
	    	      
	       
        -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	   
	    --1 state    
	    InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	

	    --12 state  
	        
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="00";
	        ALU_func<="0011";  
     
	   wait for 200 ns;	
	     --7 state     
	        RF_WrEn<='1';
	        RF_WrData_sel<='0'; 
	   
       wait for 200 ns;	 
       
       
         --b done
	    
	     -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ALU_Ain_Sel<='0';
	        ImmExt<="10";
	   wait for 200 ns;	
         --9 state
            PC_LdEn<='1';
	        PC_sel<="01";
       wait for 200 ns;	
        --beq done
	    
	     -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ALU_Ain_Sel<='0';
	        ImmExt<="10";
	   wait for 200 ns;	
         --8 state
            RF_B_sel<='1';
            ALU_Bin_Sel<="00";
	        ALU_Ain_Sel<='1';
	        ALU_func<="0001"; 
	        PC_LdEn<='1';
	        ImmExt<="10";
	        PC_sel<="01";     
	     wait for 200 ns;	
   
   
        --bne done
	    
	     -- 0 state
	        InstReg_WrEn<='1';
	        ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ALU_Ain_Sel<='0';
	        ImmExt<="10";
	   wait for 200 ns;	
         --8 state
            RF_B_sel<='1';
            ALU_Bin_Sel<="00";
	        ALU_Ain_Sel<='1';
	        ALU_func<="0001"; 
	        PC_LdEn<='1';
	        ImmExt<="10";
	        PC_sel<="01";     
	     wait for 200 ns;	
	     
	      --sw done
	    
	    -- 0 state
	      	ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        InstReg_WrEn<='1';
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --2 state  
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="01";
	        ALU_func<="0000";  
	        RF_B_sel<='1';
	   wait for 200 ns;	
	     --5 state   
	     
	        Mem_WrEn<='1';
	        ByteOp<='0';
	        
       wait for 200 ns;	
       
       
       -- lb done
	    
	    -- 0 state
	      	ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        InstReg_WrEn<='1';
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --2 state  
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="01";
	        ALU_func<="0000";  
	        RF_B_sel<='1';  
	   wait for 200 ns;	
     
	    --13 state
	        ByteOp<='1';
	        Mem_WrEn<='0';--
	        
	   wait for 200 ns;	

	    --4 state
	        RF_WrData_sel<='1';
            RF_WrEn<='1';
       wait for 200 ns;	


  -- sb done
	    
	    -- 0 state
	      	ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        InstReg_WrEn<='1';
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --2 state  
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="01";
	        ALU_func<="0000";  
	        RF_B_sel<='1';  
       wait for 200 ns;	
	        
	    --14 state
	        ByteOp<='1';
	        Mem_WrEn<='1';
       wait for 200 ns;	
	        
	
	-- lw done
	    
	    -- 0 state
	      	ALU_Bin_Sel<="01";
	        ALU_Ain_Sel<='0';
	        ALU_func<="0000"; 
	        PC_LdEn<='1';
	        PC_sel<="00";
	        InstReg_WrEn<='1';
	        Mem_WrEn <='0';
	        RF_WrEn<='0';
	        Reset<='0';
	   wait for 200 ns;	      
	    --1 state    
	        InstReg_WrEn<='0';
	        PC_LdEn<='0';
	        ALU_Bin_Sel<="10";
	        ImmExt<="10";
	   wait for 200 ns;	
	    --2 state  
	        ALU_Ain_Sel<='1';
	        ALU_Bin_Sel<="10";
	        ImmExt<="01";
	        ALU_func<="0000";  
	        RF_B_sel<='1';  
	   wait for 200 ns;	
     
	    --3 state
	        ByteOp<='0';
	        Mem_WrEn<='0';--
	        
	   wait for 200 ns;	

	    --4 state
	        RF_WrData_sel<='1';
            RF_WrEn<='1';
       wait for 200 ns;	        
      wait;
   end process;
end Behavioral;
