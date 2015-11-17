--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:13:21 09/22/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_concat.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: concat
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
 
ENTITY tb_concat IS
END tb_concat;
 
ARCHITECTURE behavior OF tb_concat IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT concat
    PORT(
         instruction_in : IN  std_logic_vector(25 downto 0);
         pc_in : IN  std_logic_vector(5 downto 0);
         concat_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal instruction_in : std_logic_vector(25 downto 0) := (others => '0');
   signal pc_in : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal concat_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: concat PORT MAP (
          instruction_in => instruction_in,
          pc_in => pc_in,
          concat_out => concat_out
        ); 

   -- Stimulus process
   stim_proc: process
   begin		

		instruction_in <= "00000000000000000000101010";
		pc_in <= "000001";
		
		wait for clock_period;
		
		check(concat_out = "00000100000000000000000000101010", "Wrong concatenation 1");
		report "Test 1 passed" severity note;

		wait for clock_period;
		
		pc_in <= "100001";
		wait for clock_period;
		
		check(concat_out = "10000100000000000000000000101010", "Wrong concatenation 2");
		report "Test 2 passed" severity note;

		wait for clock_period;
		
		instruction_in <= "11111100011001101000101010";
		
		wait for clock_period;
		
		check(concat_out = "10000111111100011001101000101010", "Wrong concatenation 3");
		report "Test 3 passed" severity note;
		
      wait for clock_period;
		assert false report "TEST SUCCESS" severity failure;
   end process;

END;
