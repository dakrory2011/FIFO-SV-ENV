vlib work
vlog -f src_files.list +define+SIM +cover=bcst -covercells -sv
vsim -voptargs=+acc -assertdebug top -cover +assertcover
add wave -position insertpoint sim:/top/fifo_if/*
add wave -position insertpoint sim:/top/dut/*
add wave -position insertpoint sim:/top/dut/mem
add wave -position insertpoint sim:/shared_pkg/*
add wave -position insertpoint sim:/FIFO_scoreboard_pkg/*
run 0
run -all
coverage save top.ucdb -onexit
report -assertions -all
vcover report top.ucdb -details -assert -cvg
coverage exclude -src FIFO.sv -line 23 -code c