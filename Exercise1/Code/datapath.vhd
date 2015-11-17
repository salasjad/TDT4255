----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:41:26 10/06/2015 
-- Design Name: 
-- Module Name:    datapath - Behavioral 
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity datapath is
port(
	clk 						: in std_logic;
	rst 						: in std_logic;
	branch 					: in std_logic;
	jump 						: in std_logic;
	pc_we						: in std_logic;
	ir_we 					: in std_logic;
	reg_we 					: in std_logic;
	alu_src 					: in std_logic;
	alu_op_ctrl				: in std_logic_vector(1 downto 0);
	mem_to_reg				: in std_logic;
	reg_dst					: in std_logic;
	reg_op_we				: in std_logic;
	instruction_in 		: in std_logic_vector(31 downto 0);
	instruction_address	: out std_logic_vector(31 downto 0);
	data_memory_address 	: out std_logic_vector(31 downto 0);
	data_memory_data 		: out std_logic_vector(31 downto 0);
	data_memory_in1		: in std_logic_vector(31 downto 0);
	opcode 					: out std_logic_vector(5 downto 0)
);
end datapath;

architecture Behavioral of datapath is
	COMPONENT program_counter
	PORT(
		pc_in : IN std_logic_vector(31 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;
		wr_en : IN std_logic;
		reg_en : IN std_logic;          
		pc_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT add
	PORT(
		add_in1 : IN std_logic_vector(31 downto 0);
		add_in2 : IN std_logic_vector(31 downto 0);          
		add_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT concat
	PORT(
		instruction_in : IN std_logic_vector(25 downto 0);
		pc_in : IN std_logic_vector(5 downto 0);          
		concat_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT register_file
	PORT(
		r_reg1 : IN std_logic_vector(4 downto 0);
		r_reg2 : IN std_logic_vector(4 downto 0);
		RegWrite : IN std_logic;
		rst : IN std_logic;
		clk : IN std_logic;
		w_reg : IN std_logic_vector(4 downto 0);
		w_data : IN std_logic_vector(31 downto 0);          
		r_data1 : OUT std_logic_vector(31 downto 0);
		r_data2 : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT ALU
	PORT(
		operand1 : IN std_logic_vector(31 downto 0);
		operand2 : IN std_logic_vector(31 downto 0);
		ALU_control : IN std_logic_vector(3 downto 0);          
		result_out : OUT std_logic_vector(31 downto 0);
		zero : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT simple_register
	PORT(
		data_in : IN std_logic_vector(31 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;
		wr_en : IN std_logic;          
		data_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT sign_extend
	PORT(
		signed_input : IN std_logic_vector(15 downto 0);          
		signed_output : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT ALU_op
	PORT(
		ALUop : IN std_logic_vector(1 downto 0);
		funct_field : IN std_logic_vector(5 downto 0);          
		ALU_control : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux
	PORT(
		mux_in1 : IN std_logic_vector(31 downto 0);
		mux_in2 : IN std_logic_vector(31 downto 0);
		src_select : IN std_logic;          
		mux_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_reg
	PORT(
		mux_in1 : IN std_logic_vector(4 downto 0);
		mux_in2 : IN std_logic_vector(4 downto 0);
		src_select : IN std_logic;          
		mux_out : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;

		signal jump_mux_out 		: std_logic_vector(31 downto 0);
		signal jump_mux_in1 		: std_logic_vector(31 downto 0);
		signal branch_mux_out	: std_logic_vector(31 downto 0);
		signal branch_mux_in0	: std_logic_vector(31 downto 0);
		signal branch_mux_in1	: std_logic_vector(31 downto 0);
		signal reg_mux_in0 		: std_logic_vector(4 downto 0); 
		signal reg_mux_in1 		: std_logic_vector(4 downto 0); 
		signal reg_mux_out 		: std_logic_vector(4 downto 0); 
		signal alu_mux_in0		: std_logic_vector(31 downto 0); 
		signal mem_mux_in1		: std_logic_vector(31 downto 0);
		signal mem_mux_out		: std_logic_vector(31 downto 0);
		signal pc_out				: std_logic_vector(31 downto 0);
		signal add_in1				: std_logic_vector(31 downto 0); 
		signal address 			: std_logic_vector(25 downto 0);
		signal r_reg_in1			: std_logic_vector(4 downto 0);
		signal r_reg_in2			: std_logic_vector(4 downto 0);
		signal r_data1				: std_logic_vector(31 downto 0);
		signal r_data2 			: std_logic_vector(31 downto 0);
		signal immediate 			: std_logic_vector(15 downto 0);
		signal signed_output		: std_logic_vector(31 downto 0);
		signal signed_output_1	: std_logic_vector(31 downto 0);
		signal alu_in1				: std_logic_vector(31 downto 0);
		signal alu_in2				: std_logic_vector(31 downto 0);
		signal reg_wd_out 		: std_logic_vector(31 downto 0);
		signal sel_mux1			: std_logic;
		signal alu_control		: std_logic_vector(3 downto 0);
		signal zero					: std_logic;
		signal pc_wr 				: std_logic;
		signal instruction 		: std_logic_vector(31 downto 0);
		signal alu_out				: std_logic_vector(31 downto 0);
		signal alu_op_in 			: std_logic_vector(5 downto 0);
		
begin
	add_in1 <= x"00000001";
	pc_wr <= pc_we or (zero and branch);
	sel_mux1 <= branch and zero;
	instruction_address <= pc_out;
	mem_mux_in1 <= data_memory_in1;
	data_memory_address <= alu_out;
	address <= instruction(25 downto 0);
	r_reg_in1 <= instruction(25 downto 21);
	r_reg_in2 <= instruction(20 downto 16);
	immediate <= instruction(15 downto 0);
	alu_op_in <= immediate(5 downto 0);
	reg_mux_in0 <= instruction(20 downto 16);
	reg_mux_in1 <= instruction(15 downto 11);
	opcode <= instruction(31 downto 26);
	data_memory_data <= r_data2;
	signed_output_1 <= std_logic_vector(signed(signed_output) - 1);
	
	-- Program counter
	pc : program_counter  port map(jump_mux_out, clk, rst, pc_wr, reg_op_we, pc_out);
	-- Adder adding 1 to PC
	add1 : add port map(add_in1, pc_out, branch_mux_in0);
	-- Concatenation of PC and immediate in case of jump
	concatenaton : concat port map(address, branch_mux_in0(31 downto 26), jump_mux_in1);
	-- Adder adding offset in case of branch
	add2 : add port map(branch_mux_in0, signed_output_1, branch_mux_in1);
	-- Sign extender
	sign_ext : sign_extend port map(immediate, signed_output);
	-- Register file
	reg_file : register_file port map(r_reg_in1, r_reg_in2, reg_we, rst, clk, reg_mux_out, reg_wd_out, r_data1, r_data2);
	-- Register for data from register file
	reg_op1 : simple_register port map(r_data1, clk, rst, reg_op_we, alu_in1);
	-- Register for data from register file
	reg_op2 : simple_register port map(r_data2, clk, rst, reg_op_we, alu_mux_in0);
	-- Register for data to be saved in register file
	reg_wd : simple_register port map(mem_mux_out, clk, rst, reg_op_we, reg_wd_out);
	-- Multiplexer selecting output in case of branch
	mux1 : mux port map(branch_mux_in0, branch_mux_in1, sel_mux1, branch_mux_out);
	-- Multiplexer selecting output in case of jump
	mux2 : mux port map(branch_mux_out, jump_mux_in1, jump, jump_mux_out);
	-- Multiplexer selecting output for ALU
	mux3 : mux port map(alu_mux_in0, signed_output, alu_src, alu_in2);
	-- Multiplexer selecting output to be written to register file
	mux4 : mux port map(alu_out, mem_mux_in1, mem_to_reg,mem_mux_out);
	-- Multiplexer selecting output for register file write address
	mux5 : mux_reg port map(reg_mux_in0, reg_mux_in1, reg_dst, reg_mux_out);
	-- ALU control unit
	aluop : alu_op port map(alu_op_ctrl, alu_op_in ,alu_control);
	-- Instruction register
	instr_reg : program_counter port map(instruction_in, clk, rst, ir_we, reg_op_we, instruction);
	-- ALU
	alu_unit : alu port map(alu_in1, alu_in2, alu_control, alu_out, zero);

end Behavioral;

