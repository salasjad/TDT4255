--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:27:56 09/22/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_register_file.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: register_file
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
USE ieee.numeric_std.ALL;
 
ENTITY tb_register_file IS
END tb_register_file;
 
ARCHITECTURE behavior OF tb_register_file IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT register_file
    PORT(
         r_reg1 : IN  std_logic_vector(4 downto 0);
         r_reg2 : IN  std_logic_vector(4 downto 0);
         RegWrite : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         w_reg : IN  std_logic_vector(4 downto 0);
         w_data : IN  std_logic_vector(31 downto 0);
         r_data1 : OUT  std_logic_vector(31 downto 0);
         r_data2 : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal r_reg1 : std_logic_vector(4 downto 0) := (others => '0');
   signal r_reg2 : std_logic_vector(4 downto 0) := (others => '0');
   signal RegWrite : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal w_reg : std_logic_vector(4 downto 0) := (others => '0');
   signal w_data : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal r_data1 : std_logic_vector(31 downto 0);
   signal r_data2 : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: register_file PORT MAP (
          r_reg1 => r_reg1,
          r_reg2 => r_reg2,
          RegWrite => RegWrite,
          rst => rst,
          clk => clk,
          w_reg => w_reg,
          w_data => w_data,
          r_data1 => r_data1,
          r_data2 => r_data2
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
      wait for clk_period*10;
		
			for I in 0 to 31 loop
				--Conversion from natural to std_logic_vector
				w_data <= std_logic_vector(To_unsigned(I,32));
				w_reg  <= std_logic_vector(To_unsigned(I,5));
				
				wait for clk_period;
				
				RegWrite <= '1';
				
				wait for clk_period;
				
				RegWrite <= '0';
			end loop;
			
			for I in 0 to 31 loop
				r_reg1 <= std_logic_vector(To_unsigned(I,5));
				r_reg2 <= std_logic_vector(To_unsigned(I,5));
				w_reg  <= std_logic_vector(To_unsigned(I,5));
				
				wait for clk_period;
				
				check(r_data1 = std_logic_vector(To_unsigned(I,32)), "r_data1 value is not as it should be");
				report "Test 1 passed" severity note;
				check(r_data2 = std_logic_vector(To_unsigned(I,32)), "r_data2 value is not as it should be");
				report "Test 2 passed" severity note;

				wait for clk_period;
			end loop;

			for I in 0 to 31 loop
				r_reg1 <= std_logic_vector(To_unsigned(I,5));
				r_reg2 <= std_logic_vector(To_unsigned(31 - I,5));
				
				wait for clk_period;
				
				check(r_data1 = std_logic_vector(To_unsigned(I,32)), "r_data1 value is not as it should be");
				report "Test 1 passed" severity note;
				check(r_data2 = std_logic_vector(To_unsigned(31 - I,32)), "r_data2 value is not as it should be");
				report "Test 2 passed" severity note;

				wait for clk_period;
			end loop;

			rst <= '1';

			wait for clk_period;	
		
			rst <= '0';
			wait for clk_period;
			
			for I in 0 to 31 loop
				r_reg1 <= std_logic_vector(To_unsigned(I,5));
				r_reg2 <= std_logic_vector(To_unsigned(I,5));
				
				wait for clk_period;
				
				check(r_data1 = x"00000000", "r_data1 value is not as it should be");
				report "Test 1 passed" severity note;
				check(r_data2 = x"00000000", "r_data2 value is not as it should be");
				report "Test 2 passed" severity note;

				wait for clk_period;
			end loop;

			assert false report "TEST SUCCESS" severity failure;
      wait;
   end process;

END;
