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

NOT R1,R2					# this instruction should be at address 21h
ADD R3,R1,R1					# this instruction should be at address 22h
IADD R4,R3,100 				# this instruction should be at address 23h & 24h, 100 is hex format (256 decimal)
OR R4,R3,R4
IADD R1,R2,100
IADD R5,R1,10

INC R5,R1						# this instruction should be at address 101h
PUSH R1						# this instruction should be at address 102h
POP R2						# this instruction should be at address 103h
NOT  R4,R2          					# this instruction should be at address 30H
OR R5,R4,R4