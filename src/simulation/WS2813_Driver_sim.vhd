----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/09/2019 01:52:41 PM
-- Design Name: 
-- Module Name: WS2813_Driver_sim - Behavioral
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

entity WS2813_Driver_sim is
--  Port ( );
end WS2813_Driver_sim;

architecture Behavioral of WS2813_Driver_sim is

component WS2813_Driver is
    port (
        clk_100 : in std_logic; --100MHz clock
        start   : in std_logic;
        reset   : in std_logic;
        data    : in std_logic_vector(23 downto 0);
        d_out   : out std_logic;
        done    : out std_logic
    );
end component;

signal clk_100 :  std_logic;
signal reset :  std_logic;
signal start :  std_logic;
signal data :  std_logic_vector (23 downto 0);
signal d_out : std_logic;
signal done : std_logic;

begin

led_driver_instance: WS2813_Driver  
    Port map (
        clk_100 => clk_100,
        start   => start,
        reset   => reset,
        data    => data,
        d_out   => d_out,
        done    => done);

clk_gen: process -- Generating a 100 MHz clock signal
begin
 clk_100 <='1';
 wait for 5 ns;
 clk_100 <='0';
 wait for 5 ns;     
end process clk_gen; 

signal_generator: process
begin 
    reset <= '1';
    start <= '0';
    data <= x"A1B2E3";
    wait for 10 ns;
    
    reset <= '0';
    start <= '1';
    wait for 20 ns;
    
    start <= '0';
    
    wait on done;
    
end process;


end Behavioral;
