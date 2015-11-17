----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    08:39:08 11/04/2015 
-- Design Name: 
-- Module Name:    forwarding_unit - Behavioral 
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

entity forwarding_unit is
	generic(
			address_width : positive := 5
			);
	port(
	EX_reg_s : in std_logic_vector(address_width - 1 downto 0);
	EX_reg_t : in std_logic_vector(address_width - 1 downto 0);
	ID_reg_s : in std_logic_vector(address_width - 1 downto 0);
	ID_reg_t : in std_logic_vector(address_width - 1 downto 0);
	MEM_destination : in std_logic_vector(address_width - 1 downto 0);
	WB_destination : in std_logic_vector(address_width - 1 downto 0);
	EX_MEM_regwrite : in std_logic;
	WB_regwrite : in std_logic;
	ForwardA : out std_logic_vector(1 downto 0);
	ForwardB : out std_logic_vector(1 downto 0);
	ForwardC : out std_logic_vector(1 downto 0);
	ForwardD : out std_logic_vector(1 downto 0)
);
end forwarding_unit;

architecture Behavioral of forwarding_unit is
constant zeros : std_logic_vector (4 downto 0) := (others => '0');
begin
-- Forwarding to the ID/EX register (in ID stage)
ForwardA <= "10" when ((EX_MEM_regwrite = '1' and MEM_destination /= zeros) and (ID_reg_s = MEM_destination)) else --forward MEM_ALU_res
				"01" when ((WB_regwrite = '1' and WB_destination /= zeros) and (ID_reg_s = WB_destination)) else -- forward WB_data
				"00"; -- output from register file

ForwardB <= "10" when ((EX_MEM_regwrite = '1' and MEM_destination /= zeros) and (ID_reg_t = MEM_destination)) else --forward MEM_ALU_res
				"01" when ((WB_regwrite = '1' and WB_destination /= zeros) and (ID_reg_t = WB_destination)) else --forward WB_data
				"00"; -- output from register file

-- Forwarding to the ALU (in EX stage)
ForwardC <= "10" when ((EX_MEM_regwrite = '1' and MEM_destination /= zeros) and (EX_reg_s = MEM_destination)) else --forward MEM_ALU_res
				"01" when ((WB_regwrite = '1' and WB_destination /= zeros) and (EX_reg_s = WB_destination)) else -- forward WB_data
				"00"; -- output from register file

ForwardD <= "10" when ((EX_MEM_regwrite = '1' and MEM_destination /= zeros) and (EX_reg_t = MEM_destination)) else --forward MEM_ALU_res
				"01" when ((WB_regwrite = '1' and WB_destination /= zeros) and (EX_reg_t = WB_destination)) else -- forward WB_data
				"00"; -- output from register file

end Behavioral;
