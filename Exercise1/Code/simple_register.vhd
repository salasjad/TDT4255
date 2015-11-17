----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:10:06 09/29/2015 
-- Design Name: 
-- Module Name:    simple_register - Behavioral 
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

entity simple_register is
	generic(	
				width : integer := 32
			);
			
	port(
			data_in 		: in std_logic_vector(width - 1 downto 0) := (others => '0');
			data_out 	: out std_logic_vector(width - 1 downto 0) := (others => '0');
			clk			: in std_logic := '0';
			rst 			: in std_logic := '0';
			wr_en			: in std_logic := '0'
		);
end simple_register;

architecture Behavioral of simple_register is

begin
 reg : process (clk)
 begin
 
	if rising_edge(clk) then		
		if rst = '1' then
			data_out <= (others => '0');
		elsif wr_en = '1' then
			data_out <= data_in;
		end if;
	end if;
	
 end process reg;

end Behavioral;

