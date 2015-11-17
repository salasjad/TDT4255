----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:55:00 11/03/2015 
-- Design Name: 
-- Module Name:    control_unit - Behavioral 
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

entity control_unit is
	generic(
			width : integer := 32
		);
	port(

		instruction	: in std_logic_vector(width - 1 downto 0) := (others => '0');
		equals		: in std_logic := '0';

		--EX
		reg_dest 	: out std_logic := '0';
		ALU_op		: out std_logic_vector(1 downto 0) := "00";
		ALU_src		: out std_logic := '0';

		--MEM
		mem_we		: out std_logic := '0';
		mem_re		: out std_logic := '0';

		--WB
		reg_we 		: out std_logic := '0';
		mem_to_reg 	: out std_logic := '0';

		--OTHER
		jump		: out std_logic := '0';
		branch 		: out std_logic := '0';
		flush		: out std_logic := '0'
		);
end control_unit;

architecture Behavioral of control_unit is
signal opcode : std_logic_vector(5 downto 0);

begin

opcode <= instruction(31 downto 26);

control_unit : process(opcode, instruction, equals)
	begin
		if instruction = x"00000000" then
			--EX
			reg_dest <= '0';
			ALU_op <= "00";
			ALU_src <= '0';

			--MEM
			mem_we <= '0';
			mem_re <= '0';

			--WB
			reg_we <= '0';
			mem_to_reg <= '0';

			--OTHER
			jump <= '0';
			branch <= '0';
			flush <= '0';

		elsif opcode = "000000" then -- R-type
			--EX
			reg_dest <= '1';
			ALU_op <= "10";
			ALU_src <= '0';

			--MEM
			mem_we <= '0';
			mem_re <= '0';

			--WB
			reg_we <= '1';
			mem_to_reg <= '0';

			--OTHER
			jump <= '0';
			branch <= '0';
			flush <= '0';

		elsif opcode = "100011" then -- lw
			--EX
			reg_dest <= '0';
			ALU_op <= "00";
			ALU_src <= '1';

			--MEM
			mem_we <= '0';
			mem_re <= '1';

			--WB
			reg_we <= '1';
			mem_to_reg <= '1';

			--OTHER
			jump <= '0';
			branch <= '0';
			flush <= '0';

		elsif opcode = "101011" then -- sw
			--EX
			reg_dest <= '0';
			ALU_op <= "00";
			ALU_src <= '1';

			--MEM
			mem_we <= '1';
			mem_re <= '0';

			--WB
			reg_we <= '0';
			mem_to_reg <= '0';

			--OTHER
			jump <= '0';
			branch <= '0';
			flush <= '0';

		elsif opcode = "000010" then -- j
			--EX
			reg_dest <= '0';
			ALU_op <= "00";
			ALU_src <= '0';

			--MEM
			mem_we <= '0';
			mem_re <= '0';

			--WB
			reg_we <= '0';
			mem_to_reg <= '0';

			--OTHER
			jump <= '1';
			branch <= '0';
			flush <= '1';
			
		elsif opcode = "000100" then -- beq
			--EX
			reg_dest <= '0';
			ALU_op <= "00";
			ALU_src <= '0';

			--MEM
			mem_we <= '0';
			mem_re <= '0';

			--WB
			reg_we <= '0';
			mem_to_reg <= '0';

			--OTHER
			jump <= '0';
			branch <= equals;
			flush <= equals;
		
		else -- lui
			--EX
			reg_dest <= '0';
			ALU_op <= "01";
			ALU_src <= '1';

			--MEM
			mem_we <= '0';
			mem_re <= '0';

			--WB
			reg_we <= '1';
			mem_to_reg <= '0';

			--OTHER
			jump <= '0';
			branch <= '0';
			flush <= '0';
			
		end if;
		
	end process;
end Behavioral;

