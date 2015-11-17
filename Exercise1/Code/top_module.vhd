----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:39:13 10/06/2015 
-- Design Name: 
-- Module Name:    top_module - Behavioral 
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

entity top_module is
generic (
		ADDR_WIDTH : integer := 32;
		DATA_WIDTH : integer := 32
	);
	port (
		clk		 				: in std_logic;
		rst						: in std_logic := '0';
		processor_enable		: in std_logic := '0';
		imem_data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		imem_address			: out std_logic_vector(ADDR_WIDTH-1 downto 0);
		dmem_data_in			: in std_logic_vector(DATA_WIDTH-1 downto 0);
		dmem_address			: out std_logic_vector(ADDR_WIDTH-1 downto 0);
		dmem_data_out			: out std_logic_vector(DATA_WIDTH-1 downto 0);
		dmem_write_enable		: out std_logic
	);
end top_module;

architecture Behavioral of top_module is
	COMPONENT datapath
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		branch : IN std_logic;
		jump : IN std_logic;
		pc_we : IN std_logic;
		ir_we : IN std_logic;
		reg_we : IN std_logic;
		alu_src : IN std_logic;
		alu_op_ctrl : IN std_logic_vector(1 downto 0);
		mem_to_reg : IN std_logic;
		reg_dst : IN std_logic;
		reg_op_we : IN std_logic;
		instruction_in : IN std_logic_vector(31 downto 0);
		data_memory_in1 : IN std_logic_vector(31 downto 0);          
		instruction_address : OUT std_logic_vector(31 downto 0);
		data_memory_address : OUT std_logic_vector(31 downto 0);
		data_memory_data : OUT std_logic_vector(31 downto 0);
		opcode : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;

	COMPONENT control_unit
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		processorEnable : IN std_logic;
		instruction_in : IN std_logic_vector(31 downto 26);          
		branch : OUT std_logic;
		pc_we : OUT std_logic;
		ir_we : OUT std_logic;
		reg_dst : OUT std_logic;
		reg_we : OUT std_logic;
		alu_src : OUT std_logic;
		alu_op : OUT std_logic_vector(1 downto 0);
		jump : OUT std_logic;
		mem_we : OUT std_logic;
		mem_to_reg : OUT std_logic;
		reg_op_we : OUT std_logic
		);
	END COMPONENT;
	
		signal branch : std_logic;
		signal pc_we : std_logic;
		signal ir_we : std_logic;
		signal reg_dst : std_logic;
		signal reg_we : std_logic;
		signal alu_src : std_logic;
		signal alu_op : std_logic_vector(1 downto 0);
		signal jump : std_logic;
		signal mem_we : std_logic;
		signal mem_to_reg : std_logic;
		signal top_reg_dst : std_logic;
		signal instruction_in : std_logic_vector(31 downto 26);
		signal opcode : std_logic_vector(5 downto 0);
		signal reg_op_we : std_logic;
		
		signal t_imem_address : std_logic_vector(31 downto 0);
		signal t_dmem_address : std_logic_vector(31 downto 0);
		
begin

imem_address <= t_imem_address(ADDR_WIDTH-1 downto 0);
dmem_address <= t_dmem_address(ADDR_WIDTH-1 downto 0);

dmem_write_enable <= mem_we;

top1 : datapath port map(
		clk => clk,
		rst => rst,
		branch => branch,
		jump => jump,
		pc_we => pc_we,
		ir_we => ir_we,
		reg_we => reg_we,
		alu_src => alu_src,
		alu_op_ctrl => alu_op,
		mem_to_reg => mem_to_reg,
		reg_dst => top_reg_dst,
		reg_op_we => reg_op_we,
		instruction_in => imem_data_in,
		instruction_address => t_imem_address,
		data_memory_address => t_dmem_address,
		data_memory_data => dmem_data_out,
		data_memory_in1 => dmem_data_in,
		opcode => opcode
);

top2: control_unit PORT MAP(
		clk => clk, 
		rst => rst,
		processorEnable => processor_enable,
		instruction_in => opcode,
		branch => branch,
		pc_we => pc_we,
		ir_we => ir_we,
		reg_dst => top_reg_dst,
		reg_we => reg_we,
		alu_src => alu_src,
		alu_op => alu_op,
		jump => jump,
		mem_we => mem_we,
		mem_to_reg => mem_to_reg,
		reg_op_we => reg_op_we
	);
end Behavioral;

