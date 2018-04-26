# 
# Synthesis run script generated by Vivado
# 

proc create_report { reportName command } {
  set status "."
  append status $reportName ".fail"
  if { [file exists $status] } {
    eval file delete [glob $status]
  }
  send_msg_id runtcl-4 info "Executing : $command"
  set retval [eval catch { $command } msg]
  if { $retval != 0 } {
    set fp [open $status w]
    close $fp
    send_msg_id runtcl-5 warning "$msg"
  }
}
set_msg_config -id {Common 17-41} -limit 10000000
create_project -in_memory -part xc7a35tcpg236-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_msg_config -source 4 -id {IP_Flow 19-2162} -severity warning -new_severity info
set_property webtalk.parent_dir C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.cache/wt [current_project]
set_property parent.project_path C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.xpr [current_project]
set_property XPM_LIBRARIES XPM_MEMORY [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property ip_output_repo c:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files c:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/blank.coe
add_files c:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/background.coe
read_verilog -library xil_defaultlib {
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/ClockDivider.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/Color.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/Debounce.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/Filter.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/imports/Mouse.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/Music.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/PWMGen.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/PlayMusic.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/PlayerCtrl.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/SevenSeg.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/VGA.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/WriteRam.v
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/new/Top.v
}
read_vhdl -library xil_defaultlib {
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/imports/MouseCtl.vhd
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/imports/MouseDisplay.vhd
  C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/imports/Ps2Interface.vhd
}
read_ip -quiet c:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/ip/blk_mem_gen_2/blk_mem_gen_2.xci
set_property used_in_implementation false [get_files -all c:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/ip/blk_mem_gen_2/blk_mem_gen_2_ooc.xdc]

read_ip -quiet c:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1.xci
set_property used_in_implementation false [get_files -all c:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/sources_1/ip/blk_mem_gen_1/blk_mem_gen_1_ooc.xdc]

# Mark all dcp files as not used in implementation to prevent them from being
# stitched into the results of this synthesis run. Any black boxes in the
# design are intentionally left as such for best results. Dcp files will be
# stitched into the design at a later time, either when this synthesis run is
# opened, or when it is stitched into a dependent implementation run.
foreach dcp [get_files -quiet -all -filter file_type=="Design\ Checkpoint"] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/constrs_1/new/Basys3Master.xdc
set_property used_in_implementation false [get_files C:/Users/kaiwen/Desktop/Basys3_Paint/Basys3_Paint.srcs/constrs_1/new/Basys3Master.xdc]

read_xdc dont_touch.xdc
set_property used_in_implementation false [get_files dont_touch.xdc]

synth_design -top top -part xc7a35tcpg236-1


# disable binary constraint mode for synth run checkpoints
set_param constraints.enableBinaryConstraints false
write_checkpoint -force -noxdef top.dcp
create_report "synth_1_synth_report_utilization_0" "report_utilization -file top_utilization_synth.rpt -pb top_utilization_synth.pb"
