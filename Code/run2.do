add wave *
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
force -freeze sim:/processor/interupt 0 0
mem load -i {C:/Users/Zahar/OneDrive - Cairo University - Students/CUFE/Junior/Term 2/Computer Archetiture/Project/Harvard-Six-Staged-Pipelined-Processor/Compiler/test10.mem} -update_properties /processor/FetchUnit/instructionFile/x
mem load -filltype value -filldata {1000000000000001 } -fillradix symbolic /processor/MemoryUnit/MyDataMemory/x(0)
mem load -filltype value -filldata {1000000111000001 } -fillradix symbolic /processor/MemoryUnit/MyDataMemory/x(1)

run
force rst 0
run