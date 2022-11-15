Begin:
mov a,#01111111b ;led 1 lights up first.
Loop:
mov p1,a ;move accumulator to port 2
rr a ;rotate left for accumulator
sjmp Loop ;jump back to loop