--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:18:06 11/04/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/pipeline_processor/tb_ID_EX.vhd
-- Project Name:  pipeline_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ID_EX
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
 
ENTITY tb_ID_EX IS
END tb_ID_EX;
 
ARCHITECTURE behavior OF tb_ID_EX IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ID_EX
    PORT(
         WB_reg_write_in : IN  std_logic;
         WB_mem_to_reg_in : IN  std_logic;
         WB_reg_write_out : OUT  std_logic;
         WB_mem_to_reg_out : OUT  std_logic;
         MEM_we_in : IN  std_logic;
         MEM_we_out : OUT  std_logic;
         EX_reg_dst_in : IN  std_logic;
         EX_ALU_op_in : IN  std_logic_vector(1 downto 0);
         EX_ALU_src_in : IN  std_logic;
         EX_reg_dst_out : OUT  std_logic;
         EX_ALU_op_out : OUT  std_logic_vector(1 downto 0);
         EX_ALU_src_out : OUT  std_logic;
         reg_data1_in : IN  std_logic_vector(31 downto 0);
         reg_data2_in : IN  std_logic_vector(31 downto 0);
         reg_data1_out : OUT  std_logic_vector(31 downto 0);
         reg_data2_out : OUT  std_logic_vector(31 downto 0);
         sign_extended_in : IN  std_logic_vector(31 downto 0);
         sign_extended_out : OUT  std_logic_vector(31 downto 0);
         reg_s_in : IN  std_logic_vector(4 downto 0);
         reg_s_out : OUT  std_logic_vector(4 downto 0);
         reg_t_in : IN  std_logic_vector(4 downto 0);
         reg_t_out : OUT  std_logic_vector(4 downto 0);
         reg_d_in : IN  std_logic_vector(4 downto 0);
         reg_d_out : OUT  std_logic_vector(4 downto 0);
         clk : IN  std_logic;
         rst : IN  std_logic;
         reg_en : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal WB_reg_write_in : std_logic := '0';
   signal WB_mem_to_reg_in : std_logic := '0';
   signal MEM_we_in : std_logic := '0';
   signal EX_reg_dst_in : std_logic := '0';
   signal EX_ALU_op_in : std_logic_vector(1 downto 0) := "00";
   signal EX_ALU_src_in : std_logic := '0';
   signal reg_data1_in : std_logic_vector(31 downto 0) := (others => '0');
   signal reg_data2_in : std_logic_vector(31 downto 0) := (others => '0');
   signal sign_extended_in : std_logic_vector(31 downto 0) := (others => '0');
   signal reg_s_in : std_logic_vector(4 downto 0) := (others => '0');
   signal reg_t_in : std_logic_vector(4 downto 0) := (others => '0');
   signal reg_d_in : std_logic_vector(4 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal reg_en : std_logic := '0';

 	--Outputs
   signal WB_reg_write_out : std_logic;
   signal WB_mem_to_reg_out : std_logic;
   signal MEM_we_out : std_logic;
   signal EX_reg_dst_out : std_logic;
   signal EX_ALU_op_out : std_logic_vector(1 downto 0);
   signal EX_ALU_src_out : std_logic;
   signal reg_data1_out : std_logic_vector(31 downto 0);
   signal reg_data2_out : std_logic_vector(31 downto 0);
   signal sign_extended_out : std_logic_vector(31 downto 0);
   signal reg_s_out : std_logic_vector(4 downto 0);
   signal reg_t_out : std_logic_vector(4 downto 0);
   signal reg_d_out : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ID_EX PORT MAP (
          WB_reg_write_in => WB_reg_write_in,
          WB_mem_to_reg_in => WB_mem_to_reg_in,
          WB_reg_write_out => WB_reg_write_out,
          WB_mem_to_reg_out => WB_mem_to_reg_out,
          MEM_we_in => MEM_we_in,
          MEM_we_out => MEM_we_out,
          EX_reg_dst_in => EX_reg_dst_in,
          EX_ALU_op_in => EX_ALU_op_in,
          EX_ALU_src_in => EX_ALU_src_in,
          EX_reg_dst_out => EX_reg_dst_out,
          EX_ALU_op_out => EX_ALU_op_out,
          EX_ALU_src_out => EX_ALU_src_out,
          reg_data1_in => reg_data1_in,
          reg_data2_in => reg_data2_in,
          reg_data1_out => reg_data1_out,
          reg_data2_out => reg_data2_out,
          sign_extended_in => sign_extended_in,
          sign_extended_out => sign_extended_out,
          reg_s_in => reg_s_in,
          reg_s_out => reg_s_out,
          reg_t_in => reg_t_in,
          reg_t_out => reg_t_out,
          reg_d_in => reg_d_in,
          reg_d_out => reg_d_out,
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
		
		WB_mem_to_reg_in <= '1';
		
		wait for clk_period;
		
		check(WB_mem_to_reg_out = '1', "WB_mem_to_reg_out failure");
		report "Test 2 passed" severity note;
		
		MEM_we_in <= '1';
		
		wait for clk_period;
		
		check(MEM_we_out = '1', "MEM_we_out failure");
		report "Test 3 passed" severity note;
		
		EX_reg_dst_in <= '1';
		
		wait for clk_period;
		
		check(EX_reg_dst_out = '1', "EX_reg_dst_out failure");
		report "Test 4 passed" severity note;
		
		EX_ALU_op_in <= "01";
		
		wait for clk_period;
		
		check(EX_ALU_op_out = "01", "EX_ALU_op_out failure");
		report "Test 5 passed" severity note;
		
		EX_ALU_src_in <= '1';
		
		wait for clk_period;
		
		check(EX_ALU_src_out = '1', "EX_ALU_src_out failure");
		report "Test 6 passed" severity note;
		
		reg_data1_in <= X"01578946";
		
		wait for clk_period;
		
		check(reg_data1_out = X"01578946", "reg_data1_out failure");
		report "Test 7 passed" severity note;
		
		reg_data2_in <= X"98524762";
		
		wait for clk_period;
		
		check(reg_data2_out = X"98524762", "reg_data2_out failure");
		report "Test 8 passed" severity note;
		
		sign_extended_in <= X"97643105";
		
		wait for clk_period;
		
		check(sign_extended_out = X"97643105", "sign_extended_out failure");
		report "Test 9 passed" severity note;
		
		reg_s_in <= "01010";
		
		wait for clk_period;
		
		check(reg_s_out = "01010", "reg_s_out failure");
		report "Test 10 passed" severity note;
		
		reg_t_in <= "10101";
		
		wait for clk_period;
		
		check(reg_t_out = "10101", "reg_t_out failure");
		report "Test 11 passed" severity note;
		
		reg_d_in <= "11100";
		
		wait for clk_period;
		
		check(reg_d_out = "11100", "reg_d_out failure");
		report "Test 12 passed" severity note;

      wait for clk_period;
		assert false report "TEST SUCCESS" severity failure;
		wait;
		
   end process;

END;
