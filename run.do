vlib work
vlog memory_tb.v
#vsim tb +testcase=fw_fr
#vsim tb +testcase=fw_br
#vsim tb +testcase=bw_fr
vsim tb +testcase=bw_br
add wave -r sim:/tb/dut/*
run -all
