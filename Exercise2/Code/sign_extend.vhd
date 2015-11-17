----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:20:51 09/22/2015 
-- Design Name: 
-- Module Name:    sign_extend - Behavioral 
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

entity sign_extend is
	generic (
				input_width 	: positive := 16;
				output_width 	: positive := 32
				);
	port (
			signed_input 	: in std_logic_vector(input_width - 1 downto 0);
			signed_output 	: out std_logic_vector(output_width - 1 downto 0)
			);

end sign_extend;

architecture Behavioral of sign_extend is

begin

	signed_output <= std_logic_vector(resize(signed(signed_input), signed_output'length));
	 
end Behavioral;

