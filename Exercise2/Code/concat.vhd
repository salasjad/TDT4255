----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:06:47 09/22/2015 
-- Design Name: 
-- Module Name:    concat - Behavioral 
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

entity concat is
	generic (
				instruction_width : positive := 26;
				pc_width : positive := 6
				);
	port (
			instruction_in : in std_logic_vector(instruction_width - 1 downto 0);
			pc_in				: in std_logic_vector(pc_width - 1 downto 0);
			concat_out		: out std_logic_vector((instruction_width + pc_width - 1) downto 0)
			);

end concat;

architecture Behavioral of concat is

begin
	-- pure concatenation
	concat_out <= pc_in & instruction_in;

end Behavioral;

