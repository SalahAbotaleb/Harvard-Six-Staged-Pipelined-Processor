restart
mem load -i C:/university/Arch/Harvard-Six-Staged-Pipelined-Processor/finaltc.mem -startaddress 0 -endaddress 32 /processor/FetchUnit/instructionFile/x
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
force -freeze sim:/processor/inPort 0010001001000100 0
force rst 0
run