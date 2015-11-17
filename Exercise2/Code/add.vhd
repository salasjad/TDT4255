----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:05:20 09/22/2015 
-- Design Name: 
-- Module Name:    add - Behavioral 
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

entity add is
	generic(	
				WIDTH : integer := 32
			);
			
			
	port(
			add_in1 	: in std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
			add_in2 	: in std_logic_vector(WIDTH - 1 downto 0) := (others => '0');
			add_out 	: out std_logic_vector(WIDTH - 1 downto 0) := (others => '0')
		);
end add;

architecture Behavioral of add is
	signal add_in1_signed : signed(WIDTH - 1 downto 0) := (others => '0');
	signal add_in2_signed : signed(WIDTH - 1 downto 0) := (others => '0');
	signal add_out_signed : signed(WIDTH - 1 downto 0) := (others => '0');
begin
		-- Conversion needed
		add_in1_signed <= signed(add_in1);
		add_in2_signed <= signed(add_in2);
		add_out_signed <= add_in1_signed + add_in2_signed;
		add_out <= std_logic_vector(add_out_signed);

end Behavioral;

