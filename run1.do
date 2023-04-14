force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
run
force rst 0
mem load -filltype value -filldata {1111010011011100 } -fillradix symbolic /processor/FetchUnit/instructionFile/x(0)
mem load -filltype value -filldata {0000000011110000 } -fillradix symbolic /processor/RegFile/x(3)
mem load -filltype value -filldata {000000011000000 } -fillradix symbolic /processor/RegFile/x(6)
mem load -filltype value -filldata {1100000000000000 } -fillradix symbolic /processor/RegFile/x(7)
run