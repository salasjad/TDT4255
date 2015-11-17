--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:09:46 11/10/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/pipeline_processor/tb_forwarding_unit.vhd
-- Project Name:  pipeline_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: forwarding_unit
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
 
ENTITY tb_forwarding_unit IS
END tb_forwarding_unit;
 
ARCHITECTURE behavior OF tb_forwarding_unit IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT forwarding_unit
    PORT(
         EX_reg_s : IN  std_logic_vector(4 downto 0);
         EX_reg_t : IN  std_logic_vector(4 downto 0);
         ID_reg_s : IN  std_logic_vector(4 downto 0);
         ID_reg_t : IN  std_logic_vector(4 downto 0);
         MEM_destination : IN  std_logic_vector(4 downto 0);
         WB_destination : IN  std_logic_vector(4 downto 0);
         EX_MEM_regwrite : IN  std_logic;
         WB_regwrite : IN  std_logic;
         ForwardA : OUT  std_logic_vector(1 downto 0);
         ForwardB : OUT  std_logic_vector(1 downto 0);
         ForwardC : OUT  std_logic_vector(1 downto 0);
         ForwardD : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal EX_reg_s : std_logic_vector(4 downto 0) := (others => '0');
   signal EX_reg_t : std_logic_vector(4 downto 0) := (others => '0');
   signal ID_reg_s : std_logic_vector(4 downto 0) := (others => '0');
   signal ID_reg_t : std_logic_vector(4 downto 0) := (others => '0');
   signal MEM_destination : std_logic_vector(4 downto 0) := (others => '0');
   signal WB_destination : std_logic_vector(4 downto 0) := (others => '0');
   signal EX_MEM_regwrite : std_logic := '0';
   signal WB_regwrite : std_logic := '0';

 	--Outputs
   signal ForwardA : std_logic_vector(1 downto 0);
   signal ForwardB : std_logic_vector(1 downto 0);
   signal ForwardC : std_logic_vector(1 downto 0);
   signal ForwardD : std_logic_vector(1 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: forwarding_unit PORT MAP (
          EX_reg_s => EX_reg_s,
          EX_reg_t => EX_reg_t,
          ID_reg_s => ID_reg_s,
          ID_reg_t => ID_reg_t,
          MEM_destination => MEM_destination,
          WB_destination => WB_destination,
          EX_MEM_regwrite => EX_MEM_regwrite,
          WB_regwrite => WB_regwrite,
          ForwardA => ForwardA,
          ForwardB => ForwardB,
          ForwardC => ForwardC,
          ForwardD => ForwardD
        );
 

   -- Stimulus process
   stim_proc: process
   begin		
      wait for clk_period;
		
		-- ForwardC
		
		EX_reg_s <= "01000";
      EX_reg_t <= "00010";
		MEM_destination <= "01000";
		WB_destination <= "00100";
		EX_MEM_regwrite <= '1';
		WB_regwrite <= '1';
		ID_reg_s <= "00100";
		ID_reg_t <= "11111";
		
		wait for clk_period;
		
		check(ForwardC = "10", "MEM stage forwarding failure");
		check(ForwardD = "00", "no forwarding failure");
		check(ForwardA = "01", "WB stage forwarding failure");
		check(ForwardB = "00", "no forwarding failure");
		report "Test 1 passed" severity note;
		
		EX_reg_s <= "00110";
      EX_reg_t <= "00010";
		MEM_destination <= "00010";
		WB_destination <= "00000";
		EX_MEM_regwrite <= '1';
		WB_regwrite <= '0';
		ID_reg_s <= "00100";
		ID_reg_t <= "00010";
		
		wait for clk_period;
		
		check(ForwardC = "00", "no forwarding failure");
		check(ForwardD = "10", "MEM stage forwarding failure");
		check(ForwardA = "00", "no forwarding failure");
		check(ForwardB = "10", "MEM stage forwarding failure");
		report "Test 2 passed" severity note;
		
		EX_reg_s <= "00010";
      EX_reg_t <= "00010";
		MEM_destination <= "00011";
		WB_destination <= "00010";
		EX_MEM_regwrite <= '1';
		WB_regwrite <= '1';
		ID_reg_s <= "00011";
		ID_reg_t <= "00010";
		
		wait for clk_period;
		
		check(ForwardC = "01", "WB forwarding failure");
		check(ForwardD = "01", "WB stage forwarding failure");
		check(ForwardA = "10", "MEM forwarding failure");
		check(ForwardB = "01", "WB stage forwarding failure");
		report "Test 3 passed" severity note;


      assert false report "TEST SUCCESS" severity failure;
      wait;
   end process;

END;
