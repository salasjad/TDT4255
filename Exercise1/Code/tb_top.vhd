--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   09:55:00 10/13/2015
-- Design Name:   
-- Module Name:   /home/shomea/m/michalma/multicycle_processor/tb_top.vhd
-- Project Name:  multicycle_processor
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: top_module
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use work.testutil.all;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY tb_top IS
END tb_top;
 
ARCHITECTURE behavior OF tb_top IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT top_module
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         processor_enable : IN  std_logic;
         imem_data_in : IN  std_logic_vector(31 downto 0);
         imem_address : OUT  std_logic_vector(31 downto 0);
         dmem_data_in : IN  std_logic_vector(31 downto 0);
         dmem_address : OUT  std_logic_vector(31 downto 0);
         dmem_data_out : OUT  std_logic_vector(31 downto 0);
         dmem_write_enable : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal processor_enable : std_logic := '0';
   signal imem_data_in : std_logic_vector(31 downto 0) := (others => '0');
   signal dmem_data_in : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal imem_address : std_logic_vector(31 downto 0);
   signal dmem_address : std_logic_vector(31 downto 0);
   signal dmem_data_out : std_logic_vector(31 downto 0);
   signal dmem_write_enable : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: top_module PORT MAP (
          clk => clk,
          rst => rst,
          processor_enable => processor_enable,
          imem_data_in => imem_data_in,
          imem_address => imem_address,
          dmem_data_in => dmem_data_in,
          dmem_address => dmem_address,
          dmem_data_out => dmem_data_out,
          dmem_write_enable => dmem_write_enable
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 10 ns;	
		rst <= '0';
		
		processor_enable <= '0';
		
      wait for clk_period;
		
		processor_enable <= '1';
		
		wait on imem_address;
		
		--lw $1, 0x2
		imem_data_in <= X"8C010001";
		dmem_data_in <= X"0000D0F2";
		
		wait on imem_address;
		
		--lw $2, 0x100A
		imem_data_in <= X"8C020002";
		dmem_data_in <= X"0000100A";
		
		wait on imem_address;
		--lw $3, 0xFFFFF
		imem_data_in <= X"8C030003";
		dmem_data_in <= X"000FFFFF";
		
		wait on imem_address;
				
		--and $4, $2, $3
		imem_data_in <= X"00432024"; -- AND
		
		wait on imem_address;
		
		--or $5, $1, $2
		imem_data_in <= X"00222825"; -- OR
		wait on imem_address;
		
		--add $6 $2 $3
		imem_data_in <= X"00433020";--ADD
		
		wait on imem_address;
		
		--slt $7 $1 $3
		imem_data_in <= X"0023402A";--SLT
		
		wait on imem_address;
		
		--slt $8 $3 $1
		imem_data_in <= X"0051382A";--SLT
		
		wait on imem_address;
		
		--sub $9 $1 $3
		imem_data_in <= X"00234822";--SUB
		
		wait on imem_address;
		
		--nor $10 $1 $2
		imem_data_in <= X"00225027";--NOR
		
		wait on imem_address;
		
		--lui $13 2
		imem_data_in <= X"3C0D00F2";--LUI
		wait on imem_address;
		
		
		--j 3F3210
		imem_data_in <= X"083F3210";--JUMP
		
		wait on imem_address;
		
		check(imem_address = X"003F3210", "Wrong pc value");
		report "Test JUMP passed" severity note;
		
		--beq $0 $0 5
		imem_data_in <= X"10000005";--BEQ
		
		wait on imem_address;
		wait on imem_address;
		
		check(imem_address = X"003F3216", "Wrong pc value");
		report "Test BEQ TAKE passed" severity note;
		
		--beq $1 $0 5 (no branch)
		imem_data_in <= X"10200005";--BEQ
		
		wait on imem_address;
		check(imem_address = X"003F3217", "Wrong pc value");
		report "Test BEQ NOT TAKE passed" severity note;
		
		wait on imem_address;
		
		--sw $1, 1($0)
		imem_data_in <= X"AC010001";--SW
		
		wait on imem_address;
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"0000D0F2", "Load error");
      report "Test LW passed" severity note;
		check(dmem_address = X"00000001", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $2, 2($0)
		imem_data_in <= X"AC020002";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"0000100A", "Load error");
      report "Test LW passed" severity note;
		check(dmem_address = X"00000002", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $3, 3($0)
		imem_data_in <= X"AC030003";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"000FFFFF", "Load error");
      report "Test LW passed" severity note;
		check(dmem_address = X"00000003", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $4, 4($0)
		imem_data_in <= X"AC040004";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"0000100A", "AND error");
      report "Test AND passed" severity note;
		check(dmem_address = X"00000004", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $5, 5($0)
		imem_data_in <= X"AC050005";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"0000D0FA", "OR error");
      report "Test OR passed" severity note;
		check(dmem_address = X"00000005", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $6, 6($0)
		imem_data_in <= X"AC060006";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"00101009", "ADD error");
      report "Test ADD passed" severity note;
		check(dmem_address = X"00000006", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $7, 7($0)
		imem_data_in <= X"AC070007";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"00000000", "SLT error");
      report "Test SLT passed" severity note;
		check(dmem_address = X"00000007", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $8, 8($0)
		imem_data_in <= X"AC080008";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"00000001", "SLT error");
      report "Test SLT passed" severity note;
		check(dmem_address = X"00000008", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $9, 9($0)
		imem_data_in <= X"AC090009";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"FFF0D0F3", "SUB error");
      report "Test SUB passed" severity note;
		check(dmem_address = X"00000009", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;
		
		--sw $10, 10($0)
		imem_data_in <= X"AC0A000A";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"FFFF2F05", "NOR error");
      report "Test NOR passed" severity note;
		check(dmem_address = X"0000000A", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;

		--sw $13, 13($0)
		imem_data_in <= X"AC0D000D";--SW
		
		wait on dmem_write_enable;
		check(dmem_data_out = X"00F20000", "LUI error");
      report "Test LUI passed" severity note;
		check(dmem_address = X"0000000D", "Wrong adress");
		report "Test SW passed" severity note;
		wait on imem_address;

		
		wait on imem_address;
		
		assert false report "TEST SUCCESS" severity failure;
      wait;
   end process;

END;
