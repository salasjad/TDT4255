--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:07:40 09/29/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_ALU_op.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU_op
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
 
ENTITY tb_ALU_op IS
END tb_ALU_op;
 
ARCHITECTURE behavior OF tb_ALU_op IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU_op
    PORT(
         ALUop : IN  std_logic_vector(1 downto 0);
         funct_field : IN  std_logic_vector(5 downto 0);
         ALU_control : OUT  std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal ALUop : std_logic_vector(1 downto 0) := (others => '0');
   signal funct_field : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal ALU_control : std_logic_vector(3 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU_op PORT MAP (
          ALUop => ALUop,
          funct_field => funct_field,
          ALU_control => ALU_control
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      ALUop <= "00";
		funct_field <= "010101";
		
		wait for clk_period;
		
		check(ALU_control = "0010", "LW/SW error");
		report "Test 1 passed" severity note;
		
		ALUop <= "01";
		
		wait for clk_period;
		
		check(ALU_control = "0010", "BRANCH error");
		report "Test 2 passed" severity note;
		
		ALUop <= "10";
		funct_field <= "100000";

		wait for clk_period;
		
		check(ALU_control = "0010", "ADD error");
		report "Test 3 passed" severity note;
		
		funct_field <= "100010";
		
		wait for clk_period;
		
		check(ALU_control = "0110", "SUB error");
		report "Test 4 passed" severity note;

		funct_field <= "100100";
	
		wait for clk_period;
		
		check(ALU_control = "0000", "AND error");
		report "Test 5 passed" severity note;
		
		funct_field <= "100101";
	
		wait for clk_period;
		
		check(ALU_control = "0001", "OR error");
		report "Test 6 passed" severity note;
		
		funct_field <= "101010";
	
		wait for clk_period;
		
		check(ALU_control = "0111", "SLT error");
		report "Test 7 passed" severity note;
		
		funct_field <= "100111";
	
		wait for clk_period;
		
		check(ALU_control = "0101", "NOR error");
		report "Test 8 passed" severity note;
		
		funct_field <= "111111";
	
		wait for clk_period;
		
		check(ALU_control = "1001", "general error");
		report "Test 9 passed" severity note;
		
		ALUop <= "11";
	
		wait for clk_period;
		
		check(ALU_control = "1000", "general error");
		report "Test 10 passed" severity note;

      wait for clk_period;
		assert false report "TEST SUCCESS" severity failure;
		wait;
   end process;

END;
