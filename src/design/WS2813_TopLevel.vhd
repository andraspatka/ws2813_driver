----------------------------------------------------------------------------------
-- Company: Sapientia EMTE
-- Engineer: Patka Zsolt-Andras
-- 
-- Create Date: 12/13/2019 05:39:14 PM
-- Project Name: Led fuzer vezerlese
-- Module Name: WS2813_TopLevel - Behavioral
-- Target Devices: Basys3 FPGA
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Revision 0.02 - Logic implemented
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity WS2813_TopLevel is
    generic (N : natural := 2);
    port (
        clk_100 : in std_logic; --100MHz clock
        start   : in std_logic;
        reset   : in std_logic;
        d_out   : out std_logic_vector(N-1 downto 0);
        done    : out std_logic
    );
end WS2813_TopLevel;

architecture Behavioral of WS2813_TopLevel is

component WS2813_Controller is
    port (
        clk_100   : in std_logic; --100MHz clock
        start     : in std_logic;
        reset     : in std_logic;
        bram_data : in std_logic_vector(23 downto 0);
        d_out     : out std_logic;
        addr      : out std_logic_vector(6 downto 0);
        done      : out std_logic
    );
end component;

component blk_mem_gen_0 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
end component;

component blk_mem_gen_1 is
  PORT (
    clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(23 DOWNTO 0)
  );
end component;

---------------------------------------------------------------------------------------------------------------
-- INSERT ADDITIONAL BRAM MODULES COMPONENT DECLARATIONS HERE

---------------------------------------------------------------------------------------------------------------

    type address_array_type is array(N-1 downto 0) of std_logic_vector(6 downto 0);
    type data_array_type is array(N-1 downto 0) of std_logic_vector(23 downto 0);
    type state_type is (
        READY,
        INIT,
        RESET_CTRLS,
        START_CTRLS,
        SEND,
        FINISHED
    );
    
    signal current_state, next_state: state_type;
    
    signal Controller_done : std_logic_vector(N-1 downto 0);
    signal Controller_done_red : std_logic;
    signal Controller_reset : std_logic_vector(N-1 downto 0);
    signal Controller_start : std_logic_vector(N-1 downto 0);
    signal Bram_dout : data_array_type;
    signal Bram_addr : address_array_type;
    signal Bram_enable : std_logic;
begin
-- Instantiating the BRAM modules
    Bram_0_instance: blk_mem_gen_0
    port map (
        clka => clk_100,
        ena => Bram_enable,
        addra => Bram_addr(0),
        douta => Bram_dout(0)
    );
    
    Bram_1_instance: blk_mem_gen_1
    port map (
        clka => clk_100,
        ena => Bram_enable,
        addra => Bram_addr(1),
        douta => Bram_dout(1)
    );

---------------------------------------------------------------------------------------------------------------
-- INSERT ADDITIONAL BRAM INSTANTIATIONS HERE

---------------------------------------------------------------------------------------------------------------


-- Instantiating the Controller modules
    ctrl_gen: for i in d_out'RANGE GENERATE
        ctrlx : WS2813_Controller port map (
            clk_100 => clk_100,
            start => Controller_start(i),
            reset => Controller_reset(i),
            bram_data => Bram_dout(i),
            d_out => d_out(i),
            addr => Bram_addr(i),
            done => Controller_done(i)
        );
    end generate ctrl_gen;
    
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
    NSR: process(current_state, start, Controller_done_red)
    begin
        case current_state is
            when READY =>
                if start = '1' then
                    next_state <= INIT;
                else
                    next_state <= READY;
                end if;
            when INIT =>
                Bram_enable <= '1'; 
                next_state <= RESET_CTRLS;
            when RESET_CTRLS =>
                next_state <= START_CTRLS;
            when START_CTRLS =>
                next_state <= SEND;
            when SEND =>
                if (Controller_done_red = '0') then
                    next_state <= SEND;
                else
                    next_state <= FINISHED;
                end if;
            when FINISHED =>
                Bram_enable <= '0';
                next_state <= FINISHED;
        end case;        
    end process;
    
    with current_state select
        done <= '1' when FINISHED,
                '0' when others;
    
    with current_state select
        Controller_reset <= (others => '1') when RESET_CTRLS,
                            (others => '0') when others;
                            
    with current_state select
        Controller_start <= (others => '1') when START_CTRLS,
                            (others => '0') when others;
    
    Controller_done_red <= and Controller_done; 
end Behavioral;
