--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:15:19 11/04/2015
-- Design Name:   
-- Module Name:   /home/shomea/s/salahuda/exercise3/tb_hazard_detection_unit.vhd
-- Project Name:  exercise3
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: hazard_detection_unit
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
 
ENTITY tb_hazard_detection_unit IS
END tb_hazard_detection_unit;
 
ARCHITECTURE behavior OF tb_hazard_detection_unit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT hazard_detection_unit
    PORT(
         ID_instruction : IN  std_logic_vector(9 downto 0);
         ID_EX_reg_t : IN  std_logic_vector(4 downto 0);
         ID_EX_memread : IN  std_logic;
         to_nop_mux : OUT  std_logic;
         pc_we : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal ID_instruction : std_logic_vector(9 downto 0) := (others => '0');
   signal ID_EX_reg_t : std_logic_vector(4 downto 0) := (others => '0');
   signal ID_EX_memread : std_logic := '0';

 	--Outputs
   signal to_nop_mux : std_logic;
   signal pc_we : std_logic;

   -- Clock period definitions
   constant clock_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: hazard_detection_unit PORT MAP (
          ID_instruction => ID_instruction,
          ID_EX_reg_t => ID_EX_reg_t,
          ID_EX_memread => ID_EX_memread,
          to_nop_mux => to_nop_mux,
          pc_we => pc_we
        );

   -- Stimulus process
   stim_proc: process
   begin		
	
		ID_instruction <= "0000100010"; 
		ID_EX_reg_t <= "00010";
		ID_EX_memread <= '1';
		
      wait for clock_period;

		check(pc_we = '0', "pc_we should be 0");
		check(to_nop_mux = '1', "to_nop_mux should be 1");
		report "Test 1 passed" severity note;
		
		ID_EX_memread <= '0';
		
		wait for clock_period;
		
		check(pc_we = '1', "pc_we should be 1");
		check(to_nop_mux = '0', "to_nop_mux should be 0");
		report "Test 2 passed" severity note;

		assert false report "TEST SUCCESS" severity failure;
   end process;

END;
