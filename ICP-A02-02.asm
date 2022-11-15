Begin:
mov R2,#11111110b
mov R3,#01111111b
mov a,R2
anl a,R3
Loop:
mov p1,a ;move accumulator to port 2
mov a,R2
rl a ;rotate left for accumulator
mov R2,a
mov a,R3
rr a ;rotate left for accumulator
mov R3,a
mov a,R2
anl a,R3
sjmp Loop ;jump back to loop