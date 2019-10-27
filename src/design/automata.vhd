----------------------------------------------------------------------------------
-- Company: Sapientia EMTE
-- Engineer: Patka Zsolt-Andras
-- 
-- Create Date: 10/27/2019 10:13:33 AM
-- Project Name: Led fuzer vezerlese
-- Module Name: automata - Behavioral
-- Description: 
--      100 MHz clk signal = 0.01 us
--      Bit transfer timings:
--      T0H = 0.40 us => 100 Mhz 40 cycle
--      T0L = 0.85 us => 100 Mhz 85 cycle
--      T1H = 0.80 us => 100 Mhz 80 cycle
--      T1L = 0.45 us => 100 Mhz 45 cycle
--      TRES = > 50 us => 100 Mhz >5000 cycle
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- TODO:
--      rename file and entity to led_controll
--      finish bit sending logic
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity automata is
    generic (
        T0H  : integer := 40;
        T0L  : integer := 85;
        T1H  : integer := 80;
        T1L  : integer := 45;
        TRES : integer := 5000;
        LED_TOTAL : integer := 10
    );  
    port (
        clk_100 : in std_logic; --100MHz clock
        start   : in std_logic;
        reset   : in std_logic;
        stop    : in std_logic;
        data    : in std_logic;
        data_rd : in std_logic;
        d_out   : out std_logic
    );
end automata;

architecture Behavioral of automata is
    type state_type is (READY, INIT, RENDER, DISPLAY);
    signal current_state, next_state: state_type;
    signal led_nr : integer range 0 to 15;
    signal bit_count : integer range 0 to 23;
    signal k : integer range 0 to 5100;

begin
    SR: process(clk_100, reset) --State register
    begin
        if (reset = '1') then
            current_state <= READY;
        elsif (clk_100'event and clk_100 = '1') then
            current_state <= next_state;
        end if;
    end process;
    
    process(current_state, start, stop)
    begin
        case current_state is
            when READY =>
                if start = '1' then
                    next_state <= INIT;
                else
                    next_state <= READY;
                end if;
            when INIT =>
                next_state <= RENDER;
            when others =>
                next_state <= current_state;
        end case;        
    end process;
    
    process(clk_100, current_state, data_rd)
    begin
        if (data_rd = '1') then --Data incoming
            if (data = '1') then
                d_out <= '1';
                k <= k + 1;
                if (k = T1H) then
                    k <= 0;
                end if;
            else
                
            end if;
        end if;
    end process;
    

end Behavioral;