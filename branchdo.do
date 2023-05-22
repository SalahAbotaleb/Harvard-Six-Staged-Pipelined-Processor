add wave -position insertpoint  \
sim:/processor/RegFile/x
add wave -position insertpoint  \
sim:/processor/curr_instr_pc
add wave -position insertpoint  \
sim:/processor/SPin
add wave -position insertpoint  \
sim:/processor/SPout
add wave -position insertpoint  \
sim:/processor/AluCCRin
add wave -position insertpoint  \
sim:/processor/CCRd
add wave -position insertpoint  \
sim:/processor/clk
add wave -position insertpoint  \
sim:/processor/rst
add wave -position insertpoint  \
sim:/processor/interupt
add wave -position insertpoint  \
sim:/processor/inPort
add wave -position insertpoint  \
sim:/processor/outPort

force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
mem load -i {C:/Users/moaaz/OneDrive/Desktop/phase 3/ControlHazard.mem} /processor/FetchUnit/instructionFile/x
force -freeze sim:/processor/inPort 0101010101010101 0
run
force -freeze sim:/processor/rst 0 0
run
force -freeze sim:/processor/interupt 1 0
run
force -freeze sim:/processor/interupt 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
force -freeze sim:/processor/interupt 1 0
run
force -freeze sim:/processor/interupt 0 0
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run