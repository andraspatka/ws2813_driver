# TCL script of the setup of ILA testing of WS2813_Driver.vhd

set design_name ws2813_ila
set directory .
start_gui
create_project ${design_name} ${directory}/${design_name} -part xc7a35tcpg236-1

# Set target language to VHDL 
set_property target_language VHDL [current_project]
# Add vhdl file
add_files -norecurse ${directory}/WS2813_Driver.vhd

# Add constraint file
add_files -fileset constrs_1 -norecurse ${directory}/WS2183_ila.xdc
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# Launch the synthesis and wait until it's finished
launch_runs synth_1
wait_on_run synth_1

# Open the synthesized design
open_run synth_1

# Add the Debug core to the design
create_debug_core u_ila_0 ila

#Configuring the ILA module
set_property C_DATA_DEPTH 65536 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN true [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
# enable advanced trigger mode
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
# enable Basic capture mode
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]

# Defining the clock for ILA module
connect_debug_port u_ila_0/clk [get_nets [list clk_100_IBUF_BUFG]]
# Defining the probe's bus width
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
# _IBUF suffix for input, _OBUF suffix for output
connect_debug_port u_ila_0/probe0 [get_nets [list start_IBUF reset_IBUF]]

# Creating another input (probe1) to the test module's input
create_debug_port u_ila_0 probe
# Set bus width
set_property port_width 2 [get_debug_ports u_ila_0/probe1]
# set d_out and done outputs to probe input
connect_debug_port u_ila_0/probe1 [get_nets [list d_out_OBUF done_OBUF]]

# Saving the debug constraint file
save_constraints_as system_${design_name}.xdc

set_property constrset system_${design_name}.xdc [get_runs synth_1]
set_property constrset system_${design_name}.xdc [get_runs impl_1]

# Launching the implementation
launch_runs impl_1
wait_on_run impl_1

# Generating the configuration file
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

# Opening the hardware
open_hw

# Starting the server to connect to the FPGA
connect_hw_server
# Openning the target hardware
open_hw_target

# Setting the configuration bit file
set_property PROGRAM.FILE ${directory}/${design_name}/${design_name}.runs/impl_1/WS2813_Driver.bit [lindex [get_hw_devices] 1]
set_property PROBES.FILE ${directory}/${design_name}/${design_name}.runs/impl_1/debug_nets.ltx [lindex [get_hw_devices] 1]

current_hw_device [lindex [get_hw_devices] 1]
# Refreshing the hardware device
refresh_hw_device [lindex [get_hw_devices] 1]

# Programming the hardware device
program_hw_devices [lindex [get_hw_devices] 1]

refresh_hw_device [lindex [get_hw_devices] 1]