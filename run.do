restart
mem load -i ./finaltc.mem -startaddress 0 -endaddress 32 /processor/FetchUnit/instructionFile/x
mem load -filltype value -filldata 000000000000000 -fillradix symbolic /processor/MemoryUnit/MyDataMemory/x(0)
add wave -position insertpoint  \
sim:/processor/clk \
sim:/processor/rst \
sim:/processor/inPort \
sim:/processor/curr_instr \
sim:/processor/deout \
sim:/processor/AluCCRout \
sim:/processor/mwbout
force rst 1
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/processor/inPort 1111111111111110 0
force rst 0
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
force -freeze sim:/processor/inPort 0000000000000001 0
run
force -freeze sim:/processor/inPort 0000000000001111 0
run
force -freeze sim:/processor/inPort 0000000011001000 0
run
force -freeze sim:/processor/inPort 0000000000011111 0
run
force -freeze sim:/processor/inPort 0000000011111100 0
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
