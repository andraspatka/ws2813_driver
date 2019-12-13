----------------------------------------------------------------------------------
-- Company: Sapientia EMTE
-- Engineer: Patka Zsolt-Andras
-- 
-- Create Date: 12/01/2019 07:15:28 PM
-- Project Name: Led fuzer vezerlese
-- Module Name: controller - Behavioral
-- Target Devices: Basys3 FPGA 
-- Description: 
--      Module capable of receiving data from a bram module 
--      and sending this to a WS2813 LED strips, using the WS2813_Driver module.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Updated documentation
-- Revision 0.03 - Implemented logic
-- Revision 0.04 - Renamed file: controller -> WS2813_Controller
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity WS2813_Controller is
    port (
        clk_100   : in std_logic; --100MHz clock
        start     : in std_logic;
        reset     : in std_logic;
        bram_data : in std_logic_vector(23 downto 0);
        d_out     : out std_logic;
        addr      : out std_logic_vector(6 downto 0);
        done      : out std_logic
    );
end WS2813_Controller;

architecture Behavioral of WS2813_Controller is		

component WS2813_Driver is
    port (
        clk_100 : in std_logic; --100MHz clock
        start   : in std_logic;
        reset   : in std_logic;
        data    : in std_logic_vector(23 downto 0);
        d_out   : out std_logic;
        done    : out std_logic
    );
end component WS2813_Driver;		
				
    type state_type is (
        READY,
        INIT,
        RESET_DRIVER,
        START_DRIVER,
        SEND,
        ADDR_CHECK,
        ADDR_INC,
        FINISHED
    );
    signal current_state, next_state: state_type;
    signal Raddr, Raddr_next : std_logic_vector(6 downto 0);
    signal Driver_reset : std_logic;
    signal Driver_start : std_logic;
    signal Driver_done : std_logic;
begin

    Driver_instance: WS2813_Driver
    port map (
        clk_100 => clk_100,
        start   => Driver_start,
        reset   => Driver_reset,
        data    => bram_data,
        d_out   => d_out,
        done    => Driver_done
    );

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
    NSR: process(current_state, start, Raddr, Driver_done)
    begin
        case current_state is
            when READY =>
                if start = '1' then
                    next_state <= INIT;
                else
                    next_state <= READY;
                end if;
            when INIT =>
                next_state <= RESET_DRIVER;
            when RESET_DRIVER =>
                next_state <= START_DRIVER;
            when START_DRIVER =>
                next_state <= SEND;
            when SEND =>
                if (Driver_done = '0') then
                    next_state <= SEND;
                else
                    next_state <= ADDR_INC;
                end if;
            when ADDR_INC =>
                next_state <= ADDR_CHECK;
            when ADDR_CHECK =>
                if (Raddr < B"101_1010") then --check if less than 90
                    next_state <= RESET_DRIVER;
                else
                    next_state <= FINISHED;
                end if;
            when FINISHED =>
                next_state <= FINISHED;
        end case;        
    end process;
    
    with current_state select
        Raddr_next <= B"000_0000" when INIT,
                      std_logic_vector(unsigned(Raddr) + 1) when ADDR_INC,
                      Raddr when others;
                 
    with current_state select
        Driver_reset <= '1' when RESET_DRIVER,
                        '0' when START_DRIVER,
                        '0' when others;
    
    with current_state select
        Driver_start <= '0' when RESET_DRIVER,
                        '1' when START_DRIVER,
                        '0' when others;     
                        
    with current_state select
        done <= '0' when READY,
                '1' when FINISHED,
                '0' when others;
    
    addr <= Raddr;
    
    --For the address register
    DATA_Raddr : process(clk_100)
    begin
        if clk_100'event and clk_100 = '1' then
            Raddr <= Raddr_next;
        end if;
    end process DATA_Raddr;
    
end Behavioral;
