--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   11:58:00 09/29/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_ALU.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ALU
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
 
ENTITY tb_ALU IS
END tb_ALU;
 
ARCHITECTURE behavior OF tb_ALU IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ALU
    PORT(
         operand1 : IN  std_logic_vector(31 downto 0);
         operand2 : IN  std_logic_vector(31 downto 0);
         ALU_control : IN  std_logic_vector(3 downto 0);
         result_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal operand1 : std_logic_vector(31 downto 0) := (others => '0');
   signal operand2 : std_logic_vector(31 downto 0) := (others => '0');
   signal ALU_control : std_logic_vector(3 downto 0) := (others => '0');

 	--Outputs
   signal result_out : std_logic_vector(31 downto 0);
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ALU PORT MAP (
          operand1 => operand1,
          operand2 => operand2,
          ALU_control => ALU_control,
          result_out => result_out
        );

 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 10 ns.
      wait for 10 ns;	
	----------------------AND-----------------------------------------
			operand1 <=  x"00000000";
			operand2 <=  x"00000000";
			ALU_control  <= "0000";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test and 1 passed" severity note;

			operand1 <= x"FFFFFFFF";
			operand2 <= x"FFFFFFFF";
		
			wait for clk_period;
			
			check(result_out = x"FFFFFFFF", "Output error");
			report "Test and 2 passed" severity note;

      	for I in 1 to 32 loop
				operand1 <= std_logic_vector(To_signed(I*42000,32));
				operand2 <= std_logic_vector(To_signed(I*89,32));
				
				wait for clk_period;
				
				check(result_out = std_logic_vector(To_signed(I*42000,32) and To_signed(I*89,32)), "Output error");
				report "Test and 3 passed" severity note;
				
				wait for clk_period; 
			end loop;
			
			----------------------OR-----------------------------------------
			operand1 <=  x"00000000";
			operand2 <=  x"00000000";
			ALU_control  <= "0001";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test or 1 passed" severity note;

			operand1 <= x"FFFFFFFF";
			operand2 <= x"FFFFFFFF";
		
			wait for clk_period;
			
			check(result_out = x"FFFFFFFF", "Output error");
			report "Test or 2 passed" severity note;

      	for I in 1 to 32 loop
				operand1 <= std_logic_vector(To_signed(I*42000,32));
				operand2 <= std_logic_vector(To_signed(I*89,32));
				
				wait for clk_period;
				
				check(result_out = std_logic_vector(To_signed(I*42000,32) or To_signed(I*89,32)), "Output error");
				report "Test or 3 passed" severity note;
				
				wait for clk_period; 
			end loop;

			---------------------------ADD------------------------------------
			operand1 <=  x"00000000";
			operand2 <=  x"00000000";
			ALU_control  <= "0010";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test add 1 passed" severity note;

			operand1 <= x"FFFFFFFF";
			operand2 <= x"FFFFFFFF";
		
			wait for clk_period;
			
			check(result_out = x"FFFFFFFE", "Output error");
			report "Test add 2 passed" severity note;

      	for I in 1 to 32 loop
				operand1 <= std_logic_vector(To_signed(I*42000,32));
				operand2 <= std_logic_vector(To_signed(I*89,32));
				
				wait for clk_period;
				
				check(result_out = std_logic_vector(To_signed(I*42000,32) + To_signed(I*89,32)), "Output error");
				report "Test add 3 passed" severity note;
				
				wait for clk_period; 
			end loop;
			
			---------------------------NOR------------------------------------
			operand1 <=  x"00000000";
			operand2 <=  x"00000000";
			ALU_control  <= "0101";
		
			wait for clk_period;
			
			check(result_out = x"FFFFFFFF", "Output error");
			report "Test nor 1 passed" severity note;

			operand1 <= x"FFFFFFFF";
			operand2 <= x"FFFFFFFF";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test nor 2 passed" severity note;

      	for I in 1 to 32 loop
				operand1 <= std_logic_vector(To_signed(I*42000,32));
				operand2 <= std_logic_vector(To_signed(I*89,32));
				
				wait for clk_period;
				
				check(result_out = std_logic_vector(To_signed(I*42000,32) nor To_signed(I*89,32)), "Output error");
				report "Test nor 3 passed" severity note;
				
				wait for clk_period; 
			end loop;
			
			---------------------------SUB------------------------------------
			operand1 <=  x"00000000";
			operand2 <=  x"00000000";
			ALU_control  <= "0110";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test sub 1 passed" severity note;

			operand1 <= x"FFFFFFFF";
			operand2 <= x"FFFFFFFF";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test sub 2 passed" severity note;

      	for I in 1 to 32 loop
				operand1 <= std_logic_vector(To_signed(I*42000,32));
				operand2 <= std_logic_vector(To_signed(I*89,32));
				
				wait for clk_period;
				
				check(result_out = std_logic_vector(To_signed(I*42000,32) - To_signed(I*89,32)), "Output error");
				report "Test sub 3 passed" severity note;
				
				wait for clk_period; 
			end loop;
			
			---------------------------SLT------------------------------------
			operand1 <=  x"00000000";
			operand2 <=  x"00000000";
			ALU_control  <= "0111";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test slt 1 passed" severity note;

			operand1 <= x"FFFFFFFF";
			operand2 <= x"FFFFFFFF";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test slt 2 passed" severity note;

      	for I in 1 to 32 loop
				operand1 <= std_logic_vector(To_signed(I*42000,32));
				operand2 <= std_logic_vector(To_signed(I*89,32));
				
				wait for clk_period;
				
				if operand1 < operand2 then 
					check(result_out = x"00000001", "Output error");
					report "Test slt 3 passed" severity note;
				else 
					check(result_out = x"00000000", "Output error");
					report "Test slt 3 passed" severity note;
				end if;
				
				wait for clk_period; 
			end loop;
			
			---------------------------LUI------------------------------------
			operand1 <=  x"00000000";
			operand2 <=  x"00000000";
			ALU_control  <= "1000";
		
			wait for clk_period;
			
			check(result_out = x"00000000", "Output error");
			report "Test lui 1 passed" severity note;

			operand1 <= x"FFFFFFFF";
			operand2 <= x"FFFFFFFF";
		
			wait for clk_period;
			
			check(result_out = x"FFFF0000", "Output error");
			report "Test lui 2 passed" severity note;
	
			operand1 <= x"10101010";
			operand2 <= x"00000001";
		
			wait for clk_period;
			
			check(result_out = x"00010000", "Output error");
			report "Test lui 3 passed" severity note;
			
			
			wait for clk_period;
			assert false report "TEST SUCCESS" severity failure;
			wait;
   end process;

END;
