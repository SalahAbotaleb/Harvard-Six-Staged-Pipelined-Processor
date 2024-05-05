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
mem load -i {C:/Users/moaaz/OneDrive/Desktop/phase 3/DataHazard.mem} /processor/FetchUnit/instructionFile/x
force -freeze sim:/processor/inPort 0000000001000100 0
run
force -freeze sim:/processor/rst 0 0
run
mem load -filltype inc -filldata 0 -fillradix symbolic -skip 0 /processor/MemoryUnit/MyDataMemory/x
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