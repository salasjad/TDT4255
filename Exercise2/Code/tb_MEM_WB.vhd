--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:52:09 11/04/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/pipeline_processor/tb_MEM_WB.vhd
-- Project Name:  pipeline_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: MEM_WB
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
 
ENTITY tb_MEM_WB IS
END tb_MEM_WB;
 
ARCHITECTURE behavior OF tb_MEM_WB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEM_WB
    PORT(
         WB_reg_write_in : IN  std_logic;
         WB_mem_to_reg_in : IN  std_logic;
         WB_reg_write_out : OUT  std_logic;
         WB_mem_to_reg_out : OUT  std_logic;
         mem_data_in : IN  std_logic_vector(31 downto 0);
         mem_data_out : OUT  std_logic_vector(31 downto 0);
         ALU_res_in : IN  std_logic_vector(31 downto 0);
         ALU_res_out : OUT  std_logic_vector(31 downto 0);
         reg_dest_in : IN  std_logic_vector(4 downto 0);
         reg_dest_out : OUT  std_logic_vector(4 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         reg_en : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal WB_reg_write_in : std_logic := '0';
   signal WB_mem_to_reg_in : std_logic := '0';
   signal mem_data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_res_in : std_logic_vector(31 downto 0) := (others => '0');
   signal reg_dest_in : std_logic_vector(4 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal reg_en : std_logic := '0';

 	--Outputs
   signal WB_reg_write_out : std_logic;
   signal WB_mem_to_reg_out : std_logic;
   signal mem_data_out : std_logic_vector(31 downto 0);
   signal ALU_res_out : std_logic_vector(31 downto 0);
   signal reg_dest_out : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEM_WB PORT MAP (
          WB_reg_write_in => WB_reg_write_in,
          WB_mem_to_reg_in => WB_mem_to_reg_in,
          WB_reg_write_out => WB_reg_write_out,
          WB_mem_to_reg_out => WB_mem_to_reg_out,
          mem_data_in => mem_data_in,
          mem_data_out => mem_data_out,
          ALU_res_in => ALU_res_in,
          ALU_res_out => ALU_res_out,
          reg_dest_in => reg_dest_in,
          reg_dest_out => reg_dest_out,
          clk => clk,
          rst => rst,
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
      wait for 10 ns;	
		rst <= '1';
      wait for clk_period*10;
		rst <= '0';
		reg_en <= '1';

      -- insert stimulus here 
		WB_reg_write_in <= '1';
		
		wait for clk_period;
		
		check(WB_reg_write_out = '1', "WB_reg_write_out failure");
		report "Test 1 passed" severity note;
		
		WB_reg_write_in <= '0';
		WB_mem_to_reg_in <= '1';
		
		wait for clk_period;
		
		check(WB_mem_to_reg_out = '1', "WB_mem_to_reg_out failure");
		report "Test 2 passed" severity note;
		
		WB_mem_to_reg_in <= '0';
		mem_data_in <= X"01234567";
		
		wait for clk_period;
		
		check(mem_data_out = X"01234567", "mem_data_out failure");
		report "Test 3 passed" severity note;
		
		ALU_res_in <= X"98765432";
		
		wait for clk_period;
		
		check(ALU_res_out = X"98765432", "ALU_res_out failure");
		report "Test 4 passed" severity note;
		
		reg_en <= '0';
		ALU_res_in <= X"00000000";
		
		wait for clk_period;
		
		check(ALU_res_out = X"98765432", "ALU_res_out failure");
		report "Test 5 passed" severity note;
		
      reg_dest_in <= "01010";
		reg_en <= '1';
		
		wait for clk_period;
		
		check(reg_dest_out = "01010", "reg_dest_out failure");
		report "Test 5 passed" severity note;		

		wait for clk_period;
		assert false report "TEST SUCCESS" severity failure;
		wait;
   end process;

END;
