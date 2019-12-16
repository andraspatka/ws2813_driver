# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk_100]							
set_property IOSTANDARD LVCMOS33 [get_ports clk_100]
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk_100]

# Switches
set_property PACKAGE_PIN V17 [get_ports {reset}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {reset}]
set_property PACKAGE_PIN V16 [get_ports {start}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {start}]

set_property PACKAGE_PIN E19 [get_ports {done}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {done}]


##Pmod Header JA
##Sch name = JA1
set_property PACKAGE_PIN J1 [get_ports {d_out[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {d_out[0]}]
##Sch name = JA2
set_property PACKAGE_PIN L2 [get_ports {d_out[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {d_out[1]}]