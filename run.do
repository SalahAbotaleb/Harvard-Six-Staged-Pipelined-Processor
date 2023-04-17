restart
mem load -i C:/university/Arch/Harvard-Six-Staged-Pipelined-Processor/testcase.mem -startaddress 0 -endaddress 18 /processor/FetchUnit/instructionFile/x
force rst 1
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
run
force -freeze sim:/processor/inPort 0010001001000100 0
force rst 0
run