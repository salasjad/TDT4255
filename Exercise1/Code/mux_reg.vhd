----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:08:55 10/06/2015 
-- Design Name: 
-- Module Name:    mux_reg - Behavioral 
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

entity mux_reg is
	generic (
				width : positive := 5
			);
	port (
			mux_in1 		: in std_logic_vector(width - 1 downto 0) := (others => '0');
			mux_in2 		: in std_logic_vector(width - 1 downto 0) := (others => '0');
			mux_out 		: out std_logic_vector(width - 1 downto 0) := (others => '0');
			src_select	: in std_logic := '0'
		);
end mux_reg;

architecture Behavioral of mux_reg is

begin

	mux_out <= 	mux_in1 when src_select = '0' else
					mux_in2 when src_select = '1';
			
end Behavioral;


