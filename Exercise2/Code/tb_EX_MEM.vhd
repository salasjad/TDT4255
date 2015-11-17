--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:40:17 11/04/2015
-- Design Name:   
-- Module Name:   /home/shomeb/f/fredribh/Documents/TDT4255/pipeline_processor/tb_EX_MEM.vhd
-- Project Name:  pipeline_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: EX_MEM
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
 
ENTITY tb_EX_MEM IS
END tb_EX_MEM;
 
ARCHITECTURE behavior OF tb_EX_MEM IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT EX_MEM
    PORT(
         WB_reg_write_in : IN  std_logic;
         WB_mem_to_reg_in : IN  std_logic;
         WB_reg_write_out : OUT  std_logic;
         WB_mem_to_reg_out : OUT  std_logic;
         MEM_we_in : IN  std_logic;
         MEM_we_out : OUT  std_logic;
         ALU_res_in : IN  std_logic_vector(31 downto 0);
         ALU_res_out : OUT  std_logic_vector(31 downto 0);
         write_data_in : IN  std_logic_vector(31 downto 0);
         write_data_out : OUT  std_logic_vector(31 downto 0);
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
   signal MEM_we_in : std_logic := '0';
   signal ALU_res_in : std_logic_vector(31 downto 0) := (others => '0');
   signal write_data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal reg_dest_in : std_logic_vector(4 downto 0) := (others => '0');
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal reg_en : std_logic := '0';

 	--Outputs
   signal WB_reg_write_out : std_logic;
   signal WB_mem_to_reg_out : std_logic;
   signal MEM_we_out : std_logic;
   signal ALU_res_out : std_logic_vector(31 downto 0);
   signal write_data_out : std_logic_vector(31 downto 0);
   signal reg_dest_out : std_logic_vector(4 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: EX_MEM PORT MAP (
          WB_reg_write_in => WB_reg_write_in,
          WB_mem_to_reg_in => WB_mem_to_reg_in,
          WB_reg_write_out => WB_reg_write_out,
          WB_mem_to_reg_out => WB_mem_to_reg_out,
          MEM_we_in => MEM_we_in,
          MEM_we_out => MEM_we_out,
          ALU_res_in => ALU_res_in,
          ALU_res_out => ALU_res_out,
          write_data_in => write_data_in,
          write_data_out => write_data_out,
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
		rst <= '1';
      wait for 100 ns;
		
		check(WB_reg_write_out = '0', "value should be zero after reset");
		check(WB_mem_to_reg_out = '0', "value should be zero after reset"); 
		check(MEM_we_out = '0', "value should be zero after reset");
		check(ALU_res_out = x"00000000", "value should be zero after reset");
		check(write_data_out = x"00000000", "value should be zero after reset");
		check(reg_dest_out = "00000", "value should be zero after reset");
		
      wait for clk_period*10;
		report "Test 1 passed" severity note;
		
		rst <= '0';
		reg_en <= '0';
		
		wait for clk_period;
		
		check(WB_reg_write_out = '0', "value should be zero when reg_en is 0");
		check(WB_mem_to_reg_out = '0', "value should be zero when reg_en is 0"); 
		check(MEM_we_out = '0', "value should be zero when reg_en is 0");
		check(ALU_res_out = x"00000000", "value should be zero when reg_en is 0");
		check(write_data_out = x"00000000", "value should be zero when reg_en is 0");
		check(reg_dest_out = "00000", "value should be zero when reg_en is 0");
		
      wait for clk_period*10;
		report "Test 2 passed" severity note;
		
		reg_en <= '1';
		WB_reg_write_in <= '0';
		WB_mem_to_reg_in <= '0';
		MEM_we_in <= '0';
		ALU_res_in <= x"00000000";
		write_data_in <= x"00000000";
		reg_dest_in <= "00000";
		
		wait for clk_period;
		
		check(WB_reg_write_out = '0', "value should be zero when input is 0");
		check(WB_mem_to_reg_out = '0', "value should be zero when input is 0"); 
		check(MEM_we_out = '0', "value should be zero when input is 0");
		check(ALU_res_out = x"00000000", "value should be zero when input is 0");
		check(write_data_out = x"00000000", "value should be zero when input is 0");
		check(reg_dest_out = "00000", "value should be zero when input is 0");
		
		wait for clk_period*10;
		report "Test 3 passed" severity note;
		
		WB_reg_write_in <= '1';
		WB_mem_to_reg_in <= '1';
		MEM_we_in <= '1';
		ALU_res_in <= x"01234567";
		write_data_in <= x"01234567";
		reg_dest_in <= "11111";
		
		wait for clk_period;
		
		check(WB_reg_write_out = '1', "value should be passed through");
		check(WB_mem_to_reg_out = '1', "value should be passed through"); 
		check(MEM_we_out = '1', "value should be passed through");
		check(ALU_res_out = x"01234567", "value should be passed through");
		check(write_data_out = x"01234567", "value should be passed through");
		check(reg_dest_out = "11111", "value should be passed through");
		
		wait for clk_period*10;
		report "Test 4 passed" severity note;
		
		WB_reg_write_in <= '1';
		WB_mem_to_reg_in <= '0';
		MEM_we_in <= '1';
		ALU_res_in <= x"fedcba98";
		write_data_in <= x"fedcba98";
		reg_dest_in <= "01010";
		
		wait for clk_period;
		
		check(WB_reg_write_out = '1', "value should be passed through");
		check(WB_mem_to_reg_out = '0', "value should be passed through"); 
		check(MEM_we_out = '1', "value should be passed through");
		check(ALU_res_out = x"fedcba98", "value should be passed through");
		check(write_data_out = x"fedcba98", "value should be passed through");
		check(reg_dest_out = "01010", "value should be passed through");
		
		wait for clk_period*10;
		report "Test 5 passed" severity note;
		

		assert false report "TEST SUCCESS" severity failure;
		wait;
   end process;

END;
