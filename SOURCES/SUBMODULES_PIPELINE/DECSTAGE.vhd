----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/13/2020 12:06:39 PM
-- Design Name: 
-- Module Name: DECODE - Behavioral
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

entity DECSTAGE is
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
end DECSTAGE;

architecture Behavioral of DECSTAGE is

signal mux_rf_b_out:signed(4 downto 0);
signal mux_write_out:signed(31 downto 0);


COMPONENT MUX5_2_1
    Port ( A : in signed(4 downto 0);
           B : in signed (4 downto 0);
           sel : in STD_LOGIC;
           Output : out signed (4 downto 0));
END COMPONENT;

COMPONENT Extender is
    Port ( Instr : in signed (15 downto 0);
           ImmExt : in STD_LOGIC_VECTOR (1 downto 0);
           Immed: out signed (31 downto 0));
END COMPONENT;

COMPONENT RF
     Port ( Ard1 : in STD_LOGIC_VECTOR (4 downto 0);
           Ard2 : in STD_LOGIC_VECTOR (4 downto 0);
           Awr : in STD_LOGIC_VECTOR (4 downto 0);
           Dout1 : out signed (31 downto 0);
           Dout2 : out signed (31 downto 0);
           Din : in signed (31 downto 0);
           WrEn : in STD_LOGIC;
           Clk : in STD_LOGIC;
           Rst : in STD_LOGIC
);
END COMPONENT;

begin

MUX_RF_B: MUX5_2_1 PORT MAP (
          A => signed(Instr(15 downto 11)),
          B =>signed(Instr(20 downto 16)),
          sel => RF_B_sel,
          Output => mux_rf_b_out
        );


        
Extender_Inst:Extender PORT MAP(
           Instr =>signed(Instr(15 downto 0)),
           ImmExt =>ImmExt,
           Immed =>Immed
           );


RF_inst: RF PORT MAP (
         Ard1 => Instr(25 downto 21),
         Ard2 => std_logic_vector(mux_rf_b_out),
         Awr =>std_logic_vector(rd_MEMWB),
         DOut1 => RF_A,
         DOut2 => RF_B,
         Din => RF_WrData,
         WrEn =>RF_WrEn,
         clk => clk,
         Rst=>Rst  
        );
        
        RF_B_out_mux<=mux_rf_b_out;
        rs<=signed(Instr(25 downto 21));
        rd<=signed(Instr(20 downto 16));
end Behavioral;
