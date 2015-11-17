--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:59:33 09/22/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_mux.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: mux
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
 
ENTITY tb_mux IS
END tb_mux;
 
ARCHITECTURE behavior OF tb_mux IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT mux
    PORT(
         mux_in1 : IN  std_logic_vector(31 downto 0);
         mux_in2 : IN  std_logic_vector(31 downto 0);
         mux_out : OUT  std_logic_vector(31 downto 0);
         src_select : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal mux_in1 : std_logic_vector(31 downto 0) := (others => '0');
   signal mux_in2 : std_logic_vector(31 downto 0) := (others => '0');
   signal src_select : std_logic := '0';

 	--Outputs
   signal mux_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: mux PORT MAP (
          mux_in1 => mux_in1,
          mux_in2 => mux_in2,
          mux_out => mux_out,
          src_select => src_select
        );

   -- Stimulus process
   stim_proc: process
   begin		
		
		mux_in1 <= x"01234567";
		mux_in2 <= x"00000001";
		
		wait for clock_period;
		
		check(mux_out = x"01234567", "MUX_OUT should be 01234567");
		report "Test 1 passed" severity note;
		
		src_select <= '1';
		
		wait for clock_period;
		
		mux_in2 <= x"11111111";
		wait for clock_period;
		
		check(mux_out = x"11111111", "MUX_OUT should be 11111111");
		report "Test 2 passed" severity note;

		wait for clock_period;
		
		mux_in1 <= x"FFFFFFFF";
		
		wait for clock_period;
		
		check(mux_out = x"11111111", "MUX_OUT should be 11111111");
		report "Test 3 passed" severity note;

		src_select <= '0';
		
		wait for clock_period;
		
		check(mux_out = x"FFFFFFFF", "MUX_OUT should be FFFFFFFF");
		report "Test 4 passed" severity note;

      wait for clock_period;
		assert false report "TEST SUCCESS" severity failure;
   end process;

END;
