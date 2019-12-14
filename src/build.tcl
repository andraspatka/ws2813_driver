set design_name WS2813_LED
# <insert_path_here>
set directory C:/Informatika/fpga/terv/src/vivado
start_gui
create_project ${design_name} ${directory}/${design_name} -part xc7a35tcpg236-1

# Set target language to VHDL 
set_property target_language VHDL [current_project]
# Add vhdl files
add_files -norecurse ${directory}/WS2813_Driver.vhd
add_files -norecurse ${directory}/WS2813_Controller.vhd
add_files -norecurse ${directory}/WS2813_TopLevel.vhd

# Add coefficient files
add_files -norecurse ${directory}/bram_01.coe

# Add constraint file
add_files -fileset constrs_1 -norecurse ${directory}/WS2813.xdc
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

# To set all files to vhdl 2008
set_property file_type {VHDL 2008} [get_files *]