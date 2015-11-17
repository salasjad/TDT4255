----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:34:11 09/29/2015 
-- Design Name: 
-- Module Name:    ALU_op - Behavioral 
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

entity ALU_op is
	port (
			ALUop 		: in std_logic_vector(1 downto 0);
			funct_field	: in std_logic_vector(5 downto 0);
			ALU_control	: out std_logic_vector(3 downto 0)
	);
end ALU_op;

architecture Behavioral of ALU_op is
begin
	alu_op : process(ALUop, funct_field)
	begin
		if ALUop = "00" then -- LOAD/STORE
			ALU_control <= "0010";
		elsif ALUop = "10" then -- R-TYPE
			case funct_field is 
				when "100100" => ALU_control <= "0000"; -- and
				when "100101" => ALU_control <= "0001"; -- or
				when "100000" => ALU_control <= "0010"; -- add
				when "100111" => ALU_control <= "0101"; -- nor
				when "100010" => ALU_control <= "0110"; -- sub
				when "101010" => ALU_control <= "0111"; -- slt
				when others   => ALU_control <= "1001";
			end case;
		else
			ALU_control <= "1000"; --lui
		end if;
	end process alu_op;

end Behavioral;

