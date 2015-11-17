library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.defs.all;

entity stack is
  
  generic (
    size : natural := 10);            -- Maximum number of operands on stack

  port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    value_in  : in  operand_t;
    push      : in  std_logic;
    pop       : in  std_logic;
    top       : out operand_t);

end entity stack;

architecture behavioural of stack is

	type shift_register is array (0 to size - 1) of operand_t;
	signal my_shift_register : shift_register;
	signal count : unsigned(9 downto 0) := "0000000000"; --default is set to 0's
	signal control : std_logic_vector(1 downto 0);
	signal count_zero : boolean := true;

begin  -- architecture behavioural
	
	-- Control just concatenates push and pop signals
	control <= push & pop;
	
	-- shr process implements shift register
	shr : process(clk)
	begin
		if rising_edge(clk) then
			if control = "01" then -- in case of pop
				my_shift_register <= "00000000" & my_shift_register(0 to size - 2);
			elsif control = "10" then -- case of push
				my_shift_register <= my_shift_register(1 to size - 1) & value_in;
			end if;
		end if;
	end process shr;
	
	-- mux_zero implements multiplexer that controls the output of the stack
	mux_zero : process(count_zero, my_shift_register(size - 1))
	begin
		if count_zero = false then -- in case the number of values on the stack is 0
			top <= my_shift_register(size - 1);
		else
		top <= "00000000";
		end if;
	end process mux_zero;
	
	-- logic that controls the counter
	counter_logic : process(clk)
	begin
		if rising_edge(clk) then
			if rst = '1' then -- set value to 0 after reset
				count <= "0000000000";
			elsif push = '1' then -- in case of push increment the cnt
				count <= count + 1;
			elsif pop = '1' then -- in case of pop
				if not count_zero then -- when the cnt is not 0
					count <= count - 1;
				end if; 
			end if;
		end if;
	end process counter_logic;
	
	-- process controlling value of count_zero flag
	cnt_zero : process(count)
	begin
		if count = "0000000000" then
			count_zero <= true;
		else
			count_zero <= false;
		end if;
	end process cnt_zero;

end architecture behavioural;
