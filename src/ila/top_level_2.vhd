----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/23/2017 10:40:17 AM
-- Design Name: 
-- Module Name: top_level - Behavioral
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
use IEEE.STD_LOGIC_SIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



entity top_level_2 is
generic (
        div_val : natural:=256);
    Port ( src_clk : in STD_LOGIC;
           --src_ce : in STD_LOGIC;
           reset : in STD_LOGIC;
           start : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (3 downto 0));
end top_level_2;

architecture Behavioral of top_level_2 is

signal q_clk: std_logic;

-- attribute mark_debug : string;
-- attribute mark_debug of reset: signal is "true";
-- attribute mark_debug of start: signal is "true";
-- attribute mark_debug of q: signal is "true";
-- attribute mark_debug of q_clk: signal is "true";
--attribute mark_debug of  q_div : signal is "true";

begin

szamlalo: process(q_clk, reset)
variable sz: std_logic_vector(3 downto 0);
begin
if reset='1' then 
    sz:=(others=>'0');
elsif q_clk'event and q_clk='1' and start='1' then
    sz:=sz+1;
    end if;
    q<=sz;
end process szamlalo;


modulo:process(src_clk,reset)

variable x: integer range 1023 downto 0 := 0;
variable q_div: STD_LOGIC:= '0';

begin
if src_clk'event and src_clk='1' then
	if x<div_val then 							--- n ??????
		x:=x+1;
		q_div:=q_div;
	else
		x:=0;
		q_div:=not(q_div);
	end if;
	q_clk<=q_div;
end if;

end process modulo;
end Behavioral;
