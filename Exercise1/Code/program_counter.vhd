----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:25:23 09/22/2015 
-- Design Name: 
-- Module Name:    program_counter - Behavioral 
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

entity program_counter is
	generic(	
				width : integer := 32
			);
			
			
	port(
			pc_in 	: in std_logic_vector(width - 1 downto 0) := (others => '0');
			pc_out 	: out std_logic_vector(width - 1 downto 0) := (others => '0');
			clk		: in std_logic := '0';
			rst 		: in std_logic := '0';
			wr_en		: in std_logic := '0';
			reg_en	: in std_logic := '0'
		);
end program_counter;

architecture Behavioral of program_counter is

begin
 pc : process (clk)
 begin
	if rising_edge(clk) then
		if reg_en = '1' and wr_en = '1' then
			pc_out <= pc_in;
		end if;
		if rst = '1' then
			pc_out <= (others => '0');
		end if;
	end if;
	
 end process pc;

end Behavioral;

