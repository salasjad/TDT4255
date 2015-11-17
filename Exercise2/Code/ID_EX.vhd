----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:46:11 11/03/2015 
-- Design Name: 
-- Module Name:    ID_EX - Behavioral 
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

entity ID_EX is
generic	(	
				data_width : integer := 32;
				reg_address_width : integer := 5
			);
	
	port(
			--WB
			WB_reg_write_in		: in std_logic := '0';
			WB_mem_to_reg_in	: in std_logic := '0';
			WB_reg_write_out	: out std_logic := '0';
			WB_mem_to_reg_out	: out std_logic := '0';
			
			--MEM
			MEM_we_in			: in std_logic := '0';
			MEM_re_in			: in std_logic := '0';
			MEM_we_out			: out std_logic := '0';
			MEM_re_out			: out std_logic := '0';

			--EX
			EX_reg_dst_in		: in std_logic := '0';
			EX_ALU_op_in		: in std_logic_vector(1 downto 0) := "00";
			EX_ALU_src_in		: in std_logic := '0';
			EX_reg_dst_out		: out std_logic := '0';
			EX_ALU_op_out		: out std_logic_vector(1 downto 0) := "00";
			EX_ALU_src_out		: out std_logic := '0';	

			--DATA
			reg_data1_in		: in std_logic_vector(data_width - 1 downto 0) := (others => '0');
			reg_data2_in		: in std_logic_vector(data_width - 1 downto 0) := (others => '0');
			reg_data1_out		: out std_logic_vector(data_width - 1 downto 0) := (others => '0');
			reg_data2_out		: out std_logic_vector(data_width - 1 downto 0) := (others => '0');

			sign_extended_in	: in std_logic_vector(data_width - 1 downto 0) := (others => '0');
			sign_extended_out	: out std_logic_vector(data_width - 1 downto 0) := (others => '0');

			reg_s_in			: in std_logic_vector(reg_address_width - 1 downto 0) := (others => '0');
			reg_s_out			: out std_logic_vector(reg_address_width - 1 downto 0) := (others => '0');

			reg_t_in			: in std_logic_vector(reg_address_width - 1 downto 0) := (others => '0');
			reg_t_out			: out std_logic_vector(reg_address_width - 1 downto 0) := (others => '0');

			reg_d_in			: in std_logic_vector(reg_address_width - 1 downto 0) := (others => '0');
			reg_d_out			: out std_logic_vector(reg_address_width - 1 downto 0) := (others => '0');

			clk					: in std_logic := '0';
			rst 					: in std_logic := '0';
			reg_en				: in std_logic := '0'
		);
end ID_EX;

architecture Behavioral of ID_EX is

begin
id_ex : process(clk)
	begin
		if rising_edge(clk) then
			if reg_en = '1' then
				--WB
				WB_reg_write_out <= WB_reg_write_in;
				WB_mem_to_reg_out <= WB_mem_to_reg_in;
			
				--MEM
				MEM_we_out <= MEM_we_in;
				MEM_re_out <= MEM_re_in;

				--EX
				EX_reg_dst_out <= EX_reg_dst_in;
				EX_ALU_op_out <= EX_ALU_op_in;
				EX_ALU_src_out <= EX_ALU_src_in;

				--DATA
				reg_data1_out <= reg_data1_in;
				reg_data2_out <= reg_data2_in;

				sign_extended_out <= sign_extended_in;

				reg_s_out <= reg_s_in;

				reg_t_out <= reg_t_in;

				reg_d_out <= reg_d_in;

			end if;

			if rst = '1' then
				--WB
				WB_reg_write_out <= '0';
				WB_mem_to_reg_out <= '0';
			
				--MEM
				MEM_we_out <= '0';
				MEM_re_out <= '0';

				--EX
				EX_reg_dst_out <= '0';
				EX_ALU_op_out <= (others => '0');
				EX_ALU_src_out<= '0';

				--DATA
				reg_data1_out <= (others => '0');
				reg_data2_out <= (others => '0');

				sign_extended_out <= (others => '0');

				reg_s_out <= (others => '0');

				reg_t_out <= (others => '0');

				reg_d_out <= (others => '0');
			end if;
		end if;
	end process id_ex;
end Behavioral;