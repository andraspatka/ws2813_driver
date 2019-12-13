----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2019 08:47:03 PM
-- Design Name: 
-- Module Name: WS2813_TopLevel_sim - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;

entity WS2813_TopLevel_sim is
--  Port ( );
end WS2813_TopLevel_sim;

architecture Behavioral of WS2813_TopLevel_sim is

component WS2813_TopLevel is
    generic (N : natural := 2);
    port (
        clk_100 : in std_logic; --100MHz clock
        start   : in std_logic;
        reset   : in std_logic;
        d_out   : out std_logic_vector(N-1 downto 0);
        done    : out std_logic
    );
end component;

signal clk_100 : std_logic := '0';
signal start :  std_logic;
signal reset :  std_logic;
signal done : std_logic;
signal d_out : std_logic_vector(1 downto 0);


begin

TopLevel_instance: WS2813_TopLevel
    port map (
        clk_100 => clk_100,
        start => start,
        reset => reset,
        d_out => d_out,
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
