##Clock signal

# Clock signal
set_property PACKAGE_PIN W5 [get_ports clk_100]							
set_property IOSTANDARD LVCMOS33 [get_ports clk_100]

# Switches
set_property PACKAGE_PIN V17 [get_ports reset]					
	set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property PACKAGE_PIN V16 [get_ports start]					
	set_property IOSTANDARD LVCMOS33 [get_ports start]

# LEDs
set_property PACKAGE_PIN U16 [get_ports d_out]					
	set_property IOSTANDARD LVCMOS33 [get_ports d_out]
set_property PACKAGE_PIN E19 [get_ports done]					
	set_property IOSTANDARD LVCMOS33 [get_ports done]
