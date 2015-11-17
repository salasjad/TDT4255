--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:09:39 11/04/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/pipeline_processor/tb_control_unit.vhd
-- Project Name:  pipeline_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control_unit
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.testutil.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_control_unit IS
END tb_control_unit;
 
ARCHITECTURE behavior OF tb_control_unit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_unit
    PORT(
		instruction : IN std_logic_vector(31 downto 0);
		equals : IN std_logic;          
		reg_dest : OUT std_logic;
		ALU_op : OUT std_logic_vector(1 downto 0);
		ALU_src : OUT std_logic;
		mem_we : OUT std_logic;
		mem_re : OUT std_logic;
		reg_we : OUT std_logic;
		mem_to_reg : OUT std_logic;
		jump : OUT std_logic;
		branch : OUT std_logic;
		flush : OUT std_logic
		);
    END COMPONENT;
    

   --Inputs
   signal instruction : std_logic_vector(31 downto 0) := (others => '0');
	signal equals : std_logic;
	
 	--Outputs
   signal reg_dest : std_logic;
   signal ALU_op : std_logic_vector(1 downto 0);
   signal ALU_src : std_logic;
   signal mem_we : std_logic;
	signal mem_re : std_logic;
   signal reg_we : std_logic;
   signal mem_to_reg : std_logic;
   signal jump : std_logic;
   signal branch : std_logic;
   signal flush : std_logic;
	signal control_vector : std_logic_vector(10 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_unit PORT MAP (
          instruction => instruction,
			 equals => equals,
          reg_dest => reg_dest,
          ALU_op => ALU_op,
          ALU_src => ALU_src,
          mem_we => mem_we,
			 mem_re => mem_re,
          reg_we => reg_we,
          mem_to_reg => mem_to_reg,
          jump => jump,
          branch => branch,
          flush => flush
        );

	control_vector <= reg_dest & ALU_op & ALU_src & mem_we & mem_re & reg_we & mem_to_reg & jump & branch & flush;
	

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 10 ns;
		--no reset needed, control unit is combinational logic

      -- insert stimulus here 
		instruction <= X"00221820"; -- add $3, $1, $2
		equals <= '0';
		
		wait for clk_period;
		
		check(control_vector = "11000010000", "ADD failure");
		report "Test 1 passed" severity note;
		
		instruction <= X"00432024"; -- and $4, $2, $3
		
		wait for clk_period;
		
		check(control_vector = "11000010000", "AND failure");
		report "Test 2 passed" severity note;
		
		instruction <= X"00432825"; -- or $5, $2, $3
		
		wait for clk_period;
		
		check(control_vector = "11000010000", "OR failure");
		report "Test 3 passed" severity note;
		
		instruction <= X"0001982A"; -- slt $19, $0, $1
		
		wait for clk_period;
		
		check(control_vector = "11000010000", "SLT failure");
		report "Test 4 passed" severity note;
		
		instruction <= X"00822022"; -- sub $4, $4, $2
		
		wait for clk_period;
		
		check(control_vector = "11000010000", "SUB failure");
		report "Test 5 passed" severity note;
		
		instruction <= X"8C020002"; -- lw $2, 2($0)
		
		wait for clk_period;
		
		check(control_vector = "00010111000", "LW failure");
		report "Test 6 passed" severity note;
		
		instruction <= X"AC030001"; --sw $3, 1($0)
		
		wait for clk_period;
		
		check(control_vector = "00011000000", "SW failure");
		report "Test 7 passed" severity note;
		
		instruction <= X"08000013"; --j 19
		
		wait for clk_period;
		
		check(control_vector = "00000000101", "J failure");
		report "Test 8 passed" severity note;
		
		instruction <= X"10400002"; --beq $2, $0, 2 (taken)
		equals <= '1';
		
		wait for clk_period;
		
		check(control_vector = "00000000011", "BEQ failure");
		report "Test 9 passed" severity note;
		
		equals <= '0'; -- beq (not taken)
		
		wait for clk_period;
		
		check(control_vector = "00000000000", "BEQ failure");
		report "Test 10 passed" severity note;
		
		instruction <= X"3C030006"; --lui $3, 6
		
		wait for clk_period;
		
		check(control_vector = "00110010000", "BEQ failure");
		report "Test 11 passed" severity note;
		
		wait for clk_period;
		assert false report "TEST SUCCESS" severity failure;
		wait;
		
   end process;

END;
