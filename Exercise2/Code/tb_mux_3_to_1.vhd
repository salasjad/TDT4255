--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:45:07 11/04/2015
-- Design Name:   
-- Module Name:   /home/salahuddin/Dropbox/Application_files/ISEProject/Datamaskinkonstruksjon/multicycle_processor_all/exercise2/tb_mux_3_to_1.vhd
-- Project Name:  exercise2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux_3_to_1
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
 
ENTITY tb_mux_3_to_1 IS
END tb_mux_3_to_1;
 
ARCHITECTURE behavior OF tb_mux_3_to_1 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux_3_to_1
    PORT(
         in1 : IN  std_logic_vector(31 downto 0);
         in2 : IN  std_logic_vector(31 downto 0);
         in3 : IN  std_logic_vector(31 downto 0);
         forward : IN  std_logic_vector(1 downto 0);
         output : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal in1 : std_logic_vector(31 downto 0) := (others => '0');
   signal in2 : std_logic_vector(31 downto 0) := (others => '0');
   signal in3 : std_logic_vector(31 downto 0) := (others => '0');
   signal forward : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal output : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux_3_to_1 PORT MAP (
          in1 => in1,
          in2 => in2,
          in3 => in3,
          forward => forward,
          output => output
        );


   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	

      wait for clock_period;

		in1 <= X"00010000";
		in2 <= X"00100000";
		in3 <= X"10000000";
			
		wait for clock_period;
		
		forward <= "00";
		
		wait for clock_period;
		
		check(output = X"00010000", "output should be 00010000");
		report "Test 1 passed" severity note;

		wait for clock_period;
		
		forward <= "01";
		
		wait for clock_period;
		
		check(output = X"00100000", "output should be 00100000");
		report "Test 2 passed" severity note;
		
		wait for clock_period;
		
		forward <= "10";
		
		wait for clock_period;
		
		check(output = X"10000000", "output should be 10000000");
		report "Test 3 passed" severity note;

		wait for clock_period;
		
		forward <= "11";
		
		wait for clock_period;
		
		check(output = X"00010000", "output should be 00010000");
		report "Test 4 passed" severity note;
		
		assert false report "TEST SUCCESS" severity failure;
   end process;

END;