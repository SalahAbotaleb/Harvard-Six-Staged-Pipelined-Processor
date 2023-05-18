.org 50
IN    R5                       #R5= FFFE --> add FFFE on the in port, flags no change   
NOP
LDM R5,9001        #R5 = 0001, C--> 0, N --> 0, Z --> 0
NOP     
NOP
.org 200
INC r5,R5                 #R5 = FFFF, C--> 0, N --> 1, Z --> 0
NOP
NOP
nop
.org 0
ret
inc R5     ,R5                 #R5 = 0000, C--> 1, N --> 0, Z --> 1
IN R1                        #R1= 0001 --> add 0001 on the in port, flags no change        
IN R2                        #R2= 000F -> add 000F on the in port, flags no change        
IN R3                        #R3= 00C8 -> add 00C8 on the in port, flags no change        
IN R4                        #R4=001F -> add 001F on the in port, flags no change
IN R5                        #R5=00FC -> add 00FC on the in port, flags no change        
NOP                                #Flags no change
STD R1,R2                  #M[1] = 000F  //R2 is data, R1 is the address
NOP
STD R3,R4                      #M[200] = 001F, R3 --> has value 00C8 which is 200 in decimal, 
NOP
STD R2,R5                  #M[15] = 00FC        
INC R2,R1                 #R2 = 0002, C--> 0, N --> 0, Z --> 0
LDD R0,R1                      #R0 = M[1] = 000F //R0 is the destination, R1 is the address (opposite to STD)
NOP
LDD R7,R3                      #R7 = M[200] = 001F
AND R1,R2,R6        #R1 = 0, C--> 0, N --> 0, Z --> 1
NOP
NOP
NOP
INC R1,R1                 #R1 = 0001, C--> 0, N --> 0, Z --> 0
NOP                        #Flags no change
AND R5,R3,R4        #R5 = 0008, C--> 0, N --> 0, Z --> 0
NOP                        #Flags no change, C--> 0, N --> 0, Z --> 0
NOP