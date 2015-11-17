library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity control is
  
  port (
    clk : in std_logic;
    rst : in std_logic;

    -- Communication
    instruction : in  instruction_t;
    empty       : in  std_logic;
    read        : out std_logic;

    -- Stack control
    push      : out std_logic;
    pop       : out std_logic;
    stack_src : out stack_input_select_t;
    operand   : out operand_t;

    -- ALU control
    a_wen   : out std_logic;
    b_wen   : out std_logic;
    alu_sel : out alu_operation_t);


end entity control;

architecture behavioural of control is

type state_t is (STATE_IDLE, STATE_FETCH, STATE_DECODE, STATE_POP_B, STATE_POP_A, STATE_PUSH_OPERAND, 
		STATE_COMPUTE, STATE_PUSH_RESULT);
signal state, next_state : state_t;
signal sig_opcode : std_logic_vector(7 downto 0);

begin  -- architecture behavioural

--Sequentiual process
process(clk) --the sensitivity list
 begin
	if(rising_edge(clk)) then
		if rst = '1' then
			state <= STATE_IDLE; --go back to first state in FSM
		else
			state <= next_state; --go to next state in FSM
		end if;
	end if;
end process;

sig_opcode <= instruction(15 downto 8); --separate opcode from instruction
operand <= instruction(7 downto 0); --declare operand from the instruction

--Combinational process
process(state, sig_opcode, empty) --the sensitivity list
begin
case(state) is --case start for the FSM

when STATE_IDLE =>
	if(empty = '1') then
		next_state <= STATE_IDLE; 
	else
		next_state <= STATE_FETCH;
	end if;
	
when STATE_FETCH =>
	next_state <= STATE_DECODE;
	
when STATE_DECODE =>
	if(sig_opcode = "00000000") then --push operation
		next_state <= STATE_PUSH_OPERAND;
	else
		next_state <= STATE_POP_B;
	end if;
	
when STATE_PUSH_OPERAND =>
	next_state <= STATE_IDLE;
	
when STATE_POP_B =>
	next_state <= STATE_POP_A;
	
when STATE_POP_A =>
	next_state <= STATE_COMPUTE;
	
when STATE_COMPUTE =>
	next_state <= STATE_PUSH_RESULT;
	
when STATE_PUSH_RESULT =>
	next_state <= STATE_IDLE;
	
when others =>
	next_state <= STATE_IDLE;
end case;

end process;

process(state, sig_opcode, empty)
begin
case(state) is

when STATE_IDLE =>
		read <= '0';
		b_wen <= '0';
		a_wen <= '0';
		pop <= '0';
		push <= '0';
		alu_sel <= ALU_ADD;
		stack_src <= STACK_INPUT_OPERAND;
		
when STATE_FETCH =>
		read <= '1';
		b_wen <= '0';
		a_wen <= '0';
		pop <= '0';
		push <= '0';
		alu_sel <= ALU_ADD;
		stack_src <= STACK_INPUT_OPERAND;
		
when STATE_DECODE =>
		read <= '0';
		b_wen <= '0';
		a_wen <= '0';
		pop <= '0';
		push <= '0';
		alu_sel <= ALU_ADD;
		stack_src <= STACK_INPUT_OPERAND;
		
when STATE_PUSH_OPERAND =>
		read <= '0';
		b_wen <= '0';
		a_wen <= '0';
		pop <= '0';
		push <= '1';
		alu_sel <= ALU_ADD;
		stack_src <= STACK_INPUT_OPERAND;
		
when STATE_POP_B =>
		read <= '0';
		b_wen <= '1';
		a_wen <= '0';
		pop <= '1';
		push <= '0';
		alu_sel <= ALU_ADD;
		stack_src <= STACK_INPUT_OPERAND;
		
when STATE_POP_A =>
		read <= '0';
		b_wen <= '0';
		a_wen <= '1';
		pop <= '1';
		push <= '0';
		alu_sel <= ALU_ADD;
		stack_src <= STACK_INPUT_OPERAND;
		
when STATE_COMPUTE =>
		read <= '0';
		b_wen <= '0';
		a_wen <= '0';
		pop <= '0';
		push <= '0';
		
		if(sig_opcode = "00000001") then
			alu_sel <= ALU_ADD;
		else 
			alu_sel <= ALU_SUB;
		end if;
		stack_src <= STACK_INPUT_OPERAND;
		
when STATE_PUSH_RESULT =>
		read <= '0';
		b_wen <= '0';
		a_wen <= '1';
		pop <= '0';
		push <= '1';
		if(sig_opcode = "00000001") then
			alu_sel <= ALU_ADD;
		else 
			alu_sel <= ALU_SUB;
		end if;
		stack_src <= STACK_INPUT_RESULT;
end case;
end process;
end architecture behavioural;
