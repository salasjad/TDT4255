----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:22:14 09/29/2015 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ALU is
	generic (
			width : positive := 32
		);
	port (
			operand1 	: in std_logic_vector (width - 1 downto 0) 	:= (others => '0');
			operand2 	: in std_logic_vector (width - 1 downto 0) 	:= (others => '0');
			ALU_control : in std_logic_vector (3 downto 0) 				:= (others => '0');
			result_out	: out std_logic_vector (width - 1 downto 0) 	:= (others => '0')
			);
end ALU;

architecture Behavioral of ALU is
signal result	: std_logic_vector (width - 1 downto 0) 	:= (others => '0');
begin
	
	ALU : process (operand1, operand2, ALU_control)
	begin
		case ALU_control is
					when "0000" => result <= operand1 and operand2; -- and
					when "0001" => result <= operand1 or operand2; -- or
					when "0010" => result <= std_logic_vector (signed(operand1) + signed(operand2)); -- add
					when "0101" => result <= operand1 nor operand2; -- nor
					when "0110" => result <= std_logic_vector (signed(operand1) - signed(operand2)); -- sub
					when "0111" => 
										if operand1 < operand2 then result <= x"00000001";
										else result <= x"00000000";
										end if;-- slt
					when "1000" => result <= operand2(15 downto 0) & "0000000000000000"; -- lui
					when others => result <= x"00000000";
		end case;
	end process ALU;
	
	result_out <= result(width - 1 downto 0);

end Behavioral;

