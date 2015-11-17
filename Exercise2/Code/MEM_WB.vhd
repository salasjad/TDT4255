----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:40:54 11/03/2015 
-- Design Name: 
-- Module Name:    MEM_WB - Behavioral 
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

entity MEM_WB is
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

			--DATA
			mem_data_in			: in std_logic_vector(data_width - 1 downto 0) := (others => '0');
			mem_data_out		: out std_logic_vector(data_width - 1 downto 0) := (others => '0');

			ALU_res_in			: in std_logic_vector(data_width - 1 downto 0) := (others => '0');
			ALU_res_out			: out std_logic_vector(data_width - 1 downto 0) := (others => '0');

			reg_dest_in			: in std_logic_vector(reg_address_width - 1 downto 0) := (others => '0');
			reg_dest_out		: out std_logic_vector(reg_address_width - 1 downto 0) := (others => '0');

			clk					: in std_logic := '0';
			rst 					: in std_logic := '0';
			reg_en				: in std_logic := '0'
		);
end MEM_WB;

architecture Behavioral of MEM_WB is

begin

mem_data_out <= mem_data_in;

mem_wb : process(clk)
	begin
		if rising_edge(clk) then
			if reg_en = '1' then
				--WB
				WB_reg_write_out <= WB_reg_write_in;
				WB_mem_to_reg_out <= WB_mem_to_reg_in;

				--DATA
				--mem_data_out <= mem_data_in;

				ALU_res_out <= ALU_res_in;

				reg_dest_out <= reg_dest_in;

			end if;

			if rst = '1' then
				--WB
				WB_reg_write_out <= '0';
				WB_mem_to_reg_out <= '0';

				--DATA
				--mem_data_out <= (others => '0');

				ALU_res_out <= (others => '0');

				reg_dest_out <= (others => '0');
			end if;
		end if;
	end process mem_wb;

end Behavioral;