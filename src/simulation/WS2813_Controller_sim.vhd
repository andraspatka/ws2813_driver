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

entity WS2813_Controller_sim is
--  Port ( );
end WS2813_Controller_sim;

architecture Behavioral of WS2813_Controller_sim is

component blk_mem_gen_0 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
end component;

component WS2813_Controller is
    port (
        clk_100 : in std_logic; --100MHz clock
        start   : in std_logic;
        reset   : in std_logic;
        bram_data : in std_logic_vector(23 downto 0);
        d_out : out std_logic;
        addr : out std_logic_vector(6 downto 0);
        done : out std_logic
    );
end component;

signal en : std_logic := '0';
signal addr : std_logic_VECTOR(6 downto 0) := (others => '0');
signal bram_dout : std_logic_VECTOR(23 downto 0) := (others => '0');
signal clk_100 : std_logic := '0';
signal reset :  std_logic;
signal start :  std_logic;
signal done : std_logic;

signal d_out : std_logic;

begin

BRAM_instance: blk_mem_gen_0
    port map (
        clka => clk_100,
        ena => en,
        addra => addr,
        douta => bram_dout
    );

Controller_instance: WS2813_Controller
    port map (
        clk_100 => clk_100,
        start => start,
        reset => reset,
        bram_data => bram_dout,
        d_out => d_out,
        addr => addr,
        done => done
    );


clk_gen: process -- Generating a 100 MHz clock signal
begin
    clk_100 <='1';
    wait for 5 ns;
    clk_100 <='0';
    wait for 5 ns;     
end process clk_gen; 

--Simulation process.
process
begin
    --addr <= b"000_0000";
    en <= '1';
    reset <= '1';
    start <= '0';
    wait for 10 ns;
    
    reset <= '0';
    start <= '1';
    wait for 20 ns;
    
    start <= '0';
    
    wait on done;
    
    wait for 30 ns;
end process;  

end Behavioral;
