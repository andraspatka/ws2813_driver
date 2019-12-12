----------------------------------------------------------------------------------
-- Company: Sapientia EMTE
-- Engineer: Patka Zsolt-Andras
-- 
-- Create Date: 11/07/2019 08:02:14 PM
-- Project Name: Led fuzer vezerlese
-- Target Devices: Basys3 FPGA
-- Module Name: WS2813_Driver - Behavioral
-- Description: 
--      Module capable of driving a WS2813 LED strip
--      Sends ONE 24 bit block to the WS2813 LED strip
--      100 MHz clk signal = 0.01 us
--      Bit transfer timings:
--      T0H = 0.40 us => 100 Mhz 40 cycle -> 39
--      T0L = 0.85 us => 100 Mhz 85 cycle -> 79
--      T1H = 0.80 us => 100 Mhz 80 cycle -> 79
--      T1L = 0.45 us => 100 Mhz 45 cycle -> 39
--      TRES = > 50 us => 100 Mhz >5000 cycle
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Logic implemented
-- Revision 0.03 - Tidied up the implementation, followed Finite Automata with data path pattern.
-- Revision 0.04 - Bit_count is now counted downwards and compared to 0.
-- Revision 0.05 - During simulation it was observed that the timings were not exactly correct
--                 The T0H, T0L, T1H, T0H values were updated to address this.
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
        data    : in std_logic_vector(3 downto 0);
        d_out   : out std_logic;
        done    : out std_logic
    );
end WS2813_Driver;

architecture Behavioral of WS2813_Driver is
    constant T0H  : integer := 39;
    constant T0L  : integer := 79;
    constant T1H  : integer := 79;
    constant T1L  : integer := 39;
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
        SHIFT,
        -- latching
        SENDRES_INIT,
        SENDRES,
        --done
        SEND_DONE
    );
    signal current_state, next_state: state_type;
    signal Rbit_count, Rbit_count_next : integer range 0 to 3;
    signal Ri, Ri_next : integer range 0 to 5100;
    signal Rdata, Rdata_next: std_logic_vector(3 downto 0);
    
begin
    --State register
    SR: process(clk_100, next_state, reset) 
    begin
        if (reset = '1') then
            current_state <= READY;
        elsif (clk_100'event and clk_100 = '1') then
            current_state <= next_state;
        end if;
    end process;
    
    -- Next State Logic Register
    NSR: process(current_state, start, Ri, Rbit_count, Rdata)
    begin
        case current_state is
            when READY =>
                if start = '1' then
                    next_state <= INIT;
                else
                    next_state <= READY;
                end if;
            when INIT =>
                next_state <= SEND_IF01;
            when SEND_IF01 =>
                if Rdata(3) = '1' then
                    next_state <= SEND1H_INIT;
                else
                    next_state <= SEND0H_INIT;
                end if;
            -- Sending '1'
            -- Sending 1H
            when SEND1H_INIT =>
                next_state <= SEND1H;
            when SEND1H =>
                if Ri = 0 then
                    next_state <= SEND1L_INIT;
                else
                    next_state <= SEND1H;
                end if;
            -- Sending 1L
            when SEND1L_INIT =>
                next_state <= SEND1L;
            when SEND1L =>
                if Ri = 0 then
                    next_state <= SHIFT_CHECK;
                else
                    next_state <= SEND1L;
                end if;
            -- Sending '0'
            -- Sending 0H
            when SEND0H_INIT =>
                next_state <= SEND0H;
            when SEND0H =>
                if Ri = 0 then
                    next_state <= SEND0L_INIT;
                else
                    next_state <= SEND0H;
                end if;
            when SEND0L_INIT =>
                next_state <= SEND0L;
            when SEND0L =>
                if Ri = 0 then
                    next_state <= SHIFT_CHECK;
                else
                    next_state <= SEND0L;
                end if;
            -- Shift check
            when SHIFT_CHECK =>
                if Rbit_count = 0 then
                    next_state <= SENDRES_INIT;
                else
                    next_state <= SHIFT;
                end if;
            when SHIFT =>
                next_state <= SEND_IF01;
            -- Latching
            when SENDRES_INIT =>
                next_state <= SENDRES;
            when SENDRES =>
                if Ri = 0 then
                    next_state <= SEND_DONE;
                else
                    next_state <= SENDRES;
                end if;
            when SEND_DONE =>
                next_state <= SEND_DONE;
            when others =>
                next_state <= current_state;
        end case;        
    end process;
    
    --Multiplexers
    with current_state select
        Ri_next <= 0 when READY,
                   T1H when SEND1H_INIT,
                   Ri - 1 when SEND1H,
                   T1L when SEND1L_INIT,
                   Ri - 1 when SEND1L,
                   T0H when SEND0H_INIT,
                   Ri - 1 when SEND0H,
                   T0L when SEND0L_INIT,
                   Ri - 1 when SEND0L,
                   TRES when SENDRES_INIT,
                   Ri - 1 when SENDRES,
                   Ri when others;
    
    with current_state select
        Rbit_count_next <= 3 when INIT,
                           Rbit_count - 1 when SHIFT_CHECK,
                           Rbit_count when others;
        
    with current_state select
        Rdata_next <= data when INIT,
                      std_logic_vector(shift_left(unsigned(Rdata), 1)) when SHIFT,
                      Rdata when others;
    
    with current_state select
        done <= '0' when READY,
                '1' when SEND_DONE,
                '0' when others;
            
    with current_state select
        d_out <= '0' when READY,
                 '1' when SEND1H,
                 '0' when SEND1L,
                 '1' when SEND0H,
                 '0' when SEND0L,
                 '0' when SENDRES,
                 '0' when others;
            
    --For the index register
    DATA_Ri : process(clk_100)
    begin
        if clk_100'event and clk_100 = '1' then
            Ri <= Ri_next;
        end if;
    end process DATA_Ri;
    
    --For the data register
    DATA_Rdata : process(clk_100)
    begin
        if clk_100'event and clk_100 = '1' then
            Rdata <= Rdata_next;
        end if;
    end process DATA_Rdata;
    
    --For the bit_count register
    DATA_Rbit_count : process(clk_100)
    begin
        if clk_100'event and clk_100 = '1' then
            Rbit_count <= Rbit_count_next;
        end if;
    end process DATA_Rbit_count;
    
end Behavioral;
