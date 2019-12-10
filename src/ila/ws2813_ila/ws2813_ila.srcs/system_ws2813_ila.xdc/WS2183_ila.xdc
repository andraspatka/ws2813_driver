# Clock signal
set_property -dict {PACKAGE_PIN W5} [get_ports clk_100]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports clk_100]

# Switches
set_property -dict {PACKAGE_PIN V17} [get_ports reset]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports reset]
set_property -dict {PACKAGE_PIN V16} [get_ports start]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports start]

set_property -dict {PACKAGE_PIN W2} [get_ports {data[0]}]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports {data[0]}]
set_property -dict {PACKAGE_PIN U1} [get_ports {data[1]}]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports {data[1]}]
set_property -dict {PACKAGE_PIN T1} [get_ports {data[2]}]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports {data[2]}]
set_property -dict {PACKAGE_PIN R2} [get_ports {data[3]}]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports {data[3]}]

# LEDs
set_property -dict {PACKAGE_PIN U16} [get_ports d_out]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports d_out]
set_property -dict {PACKAGE_PIN E19} [get_ports done]
set_property -dict {IOSTANDARD LVCMOS33} [get_ports done]

set_property MARK_DEBUG true [get_nets {data_IBUF[1]}]
set_property MARK_DEBUG true [get_nets {data_IBUF[2]}]
set_property MARK_DEBUG true [get_nets {data_IBUF[0]}]
set_property MARK_DEBUG true [get_nets {data_IBUF[3]}]
set_property MARK_DEBUG true [get_nets clk_100_IBUF]
create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 4 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list clk_100_IBUF_BUFG]]
set_property PROBE_TYPE DATA [get_debug_ports u_ila_0/probe0]
set_property port_width 4 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {data_IBUF[0]} {data_IBUF[1]} {data_IBUF[2]} {data_IBUF[3]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 1 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list clk_100_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 1 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list d_out_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 1 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list done_OBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 1 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list reset_IBUF]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 1 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list start_IBUF]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets clk_100_IBUF_BUFG]
