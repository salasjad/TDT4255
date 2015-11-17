----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:39:51 10/06/2015 
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
		clk 					: in std_logic := '0';
		rst 					: in std_logic := '0';
		processorEnable	: in std_logic := '0';
		instruction_in		: in std_logic_vector(width - 1 downto width - 6) := (others => '0');
		branch				: out std_logic := '0';
		pc_we					: out std_logic := '0';
		ir_we					: out std_logic := '0';
		reg_dst				: out std_logic := '0';
		reg_we				: out std_logic := '0';
		alu_src				: out std_logic := '0';
		alu_op				: out std_logic_vector(1 downto 0) := "00";
		jump					: out std_logic := '0';
		mem_we				: out std_logic := '0';
		mem_to_reg			: out std_logic := '0';
		reg_op_we			: out std_logic := '0'
		);

end control_unit;

architecture Behavioral of control_unit is
type state_t is (	STATE_IDLE, STATE_PC_UPDATE, STATE_FETCH, STATE_DECODE, STATE_JUMP, STATE_COMPARE, 
						STATE_BEQ, STATE_RTYPE, STATE_RTYPE_EX, STATE_RTYPE_WB, STATE_LW_SW, STATE_SW_WB, 
						STATE_LW_EX, STATE_LW_WB, STATE_LUI, STATE_LUI_WB);

signal state, next_state : state_t;
signal sig_opcode : std_logic_vector(5 downto 0);
begin

sig_opcode <= instruction_in(width - 1 downto width - 6);
reg_op_we <= processorEnable;

process(clk)
 begin
	if rising_edge(clk) then
		if rst = '1' then
			state <= STATE_IDLE; --go back to first state in FSM
			
		elsif processorEnable = '1' then
			state <= next_state; --go to next state in FSM
			
		elsif processorEnable = '0' then
			state <= state;
		
		else 
			state <= STATE_IDLE;
		end if;
	end if;
end process;

process(state, sig_opcode) --the sensitivity list
begin
case(state) is --case start for the FSM

	when STATE_IDLE =>
		next_state <= STATE_PC_UPDATE;
	-- Update program counter
	when STATE_PC_UPDATE => 
		next_state <= STATE_FETCH;
	-- Fetch instruction
	when STATE_FETCH => 
		next_state <= STATE_DECODE;
	-- Decode instruction
	when STATE_DECODE =>
		if sig_opcode = "000010" then
			next_state <= STATE_JUMP; 
		elsif sig_opcode = "000100" then
			next_state <= STATE_COMPARE;
		elsif sig_opcode = "000000" then
			next_state <= STATE_RTYPE;
		elsif sig_opcode = "001111" then
			next_state <= STATE_LUI;
		elsif sig_opcode = "100011" or sig_opcode = "101011" then
			next_state <= STATE_LW_SW;
		else
			next_state <= state;
		end if;
	-- Jump
	when STATE_JUMP =>
		next_state <= STATE_PC_UPDATE;
	-- Branch
	when STATE_COMPARE =>
			next_state <= STATE_BEQ;
	when STATE_BEQ =>
			next_state <= STATE_FETCH;
	-- R-Type
	when STATE_RTYPE =>
		next_state <= STATE_RTYPE_EX;
		
	when STATE_RTYPE_EX =>
		next_state <= STATE_RTYPE_WB;
		
	when STATE_RTYPE_WB =>
		next_state <= STATE_PC_UPDATE;
	-- Load/Store
	when STATE_LW_SW =>
		if sig_opcode = "100011" then -- LW
			next_state <= STATE_LW_EX;
		else -- SW
			next_state <= STATE_SW_WB;
		end if;
	-- Store
	when STATE_SW_WB =>
		next_state <= STATE_PC_UPDATE;
	-- Load
	when STATE_LW_EX =>
		next_state <= STATE_LW_WB;
		
	when STATE_LW_WB =>
		next_state <= STATE_PC_UPDATE;
	-- Load upper immediate
	when STATE_LUI =>
		next_state <= STATE_LUI_WB;

	when STATE_LUI_WB =>
		next_state <= STATE_PC_UPDATE;
		
	-- SHOULD NOT HAPPEN
	when others =>
		next_state <= STATE_PC_UPDATE;
	end case;
	
end process;

process(state)
begin
case(state) is
	
	when STATE_PC_UPDATE =>
		branch <= '0';
		pc_we <= '1';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "00";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when STATE_FETCH =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '1';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "00";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when STATE_DECODE =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "00";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
	
	when STATE_JUMP =>
		branch <= '0';
		pc_we <= '1';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "00";
		jump <= '1';
		mem_we <= '0';
		mem_to_reg <= '0';
	
	when STATE_COMPARE =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "01";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
	
	when STATE_BEQ =>
		branch <= '1';
		pc_we <= '1';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "01";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when STATE_RTYPE =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "10";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when STATE_RTYPE_EX =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '1';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "10";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when STATE_RTYPE_WB =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '1';
		reg_we <= '1';
		alu_src <= '0';
		alu_op <= "10";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when STATE_LW_SW =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '1';
		alu_op <= "00";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when STATE_SW_WB =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '1';
		alu_op <= "00";
		jump <= '0';
		mem_we <= '1';
		mem_to_reg <= '0';
		
	when STATE_LW_EX =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '1';
		alu_op <= "00";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '1';
		
	when STATE_LW_WB =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '1';
		alu_src <= '0';
		alu_op <= "00";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '1';
		
	when STATE_LUI =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '1';
		alu_op <= "11";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when STATE_LUI_WB =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '1';
		alu_src <= '0';
		alu_op <= "11";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
	when others =>
		branch <= '0';
		pc_we <= '0';
		ir_we <= '0';
		reg_dst <= '0';
		reg_we <= '0';
		alu_src <= '0';
		alu_op <= "00";
		jump <= '0';
		mem_we <= '0';
		mem_to_reg <= '0';
		
end case;
end process;

end Behavioral;

