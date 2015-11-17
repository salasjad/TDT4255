--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:54:18 10/06/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_control_unit.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: control_unit
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
 
ENTITY tb_control_unit IS
END tb_control_unit;
 
ARCHITECTURE behavior OF tb_control_unit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT control_unit
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         processorEnable : IN  std_logic;
         instruction_in : IN  std_logic_vector(31 downto 26);
         branch : OUT  std_logic;
         pc_we : OUT  std_logic;
         ir_we : OUT  std_logic;
         reg_dst : OUT  std_logic;
         reg_we : OUT  std_logic;
         alu_src : OUT  std_logic;
         alu_op : OUT  std_logic_vector(1 downto 0);
         jump : OUT  std_logic;
         mem_we : OUT  std_logic;
         mem_to_reg : OUT  std_logic;
			reg_op_we : OUT std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal processorEnable : std_logic := '0';
   signal instruction_in : std_logic_vector(31 downto 26) := (others => '0');

 	--Outputs
   signal branch : std_logic;
   signal pc_we : std_logic;
   signal ir_we : std_logic;
   signal reg_dst : std_logic;
   signal reg_we : std_logic;
   signal alu_src : std_logic;
   signal alu_op : std_logic_vector(1 downto 0);
   signal jump : std_logic;
   signal mem_we : std_logic;
   signal mem_to_reg : std_logic;
	signal reg_op_we : std_logic;
	signal output_vector : std_logic_vector(11 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: control_unit PORT MAP (
          clk => clk,
          rst => rst,
          processorEnable => processorEnable,
          instruction_in => instruction_in,
          branch => branch,
          pc_we => pc_we,
          ir_we => ir_we,
          reg_dst => reg_dst,
          reg_we => reg_we,
          alu_src => alu_src,
          alu_op => alu_op,
          jump => jump,
          mem_we => mem_we,
          mem_to_reg => mem_to_reg,
			 reg_op_we => reg_op_we
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 
	output_vector <= branch & pc_we & ir_we & reg_dst & reg_we & alu_src & alu_op & jump & mem_we & mem_to_reg &reg_op_we;
	
   -- Stimulus process
   stim_proc: process
   begin	
		rst <= '1';
      -- hold reset state for 100 ns.
      wait for 50 ns;	
		rst <= '0';
      wait for clk_period*5;
		check(output_vector = "000000000000", "output error");
		report "Test outputs 1 passed" severity note;
		
		processorEnable <= '1';
		wait for clk_period;
		check(output_vector = "010000000001", "pc update error");
		report "Test outputs 2a passed" severity note;
		wait for clk_period;
		check(output_vector = "001000000001", "fetch error");
		report "Test outputs 2b passed" severity note;
		
		-- JUPM TEST
		instruction_in <= "000010";
		wait for clk_period*2;
		check(output_vector = "010000001001", "jump error");
		report "Test outputs 3 passed" severity note;
		-- BACK TO PC UPDATE
		wait for clk_period;
		check(output_vector = "010000000001", "pc update error");
		report "Test outputs 4 passed" severity note;
		-- BRANCH TEST
		instruction_in <= "000100";
		wait for clk_period*3;
		check(output_vector = "000000010001", "compare error");
		report "Test outputs 5a passed" severity note;
		
		wait for clk_period;
		check(output_vector = "110000010001", "beq error");
		report "Test outputs 5b passed" severity note;
		
		-- R-TYPE TEST
		instruction_in <= "000000";
		wait for clk_period * 3;
		check(output_vector = "000000100001", "R-type error");
		report "Test outputs 6 passed" severity note;
		
		processorEnable <= '0';
		wait for clk_period*10;
		check(output_vector = "000000100000", "R-type enable error");
		report "Test outputs 6b passed" severity note;
		processorEnable <= '1';
		wait for clk_period;
		
		-- LOAD
		instruction_in <= "100011";
		wait for clk_period*5;
		check(output_vector = "000001000001", "LW SW error");
		report "Test outputs 7 passed" severity note;

		wait for clk_period;
		check(output_vector = "000001000011", "LW EX error");
		report "Test outputs 8 passed" severity note;
		
		wait for clk_period;
		check(output_vector = "000010000011", "LW WB error");
		report "Test outputs 9 passed" severity note;
		-- STORE
		instruction_in <= "101011";
		wait for clk_period*4;
		check(output_vector = "000001000001", "LW SW error");
		report "Test outputs 10 passed" severity note;
      
		wait for clk_period;
		check(output_vector = "000001000101", "SW error");
		report "Test outputs 11 passed" severity note;
		
		-- LOAD UPPER IMMEDIATE
		instruction_in <= "001111";
		wait for clk_period*4;
		check(output_vector = "000001110001", "LUI error");
		report "Test outputs 12 passed" severity note;
		
		wait for clk_period;
		check(output_vector = "000010110001", "LUI WB error");
		report "Test outputs 16 passed" severity note;
		
		wait for clk_period;
		assert false report "TEST SUCCESS" severity failure;
		wait;
   end process;

END;
