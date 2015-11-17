--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:40:41 11/04/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/pipeline_processor/tb_IF_ID.vhd
-- Project Name:  pipeline_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: IF_ID
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
 
ENTITY tb_IF_ID IS
END tb_IF_ID;
 
ARCHITECTURE behavior OF tb_IF_ID IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IF_ID
    PORT(
         pc_in : IN  std_logic_vector(31 downto 0);
         pc_out : OUT  std_logic_vector(31 downto 0);
         instruction_in : IN  std_logic_vector(31 downto 0);
         instruction_out : OUT  std_logic_vector(31 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         flush : IN  std_logic;
         reg_en : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal pc_in : std_logic_vector(31 downto 0) := (others => '0');
   signal instruction_in : std_logic_vector(31 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal flush : std_logic := '0';
   signal reg_en : std_logic := '0';

 	--Outputs
   signal pc_out : std_logic_vector(31 downto 0);
   signal instruction_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IF_ID PORT MAP (
          pc_in => pc_in,
          pc_out => pc_out,
          instruction_in => instruction_in,
          instruction_out => instruction_out,
          clk => clk,
          rst => rst,
          flush => flush,
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
      wait for 100 ns;	
		rst <= '1';
      wait for clk_period*10;
		rst <= '0';
		reg_en <= '1';

		instruction_in <= X"18736985";
		pc_in <= X"87548952";
		
		wait for clk_period;
		
		check(instruction_out = X"18736985", "instruction_out failure");
		check(pc_out = X"87548952", "pc_out failure");
		report "Test 1 passed" severity note;
		
		flush <= '1';
		
		wait for clk_period;
		check(instruction_out = X"00000000", "instruction_out failure");
		check(pc_out = X"00000000", "pc_out failure");
		report "Test 2 passed" severity note;
		
		flush <= '0';

		wait for clk_period;
		
		check(instruction_out = X"18736985", "instruction_out failure");
		check(pc_out = X"87548952", "pc_out failure");
		report "Test 3 passed" severity note;
		
		reg_en <= '0';
		instruction_in <= X"87459625";
		pc_in <= X"15975368";
		
		wait for clk_period;
		
		check(instruction_out = X"18736985", "instruction_out failure");
		check(pc_out = X"87548952", "pc_out failure");
		report "Test 4 passed" severity note;
		
		reg_en <= '1';
		
		wait for clk_period;
		
		check(instruction_out = X"87459625", "instruction_out failure");
		check(pc_out = X"15975368", "pc_out failure");
		report "Test 5 passed" severity note;
		
		reg_en <= '0';
		instruction_in <= X"88888888";
		pc_in <= X"77777777";		
		
		wait for clk_period;
		
		check(instruction_out = X"87459625", "instruction_out failure");
		check(pc_out = X"15975368", "pc_out failure");
		report "Test 6 passed" severity note;
		

		wait for clk_period;
		assert false report "TEST SUCCESS" severity failure;
		wait;
		
   end process;

END;
