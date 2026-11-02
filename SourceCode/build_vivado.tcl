
cd [file dirname [file normalize [info script]]]
create_project cpu16 ./vivado_project -part xc7a35tcpg236-1 -force
file delete -force ./fpga_top.bit
set_msg_config -id {Synth 8-4445} -new_severity ERROR
add_files {pc.v adder16.v mux2.v instr_mem.v data_mem.v reg_file.v alu.v alu_control.v control_unit.v sign_ext4.v sign_ext12.v shift_left1.v branch_logic.v cpu_top.v debouncer.v seven_seg.v display_select.v fpga_top.v program1.mem}
set_property top fpga_top [get_filesets sources_1]
add_files -fileset constrs_1 basys3.xdc
add_files -fileset sim_1 {alu_tb.v reg_file_tb.v data_mem_tb.v components_tb.v cpu_tb.v fpga_top_tb.v program2.mem data2.mem}
set_property top cpu_tb [get_filesets sim_1]
set_property -name {xsim.simulate.runtime} -value {all} -objects [get_filesets sim_1]
launch_runs synth_1 -jobs 4
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "Synthesis failed, see vivado_project/cpu16.runs/synth_1/runme.log"
}
launch_runs impl_1 -to_step write_bitstream -jobs 4
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    error "Implementation failed, see vivado_project/cpu16.runs/impl_1/runme.log"
}

file copy -force ./vivado_project/cpu16.runs/impl_1/fpga_top.bit ./fpga_top.bit
puts "Bitstream written to fpga_top.bit"
