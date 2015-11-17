--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:34:32 09/22/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_sign_extend.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sign_extend
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
 
ENTITY tb_sign_extend IS
END tb_sign_extend;
 
ARCHITECTURE behavior OF tb_sign_extend IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sign_extend
    PORT(
         signed_input : IN  std_logic_vector(15 downto 0);
         signed_output : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal signed_input : std_logic_vector(15 downto 0) := (others => '0');

 	--Outputs
   signal signed_output : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sign_extend PORT MAP (
          signed_input => signed_input,
          signed_output => signed_output
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
		signed_input <= x"0123";
		
		wait for clock_period;
		
		check(signed_output = x"00000123", "Extention should be 00000123");
		report "Test 1 passed" severity note;
		
		signed_input <= x"F123";
		
		wait for clock_period;
		
		check(signed_output = x"FFFFF123", "Extention should be FFFFF123");
		report "Test 2 passed" severity note;

		wait for clock_period;
		
		signed_input <= x"FFFF";
		
		wait for clock_period;
		
		check(signed_output = x"FFFFFFFF", "Extention should be FFFFFFFF");
		report "Test 3 passed" severity note;

		signed_input <= x"0000";
		
		wait for clock_period;
		
		check(signed_output = x"00000000", "Extention should be 00000000");
		report "Test 4 passed" severity note;

      wait for clock_period;
		
		signed_input <= x"7FFF";
		
		wait for clock_period;
		
		check(signed_output = x"00007FFF", "Extention should be 00007FFF");
		report "Test 5 passed" severity note;

      wait for clock_period;
		assert false report "TEST SUCCESS" severity failure;
   end process;

END;
