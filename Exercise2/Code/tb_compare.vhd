--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:12:38 11/04/2015
-- Design Name:   
-- Module Name:   /home/shomeb/f/fredribh/Documents/TDT4255/pipeline_processor/tb_compare.vhd
-- Project Name:  pipeline_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: compare
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
 
ENTITY tb_compare IS
END tb_compare;
 
ARCHITECTURE behavior OF tb_compare IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT compare
    PORT(
         reg_in_1 : IN  std_logic_vector(31 downto 0);
         reg_in_2 : IN  std_logic_vector(31 downto 0);
         compare_out : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal reg_in_1 : std_logic_vector(31 downto 0) := (others => '0');
   signal reg_in_2 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal compare_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: compare PORT MAP (
          reg_in_1 => reg_in_1,
          reg_in_2 => reg_in_2,
          compare_out => compare_out
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      
      reg_in_1 <= x"00000000";
		reg_in_2 <= x"00000000";
      
		wait for clk_period;
		
		check(compare_out = '1', "value should be 1 when both inputs are zero");
		
      wait for clk_period*10;
		report "Test 1 passed" severity note;
		
		reg_in_1 <= x"ffffffff";
		reg_in_2 <= x"ffffffff";
      
		wait for clk_period;
		
		check(compare_out = '1', "value should be 1 when both inputs are 1");
		
      wait for clk_period*10;
		report "Test 2 passed" severity note;

      reg_in_1 <= x"01234567";
		reg_in_2 <= x"76543210";
      
		wait for clk_period;
		
		check(compare_out = '0', "value should be 0 when inputs are different");
		
      wait for clk_period*10;
		report "Test 3 passed" severity note;
		
		reg_in_1 <= x"00000000";
		reg_in_2 <= x"ffffffff";
      
		wait for clk_period;
		
		check(compare_out = '0', "value should be 0 when inputs are different");
		
      wait for clk_period*10;
		report "Test 4 passed" severity note;
		
		reg_in_1 <= x"00000001";
		reg_in_2 <= x"00000000";
      
		wait for clk_period;
		
		check(compare_out = '0', "value should be 0 when inputs are different");
		
      wait for clk_period*10;
		report "Test 5 passed" severity note;


		assert false report "TEST SUCCESS" severity failure;
      wait;
   end process;

END;
