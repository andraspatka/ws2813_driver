----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/08/2019 08:46:17 PM
-- Design Name: 
-- Module Name: bram_01_sim - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity bram_sim is
--  Port ( );
end bram_sim;

architecture Behavioral of bram_sim is

component blk_mem_gen_0 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
end component;

signal ena : std_logic := '0';
signal addra : std_logic_VECTOR(3 downto 0) := (others => '0');
signal douta : std_logic_VECTOR(23 downto 0) := (others => '0');
signal clk : std_logic := '0';

begin

BRAM_instance: blk_mem_gen_0
  port map (
    clka => clk,
    ena => ena,
    addra => addra,
    douta => douta
  );

process
begin
    addra <= "0000";
    wait for 5 ns;
    ena <= '1';
    for i in 0 to 14 loop
        wait for 10 ns;
        addra <= addra + "1";
    end loop;
    
    wait;
end process;

clk_gen: process -- Generating a 100 MHz clock signal
begin
    clk <='1';
    wait for 5 ns;
    clk <='0';
    wait for 5 ns;     
end process clk_gen;   

end Behavioral;
