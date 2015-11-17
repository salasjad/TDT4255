----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    10:06:55 11/04/2015 
-- Design Name: 
-- Module Name:    mux_3_to_1 - Behavioral 
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

entity mux_3_to_1 is
generic(
			width : positive := 32
			);
port(
	in1 : in std_logic_vector(width - 1 downto 0);
	in2 : in std_logic_vector(width - 1 downto 0);
	in3 : in std_logic_vector(width - 1 downto 0);
	forward : in std_logic_vector(1 downto 0);
	output : out std_logic_vector(width - 1 downto 0)
);
end mux_3_to_1;

architecture Behavioral of mux_3_to_1 is

begin
	process(in1, in2, in3, forward)
	begin
		case forward is
			when "00" => output <= in1;
			when "01" => output <= in2;
			when "10" => output <= in3;
			when others => output <= in1;
		end case;
	end process;

end Behavioral;
