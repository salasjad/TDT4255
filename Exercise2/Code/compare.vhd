----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:43:52 11/04/2015 
-- Design Name: 
-- Module Name:    compare - Behavioral 
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

entity compare is
	generic(
			width : integer := 32
		);
	port(

		reg_in_1	: in std_logic_vector(width - 1 downto 0) := (others => '0');
		reg_in_2	: in std_logic_vector(width - 1 downto 0) := (others => '0');
		compare_out : out std_logic := '0'
		);
end compare;

architecture Behavioral of compare is

begin
process(reg_in_1, reg_in_2)
	begin
	
	if reg_in_1 = reg_in_2 then
		compare_out <= '1';
	else
		compare_out <= '0';
	end if;
	
end process;
end Behavioral;

