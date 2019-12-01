----------------------------------------------------------------------------------
-- Company: Sapientia EMTE
-- Engineer: Patka Zsolt-Andras
-- 
-- Create Date: 12/01/2019 07:15:28 PM
-- Module Name: controller - Behavioral
-- Project Name: Led fuzer vezerlese
-- Target Devices: Basys3 FPGA 
-- Description: 
--      Module capable of sending data to multiple WS2813 LED strips, using the WS2813_Driver module.
--      With the help of a generic parameter it is possible the number of LED strips used.
--      Sends data to all strips concurrently.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller is
    generic(N : integer);
    port (
        clk_100 : in std_logic; --100MHz clock
        start   : in std_logic;
        reset   : in std_logic
    );
end controller;

architecture Behavioral of controller is

begin


end Behavioral;
