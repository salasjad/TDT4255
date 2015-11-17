--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:09:56 09/22/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_add.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: add
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
 
ENTITY tb_add IS
END tb_add;
 
ARCHITECTURE behavior OF tb_add IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT add
    PORT(
         add_in1 : IN  std_logic_vector(31 downto 0);
         add_in2 : IN  std_logic_vector(31 downto 0);
         add_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal add_in1 : std_logic_vector(31 downto 0) := (others => '0');
   signal add_in2 : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal add_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: add PORT MAP (
          add_in1 => add_in1,
          add_in2 => add_in2,
          add_out => add_out
        );

   -- Stimulus process
   stim_proc: process
   begin		

		add_in1 <= x"01234567";
		add_in2 <= x"00000001";
		
		wait for clock_period;
		
		check(add_out = x"01234568", "(ADD)ADD_OUT value should be 01234568");
		report "Test 1 passed" severity note;

		wait for clock_period;
		
		add_in2 <= x"11111111";
		wait for clock_period;
		
		check(add_out = x"12345678", "(ADD)ADD_OUT value should be 12345678");
		report "Test 2 passed" severity note;

		wait for clock_period;
		
		add_in1 <= x"FFFFFFFF";
		
		wait for clock_period;
		
		check(add_out = x"11111110", "(SUB)ADD_OUT value should be 11111110");
		report "Test 3 passed" severity note;

		add_in1 <= x"FFFFF000";
		
		wait for clock_period;
		
		check(add_out = x"11110111", "(SUB)ADD_OUT value should be 11110111");
		report "Test 4 passed" severity note;

      wait for clock_period;
		assert false report "TEST SUCCESS" severity failure;
   end process;

END;
