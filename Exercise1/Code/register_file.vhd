----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:42:42 09/22/2015 
-- Design Name: 
-- Module Name:    register_file - Behavioral 
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

entity register_file is
	generic(
		address_width : positive := 5;
		data_width : positive := 32
	);
	port(
		r_reg1 	: in std_logic_vector(address_width -1 downto 0) := (others => '0');
		r_reg2 	: in std_logic_vector(address_width - 1 downto 0) := (others => '0');
		RegWrite : in std_logic :='0';
		rst 		: in std_logic :='0';
		clk 		: in std_logic :='0';
		w_reg		: in std_logic_vector(address_width - 1 downto 0) := (others => '0'); 
		w_data 	: in std_logic_vector(data_width - 1 downto 0) := (others => '0');
		r_data1 	: out std_logic_vector(data_width - 1 downto 0) := (others => '0');
		r_data2 	: out std_logic_vector(data_width - 1 downto 0) := (others => '0')
	);
end register_file;

architecture Behavioral of register_file is
-- Registe file type consisting of 32x32 bit registers
type registerFile is array(0 to 2**address_width) of std_logic_vector(data_width-1 downto 0);
signal reg_file : registerFile := (others => (others => '0'));

begin
process(clk)
	begin
	
	if(rising_edge(clk)) then
	
		--Addresing the file
		r_data1 <= reg_file(to_integer(unsigned(r_reg1)));
		r_data2 <= reg_file(to_integer(unsigned(r_reg2)));
		
		--Reseting
		if(rst = '1') then
			r_data1 <= (others => '0');
			r_data2 <= (others => '0');
			reg_file <= (others => (others => '0'));
		
		--Write enable
		elsif(RegWrite = '1') then
			if w_reg /= "00000" then
				reg_file(to_integer(unsigned(w_reg))) <= w_data;
			else 
				reg_file(0) <= X"00000000";
			end if;
		end if;
	end if;
	
end process;
end Behavioral;

