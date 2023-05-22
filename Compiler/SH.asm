#########################################################
#        All numbers are in hex format   				#
#########################################################
#########################################################
#        We always start by reset signal 				#
#########################################################
#         This is a commented line
#        You should ignore empty lines and commented ones
# ---------- Don't forget to Reset before you start anything ---------- #


.org 0						#means the next line is at address 0 (hex)
2							# data value 100hex so memory content M[0]=100h
.org 1
20							# data value 20hex so memory content M[1]=20h

IADD R4,R4,1
LDD R7,R4
LDD R4,R3
STD R4,R0
STD R7,R0
LDD R5,R3
LDM R0,1