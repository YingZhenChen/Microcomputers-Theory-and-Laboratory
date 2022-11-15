
Main:
MOV a,#11111110b
SETB IT0
SETB EX0		; enable timer 0 interrupt
SETB EA			; set the global interrupt enable bit
 
Loop:
MOV P1,a ;move accumulator to port 2
RL a ;rotate left for accumulator
JB  P2.0, ext0ISR
SJMP Loop ;jump back to loop

; external 0 ISR
ext0ISR:
MOV P1,a ;move accumulator to port 2
RR a ;rotate right for accumulator
JNB  P2.0, Loop
SJMP ext0ISR ;jump back to ext0ISR
