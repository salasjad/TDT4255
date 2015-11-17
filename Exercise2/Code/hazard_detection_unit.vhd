----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:54:45 11/04/2015 
-- Design Name: 
-- Module Name:    hazard_detection_unit - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hazard_detection_unit is
port(
	ID_instruction : in std_logic_vector(9	downto 0);
	ID_EX_reg_t : in std_logic_vector(4 downto 0);
	ID_EX_memread : in std_logic;
	to_nop_mux : out std_logic;
	pc_we : out std_logic
);
end hazard_detection_unit;

architecture Behavioral of hazard_detection_unit is
signal IF_ID_reg_s : std_logic_vector(4 downto 0);
signal IF_ID_reg_t : std_logic_vector(4 downto 0);
begin

		IF_ID_reg_s <= ID_instruction(9 downto 5);
		IF_ID_reg_t <= ID_instruction(4 downto 0);
		
		process(ID_EX_reg_t, ID_EX_memread, IF_ID_reg_s, IF_ID_reg_t)
			begin
			if(ID_EX_memread = '1' and ((ID_EX_reg_t = IF_ID_reg_s) or (ID_EX_reg_t = IF_ID_reg_t))) then -- Stall the pipeline in case of the load instruction
				pc_we <= '0';
				to_nop_mux <= '1';
			else
				pc_we <= '1';
				to_nop_mux <= '0';
			end if;
		end process;

end Behavioral;
