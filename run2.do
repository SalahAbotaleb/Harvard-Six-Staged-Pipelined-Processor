add wave *
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/interupt 0 0
mem load -i {C:/Users/Zahar/OneDrive - Cairo University - Students/CUFE/Junior/Term 2/Computer Archetiture/Project/Harvard-Six-Staged-Pipelined-Processor/Compiler/test8.mem} -update_properties /processor/FetchUnit/instructionFile/x
run
force rst 0
run