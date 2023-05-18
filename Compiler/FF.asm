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

SETC						# this instruction should be at address 20h
NOT R1,R2					# this instruction should be at address 21h
INC R1,R3					# this instruction should be at address 22h
IADD R3,R2,100 				# this instruction should be at address 23h & 24h, 100 is hex format (256 decimal)
AND R4,R3,R4
RTI							# this instruction should be at address 25h

IN R1						# this instruction should be at address 100h
INC R1,R1						# this instruction should be at address 101h
PUSH R1						# this instruction should be at address 102h
POP R2						# this instruction should be at address 103h
LDM R3, 30					# this instruction should be at address 104h & 105h, 30 is 30h
JMP  R3						# this instruction should be at address 106h

NOT  R4,R4          					# this instruction should be at address 30H
OR R5,R4,R4