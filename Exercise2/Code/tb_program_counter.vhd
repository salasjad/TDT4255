--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:39:49 09/22/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_program_counter.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: program_counter
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
 
ENTITY tb_program_counter IS
END tb_program_counter;
 
ARCHITECTURE behavior OF tb_program_counter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT program_counter
    PORT(
         pc_in : IN  std_logic_vector(31 downto 0);
         pc_out : OUT  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         wr_en : IN  std_logic;
			reg_en : IN std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal pc_in : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal wr_en : std_logic := '0';
	signal reg_en : std_logic := '0';

 	--Outputs
   signal pc_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: program_counter PORT MAP (
          pc_in => pc_in,
          pc_out => pc_out,
          clk => clk,
          rst => rst,
          wr_en => wr_en,
			 reg_en => reg_en
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		rst <= '0';
		check(pc_out = x"FFFFFFFF", "PC_OUT value should be -1 after reset");
		
      wait for clk_period*10;
		
		reg_en <= '1';
		
      -- insert stimulus here 
		pc_in <= x"01234567";
		
		wr_en <= '1';
		wait for clk_period;
		check(pc_out = x"01234567", "PC_OUT value should be 01234567");
		report "Test 1 passed" severity note;

		wait for clk_period;
		
		wr_en <= '0';
		check(pc_out = x"01234567", "PC_OUT value should be 01234567");
		report "Test 2 passed" severity note;

		pc_in <= x"76543210";
		wait for clk_period*2;
		
		check(pc_out = x"01234567", "PC_OUT value should be 01234567");
		report "Test 3 passed" severity note;
		
		wr_en <= '1';
		
		wait for clk_period;
		
		check(pc_out = x"76543210", "PC_OUT value should be 76543210");
		report "Test 4 passed" severity note;

		wait for clk_period;
		
		wr_en <= '0';
		check(pc_out = x"76543210", "PC_OUT value should stay the same");
		report "Test 5 passed" severity note;

		reg_en <= '0';
		pc_in <= x"71278210";
		
		wait for clk_period;
		
		check(pc_out = x"76543210", "PC_OUT value should stay the same");
		report "Test 6 passed" severity note;
		reg_en <= '0';
		pc_in <= x"71278210";
		wr_en <= '1';
		
		wait for clk_period;
		
		check(pc_out = x"76543210", "PC_OUT value should stay the same");
		report "Test 7 passed" severity note;

      wait until clk = '1';
		assert false report "TEST SUCCESS" severity failure;
		wait;
   end process;

END;
