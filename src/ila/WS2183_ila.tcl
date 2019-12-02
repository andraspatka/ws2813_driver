
#TCL parancsokat alkalamzva  terv a követekzõképpen hozható létre

set terv_nev led_ila
set konyvtar D:/Diak/Patka/led_fuzer_mukodes_kozbeni
start_gui
create_project ${terv_nev} ${konyvtar}/${terv_nev} -part xc7z010clg400-1

#check_ip_cache -clear_output_repo

#VHDL hardver leíró nyelv beállítása
set_property target_language VHDL [current_project]
#VHDL forráskódnak a tervhez való csatolása
add_files -norecurse ${konyvtar}/WS2813_Driver.vhd

#Megkötés állománynak a tervhez valócsatolása
add_files -fileset constrs_1 -norecurse ${konyvtar}/system_4.xdc
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

#Szintézis futtatása
launch_runs synth_1
#Várakozás a szintézis befejezésére
wait_on_run synth_1

#Synthesized Design megnyitása
open_run synth_1

#Debug core magnak a tervhez való csatolása
create_debug_core u_ila_0 ila

#ILA modul konfigurálása
set_property C_DATA_DEPTH 65536 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN true [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
#enable advanced trigger mode
set_property C_ADV_TRIGGER true [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
#enable Basic capture mode
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]

#ILA modul órajelének meghatározása
connect_debug_port u_ila_0/clk [get_nets [list clk_100_IBUF_BUFG]]
#A Test modulon probe0 sínszélességének meghatározása
set_property port_width 2 [get_debug_ports u_ila_0/probe0]
#probe0 bemenetre a start, reset és d_out jelek csatolása. 
#a forráskodban meghatározott jelek nem érhetõek el tesztelésre a szintézist követõen, hanem a 
#bemenetek esetében start_IBUF reset_IBUF, kimenetek esetében pedig _OBUF
connect_debug_port u_ila_0/probe0 [get_nets [list start_IBUF reset_IBUF]]

#egy újabb bemenet (probe1) létrehozása a tesztmodul bemenetére
create_debug_port u_ila_0 probe
#sínszélesség beállítása
set_property port_width 2 [get_debug_ports u_ila_0/probe1]
#q_OBUF[0], q_OBUF[1], q_OBUF[2], q_OBUF[3]  kiemeneteknek a probe1 bemeneti portra való csatolása
connect_debug_port u_ila_0/probe1 [get_nets [list d_out done]]

#Megkötés fájl mentése
save_constraints_as system_${terv_nev}.xdc

set_property constrset system_${terv_nev}.xdc [get_runs synth_1]
set_property constrset system_${terv_nev}.xdc [get_runs impl_1]
#save_constraints

#check_ip_cache -clear_output_repo

#Implementáció lefuttatása
launch_runs impl_1
wait_on_run impl_1

#Konfigurációs fájl generálása
launch_runs impl_1 -to_step write_bitstream
wait_on_run impl_1

#Hardver megnyitása
open_hw

#szerver indítása az FPGA áramkörre való kapcsolódás céljábók
connect_hw_server
#Célhardver megnyitása 
open_hw_target

#Konfigurios .bit fájl és debug_net.ltx beállítása
set_property PROGRAM.FILE ${konyvtar}/${terv_nev}/${terv_nev}.runs/impl_1/top_level_2.bit [lindex [get_hw_devices] 1]
set_property PROBES.FILE ${konyvtar}/${terv_nev}/${terv_nev}.runs/impl_1/debug_nets.ltx [lindex [get_hw_devices] 1]


current_hw_device [lindex [get_hw_devices] 1]
#hardver frisítése
refresh_hw_device [lindex [get_hw_devices] 1]

#hardver programozása
program_hw_devices [lindex [get_hw_devices] 1]

refresh_hw_device [lindex [get_hw_devices] 1]