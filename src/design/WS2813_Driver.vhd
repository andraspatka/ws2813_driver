----------------------------------------------------------------------------------
-- Company: Sapientia EMTE
-- Engineer: Patka Zsolt-Andras
-- 
-- Create Date: 11/07/2019 08:02:14 PM
-- Project Name: Led fuzer vezerlese
-- Module Name: WS2813_Driver - Behavioral
-- Description: 
--      Module capable of driving a WS2813 LED strip
--      Sends ONE 24 bit block to the WS2813 LED strip
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
use IEEE.NUMERIC_STD.ALL;

entity WS2813_Driver is
    port (
        clk_100 : in std_logic; --100MHz clock
        start   : in std_logic;
        reset   : in std_logic;
        data    : in std_logic_vector(23 downto 0);
        d_out   : out std_logic;
        done    : out std_logic
    );
end WS2813_Driver;

architecture Behavioral of WS2813_Driver is
    constant T0H  : integer := 40;
    constant T0L  : integer := 85;
    constant T1H  : integer := 80;
    constant T1L  : integer := 45;
    constant TRES : integer := 5000;
    
    type state_type is (
        READY,
        INIT,
        SEND_IF01,
        -- Send 1
        SEND1H_INIT,
        SEND1H,
        SEND1L_INIT,
        SEND1L,
        -- Send 0
        SEND0H_INIT,
        SEND0H,
        SEND0L_INIT,
        SEND0L,
        -- bit_count == 24?
        SHIFT_CHECK,
        -- latching
        SENDRES_INIT,
        SENDRES,
        --done
        SEND_DONE
    );
    signal current_state, next_state: state_type;
    signal bit_count : integer range 0 to 23;
    signal i : integer range 0 to 5100;
    signal r_data : std_logic_vector(23 downto 0);
    
begin
    --State register
    SR: process(clk_100, reset) 
    begin
        if (reset = '1') then
            current_state <= READY;
        elsif (clk_100'event and clk_100 = '1') then
            current_state <= next_state;
        end if;
    end process;
    
    -- Next State Logic Register
    NSR: process(current_state, start, i)
    begin
        case current_state is
            when READY =>
                done <= '0';
                if start = '1' then
                    next_state <= INIT;
                else
                    next_state <= READY;
                end if;
            when INIT =>
                bit_count <= 0;
                next_state <= SEND_IF01;
            when SEND_IF01 =>
                if r_data(23) = '1' then
                    next_state <= SEND1H_INIT;
                else
                    next_state <= SEND0H_INIT;
                end if;
            -- Sending '1'
            -- Sending 1H
            when SEND1H_INIT =>
                i <= T1H;
                d_out <= '1';
                next_state <= SEND1H;
            when SEND1H =>
                i <= i - 1;
                if i = 0 then
                    next_state <= SEND1L_INIT;
                else
                    next_state <= SEND1H;
                end if;
            -- Sending 1L
            when SEND1L_INIT =>
                i <= T1L;
                d_out <= '0';
                next_state <= SEND1L;
            when SEND1L => -- TODO: refactor into function
                i <= i - 1;
                if i = 0 then
                    next_state <= SHIFT_CHECK;
                else
                    next_state <= SEND1L;
                end if;
            -- Sending '0'
            -- Sending 0H
            when SEND0H_INIT =>
                i <= T0H;
                d_out <= '1';
                next_state <= SEND0H;
            when SEND0H =>
                i <= i - 1;
                if i = 0 then
                    next_state <= SEND0L_INIT;
                else
                    next_state <= SEND0H;
                end if;
            when SEND0L_INIT =>
                i <= T0L;
                d_out <= '0';
                next_state <= SEND0L;
            when SEND0L =>
                i <= i - 1;
                if i = 0 then
                    next_state <= SHIFT_CHECK;
                else
                    next_state <= SEND0L;
                end if;
            -- Shift check
            when SHIFT_CHECK =>
                if bit_count = 24 then
                    next_state <= SENDRES_INIT;
                else
                    bit_count <= bit_count + 1;
                    r_data <= std_logic_vector(shift_left(unsigned(r_data), 1));
                    next_state <= SEND_IF01;
                end if;
            -- Latching
            when SENDRES_INIT =>
                i <= TRES;
                d_out <= '0';
            when SENDRES =>
                i <= i - 1;
                if i = 0 then
                    next_state <= SEND_DONE;
                else
                    next_state <= SENDRES;
                end if;
            when SEND_DONE =>
                done <= '1';
            when others =>
                next_state <= current_state;
        end case;        
    end process;
    
    r_data <= data;
    
end Behavioral;