----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:24:27 11/04/2015 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MIPSProcessor is
	generic (
				DATA_WIDTH : integer := 32;
				ADDR_WIDTH : integer := 32
				);
	port(
		processorEnable : in std_logic;
		instruction_address : out std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
		instruction_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		data_address : out std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
		data_in : in std_logic_vector(DATA_WIDTH - 1 downto 0);
		data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
		mem_we : out std_logic := '0';
		rst : in std_logic;
		clk : in std_logic
	);
end MIPSProcessor;

architecture Behavioral of MIPSProcessor is
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
		result_out : OUT std_logic_vector(31 downto 0)
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
	generic (width : positive);
	PORT(
		mux_in1 : IN std_logic_vector(width-1 downto 0);
		mux_in2 : IN std_logic_vector(width-1 downto 0);
		src_select : IN std_logic;          
		mux_out : OUT std_logic_vector(width-1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT mux_3_to_1
	PORT(
		in1 : IN std_logic_vector(31 downto 0);
		in2 : IN std_logic_vector(31 downto 0);
		in3 : IN std_logic_vector(31 downto 0);
		forward : IN std_logic_vector(1 downto 0);          
		output : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT EX_MEM
	PORT(
		WB_reg_write_in : IN std_logic;
		WB_mem_to_reg_in : IN std_logic;
		MEM_we_in : IN std_logic;
		ALU_res_in : IN std_logic_vector(31 downto 0);
		write_data_in : IN std_logic_vector(31 downto 0);
		reg_dest_in : IN std_logic_vector(4 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;
		reg_en : IN std_logic;          
		WB_reg_write_out : OUT std_logic;
		WB_mem_to_reg_out : OUT std_logic;
		MEM_we_out : OUT std_logic;
		ALU_res_out : OUT std_logic_vector(31 downto 0);
		write_data_out : OUT std_logic_vector(31 downto 0);
		reg_dest_out : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;
	
	COMPONENT ID_EX
	PORT(
		WB_reg_write_in : IN std_logic;
		WB_mem_to_reg_in : IN std_logic;
		MEM_we_in : IN std_logic;
		MEM_re_in : IN std_logic;
		EX_reg_dst_in : IN std_logic;
		EX_ALU_op_in : IN std_logic_vector(1 downto 0);
		EX_ALU_src_in : IN std_logic;
		reg_data1_in : IN std_logic_vector(31 downto 0);
		reg_data2_in : IN std_logic_vector(31 downto 0);
		sign_extended_in : IN std_logic_vector(31 downto 0);
		reg_s_in : IN std_logic_vector(4 downto 0);
		reg_t_in : IN std_logic_vector(4 downto 0);
		reg_d_in : IN std_logic_vector(4 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;
		reg_en : IN std_logic;          
		WB_reg_write_out : OUT std_logic;
		WB_mem_to_reg_out : OUT std_logic;
		MEM_we_out : OUT std_logic;
		MEM_re_out : OUT std_logic;
		EX_reg_dst_out : OUT std_logic;
		EX_ALU_op_out : OUT std_logic_vector(1 downto 0);
		EX_ALU_src_out : OUT std_logic;
		reg_data1_out : OUT std_logic_vector(31 downto 0);
		reg_data2_out : OUT std_logic_vector(31 downto 0);
		sign_extended_out : OUT std_logic_vector(31 downto 0);
		reg_s_out : OUT std_logic_vector(4 downto 0);
		reg_t_out : OUT std_logic_vector(4 downto 0);
		reg_d_out : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;
	
	COMPONENT IF_ID
	PORT(
		pc_in : IN std_logic_vector(31 downto 0);
		instruction_in : IN std_logic_vector(31 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;
		flush : IN std_logic;
		reg_en : IN std_logic;          
		pc_out : OUT std_logic_vector(31 downto 0);
		instruction_out : OUT std_logic_vector(31 downto 0)
		);
	END COMPONENT;
	
	COMPONENT MEM_WB
	PORT(
		WB_reg_write_in : IN std_logic;
		WB_mem_to_reg_in : IN std_logic;
		mem_data_in : IN std_logic_vector(31 downto 0);
		ALU_res_in : IN std_logic_vector(31 downto 0);
		reg_dest_in : IN std_logic_vector(4 downto 0);
		clk : IN std_logic;
		rst : IN std_logic;
		reg_en : IN std_logic;          
		WB_reg_write_out : OUT std_logic;
		WB_mem_to_reg_out : OUT std_logic;
		mem_data_out : OUT std_logic_vector(31 downto 0);
		ALU_res_out : OUT std_logic_vector(31 downto 0);
		reg_dest_out : OUT std_logic_vector(4 downto 0)
		);
	END COMPONENT;
	
	COMPONENT compare
	PORT(
		reg_in_1 : IN std_logic_vector(31 downto 0);
		reg_in_2 : IN std_logic_vector(31 downto 0);         
		compare_out : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT control_unit
	PORT(
		instruction : IN std_logic_vector(31 downto 0);
		equals : IN std_logic;          
		reg_dest : OUT std_logic;
		ALU_op : OUT std_logic_vector(1 downto 0);
		ALU_src : OUT std_logic;
		mem_we : OUT std_logic;
		mem_re : OUT std_logic;
		reg_we : OUT std_logic;
		mem_to_reg : OUT std_logic;
		jump : OUT std_logic;
		branch : OUT std_logic;
		flush : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT forwarding_unit
	PORT(
		EX_reg_s : IN std_logic_vector(4 downto 0);
		EX_reg_t : IN std_logic_vector(4 downto 0);
		ID_reg_s : IN std_logic_vector(4 downto 0);
		ID_reg_t : IN std_logic_vector(4 downto 0);
		MEM_destination : IN std_logic_vector(4 downto 0);
		WB_destination : IN std_logic_vector(4 downto 0);
		EX_MEM_regwrite : IN std_logic;
		WB_regwrite : IN std_logic;          
		ForwardA : OUT std_logic_vector(1 downto 0);
		ForwardB : OUT std_logic_vector(1 downto 0);
		ForwardC : OUT std_logic_vector(1 downto 0);
		ForwardD : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT hazard_detection_unit
	PORT(
		ID_instruction : IN std_logic_vector(9 downto 0);
		ID_EX_reg_t : IN std_logic_vector(4 downto 0);
		ID_EX_memread : IN std_logic;          
		to_nop_mux : OUT std_logic;
		pc_we : OUT std_logic
		);
	END COMPONENT;
	
	
	signal IF_PC_add				: std_logic_vector(31 downto 0);
	signal ID_branch_res			: std_logic_vector(31 downto 0);
	signal branch					: std_logic;
	signal equals					: std_logic;
	signal IF_PC_address			: std_logic_vector(31 downto 0);
	
	signal ID_jump_address		: std_logic_vector(31 downto 0);
	signal IF_PC_new				: std_logic_vector(31 downto 0);
	signal jump						: std_logic;
	
	signal PC_we					: std_logic;
	signal IF_PC					: std_logic_vector(31 downto 0);
	signal add_increment_one	: std_logic_Vector(31 downto 0);
	
	signal flush					: std_logic;
	
	signal ID_jump					: std_logic_vector(25 downto 0);
	signal ID_PC_significant 	: std_logic_vector(5 downto 0);
	signal ID_instruction		: std_logic_vector(31 downto 0);
	signal ID_PC					: std_logic_vector(31 downto 0);
	
	signal ID_reg_s_reg_t		: std_logic_vector(9 downto 0);
	signal ID_reg_s				: std_logic_vector(4 downto 0);
	signal ID_reg_t				: std_logic_vector(4 downto 0);
	signal ID_reg_d				: std_logic_vector(4 downto 0);
	signal ID_r_data1				: std_logic_vector(31 downto 0);
	signal ID_r_data2				: std_logic_vector(31 downto 0);
	signal ID_operand1			: std_logic_vector(31 downto 0);
	signal ID_operand2			: std_logic_vector(31 downto 0);
	
	signal ID_immediate			: std_logic_vector(15 downto 0);
	signal ID_sign_extended		: std_logic_vector(31 downto 0);
	
	signal stall					: std_logic;
	signal control_signals		: std_logic_vector(7 downto 0);
	signal ID_nop_control		: std_logic_vector(7 downto 0);
	signal ID_nop_zero			: std_logic_vector(7 downto 0);
	signal WB_reg_write			: std_logic;
		
	signal ID_reg_dest 			: std_logic;
	signal ID_ALU_op				: std_logic_vector(1 downto 0);
	signal ID_ALU_src				: std_logic;
	signal ID_mem_we				: std_logic;
	signal ID_mem_re				: std_logic;
	signal sig_ID_reg_we 		: std_logic;
	signal ID_mem_to_reg 		: std_logic;
	
	signal reg_dest 				: std_logic;
	signal sig_ALU_op				: std_logic_vector(1 downto 0);
	signal ALU_src					: std_logic;
	
	signal EX_reg_we				: std_logic;
	signal EX_mem_to_reg			: std_logic;
	signal EX_mem_we				: std_logic;
	signal EX_mem_re				: std_logic;
	
	signal EX_r_data1				: std_logic_vector(31 downto 0);
	signal EX_r_data2				: std_logic_vector(31 downto 0);
	signal EX_sign_extended		: std_logic_vector(31 downto 0);
	signal EX_op					: std_logic_vector(5 downto 0);
	signal ALU_control			: std_logic_vector(3 downto 0);
	signal EX_ALU_operand1		: std_logic_vector(31 downto 0);
	signal EX_ALU_operand2		: std_logic_vector(31 downto 0);
	signal EX_ALU_result			: std_logic_vector(31 downto 0);
	signal EX_forward_value_D	: std_logic_vector(31 downto 0);
	signal forwardA				: std_logic_vector(1 downto 0); 
	signal forwardB				: std_logic_vector(1 downto 0);
	signal forwardC				: std_logic_vector(1 downto 0);
	signal forwardD				: std_logic_vector(1 downto 0);
	signal EX_reg_s				: std_logic_vector(4 downto 0);
	signal EX_reg_t				: std_logic_vector(4 downto 0);
	signal EX_reg_d				: std_logic_vector(4 downto 0);
	signal EX_destination 		: std_logic_vector(4 downto 0);
	signal MEM_reg_we				: std_logic;
	signal MEM_ALU_res			: std_logic_vector(31 downto 0);
	signal MEM_destination		: std_logic_vector(4 downto 0);
	signal MEM_mem_to_reg		: std_logic;
	signal WB_read_data			: std_logic_vector(31 downto 0);
	signal WB_ALU_res				: std_logic_vector(31 downto 0);
	signal mem_to_reg				: std_logic;
	signal WB_destination		: std_logic_vector(4 downto 0);
	signal WB_data					: std_logic_vector(31 downto 0);
	
	signal old_stall				: std_logic := '0';
	signal ID_stalled_instr		: std_logic_vector(31 downto 0);
	signal old_flush				: std_logic := '0';
	signal imem_mux_ctrl			: std_logic := '0';


begin

	bypass_stall : process(clk)
	begin
		if rising_edge(clk) then
			if stall = '1' then
				old_stall <= '1';
			elsif old_stall = '1' then
				old_stall <= '0';
			end if;
		end if;
	end process bypass_stall;
	
	
	
	bypass_flush : process(clk)
	begin
		if rising_edge(clk) then
			if flush = '1' then
				old_flush <= '1';
			elsif old_flush = '1' then
				old_flush <= '0';
			end if;
		end if;
	end process bypass_flush;
	
	imem_mux_ctrl <= old_stall or old_flush;

	ID_reg_s_reg_t <= ID_instruction(25 downto 16); -- register addresses for hazard detector
	ID_PC_significant <= ID_PC(31 downto 26); -- top bites from PC for jump
	ID_jump <= ID_instruction(25 downto 0); -- immediate value for jump
	--PC_mux_control <= branch and equals; -- for branch control mux
	add_increment_one <= x"00000001"; -- increment value for PC
	ID_reg_s <= ID_instruction(25 downto 21); -- register $s
	ID_reg_t <= ID_instruction(20 downto 16); -- register $t
	ID_reg_d <= ID_instruction(15 downto 11); -- register $d
	ID_immediate <= ID_instruction(15 downto 0); -- immediate part of the instruction
	ID_nop_zero <= (others => '0'); -- values of NOP control signals
	
	ID_reg_dest <= ID_nop_control(7);
	ID_ALU_op <= ID_nop_control(6 downto 5);
	ID_ALU_src <= ID_nop_control(4);
	
	ID_mem_we <= ID_nop_control(3);
	ID_mem_re <= ID_nop_control(2);
	
	sig_ID_reg_we <= ID_nop_control(1);
	ID_mem_to_reg <= ID_nop_control(0);
	
	EX_op <= EX_sign_extended(5 downto 0); -- func field of the instruction
	
	instruction_address <= IF_PC(ADDR_WIDTH - 1 downto 0); -- output instruction address
	data_address <= MEM_ALU_res(ADDR_WIDTH - 1 downto 0); -- output data mem address
	
	
	imem_mux 	: mux
					  generic map (WIDTH => 32)
					  port map(instruction_in, ID_stalled_instr, imem_mux_ctrl, ID_instruction);
	
	branch_mux 	: mux
					  generic map (WIDTH => 32)
					  port map(IF_pc_add, ID_branch_res, branch, IF_pc_address);
	pc 			: program_counter port map(IF_PC_new, clk, rst, PC_we, processorEnable, IF_pc);
	jump_mux		: mux
					  generic map (WIDTH => 32)
					  port map(IF_pc_address, ID_jump_address, jump, IF_pc_new);
	add_incr		: add port map(add_increment_one, IF_pc, IF_pc_add);
	IF_ID_reg	: IF_ID port map(IF_pc_add, instruction_in, clk, rst, flush, processorEnable, ID_PC, ID_stalled_instr);
	concat_jump	: concat port map(ID_jump, ID_PC_significant, ID_jump_address);
	regfile 		: register_file port map(ID_reg_s, ID_reg_t, WB_reg_write, rst, clk, WB_destination, WB_data, ID_r_data1, ID_r_data2); 
	signext  	: sign_extend port map(ID_immediate, ID_sign_extended);
	fwd_mux_A	: mux_3_to_1 port map(ID_r_data1, WB_data, MEM_ALU_res, forwardA, ID_operand1);
	fwd_mux_B	: mux_3_to_1 port map(ID_r_data2, WB_data, MEM_ALU_res, forwardB, ID_operand2);
	compare_data: compare port map(ID_operand1, ID_operand2, equals);
	hazard_det	: hazard_detection_unit port map(ID_reg_s_reg_t, EX_reg_t, EX_mem_re, stall, PC_we);
	add_branch	: add port map(ID_sign_extended, ID_PC, ID_branch_res);
	nop_mux 		: mux 
					  generic map(WIDTH => 8)
					  port map(control_signals, ID_nop_zero, stall, ID_nop_control);
	ID_EX_reg 	: ID_EX port map(sig_ID_reg_we, ID_mem_to_reg, ID_mem_we, ID_mem_re, ID_reg_dest, ID_ALU_op, ID_ALU_src, ID_operand1, ID_operand2, ID_sign_extended,
										  ID_reg_s, ID_reg_t, ID_reg_d, clk, rst, processorEnable, EX_reg_we, EX_mem_to_reg, EX_mem_we, EX_mem_re, reg_dest, sig_ALU_op, 
										  ALU_src, EX_r_data1, EX_r_data2, EX_sign_extended, EX_reg_s, EX_reg_t, EX_reg_d);	
	control		: control_unit port map(ID_instruction, equals, control_signals(7), control_signals(6 downto 5), control_signals(4), control_signals(3), control_signals(2), 
												   control_signals(1), control_signals(0), jump, branch, flush);
	fwd_mux_C	: mux_3_to_1 port map(EX_r_data1, WB_data, MEM_ALU_res, forwardC, EX_ALU_operand1);
	fwd_mux_D	: mux_3_to_1 port map(EX_r_data2, WB_data, MEM_ALU_res, forwardD, EX_forward_value_D);
	ALU_mux		: mux
					  generic map (WIDTH => 32)
					  port map(EX_forward_value_D, EX_sign_extended, ALU_src, EX_ALU_operand2);
	ALU_ctrl		: ALU_op port map(sig_ALU_op, EX_op, ALU_control);
	ALU_unit		: ALU port map(EX_ALU_operand1, EX_ALU_operand2, ALU_control, EX_ALU_result);
	dest_mux		: mux
					  generic map (WIDTH => 5)
					  port map(EX_reg_t, EX_reg_d, reg_dest, EX_destination);
	forward		: forwarding_unit port map(EX_reg_s, EX_reg_t, ID_reg_s, ID_reg_t, MEM_destination, WB_destination, MEM_reg_we, WB_reg_write, 
														ForwardA, ForwardB, ForwardC, ForwardD);													
	EX_MEM_reg	: EX_MEM port map(EX_reg_we, EX_mem_to_reg, EX_mem_we, EX_ALU_result, EX_forward_value_D, EX_destination, clk, rst, processorEnable,
											MEM_reg_we, MEM_mem_to_reg, mem_we, MEM_ALU_res, data_out, MEM_destination);
	MEM_WB_reg	: MEM_WB port map(MEM_reg_we, MEM_mem_to_reg, data_in, MEM_ALU_res, MEM_destination, clk, rst, processorEnable, WB_reg_write,
											mem_to_reg, WB_read_data, WB_ALU_res, WB_destination);
	data_mux		: mux
					  generic map (WIDTH => 32)
					  port map(WB_ALU_res, WB_read_data, mem_to_reg, WB_data);
	
	
end Behavioral;
