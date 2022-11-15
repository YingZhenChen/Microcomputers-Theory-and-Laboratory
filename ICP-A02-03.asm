start:
	SETB P3.3		; |
	SETB P3.4		; | enable display 3
	MOV P1, #10000000B	; put pattern for 1 on display
	CALL delay
	CLR P3.3		; enable display 2
	MOV P1, #10010000B	; put pattern for 2 on display
	CALL delay
	CLR P3.4		; |
	SETB P3.3		; | enable display 1
	MOV P1, #10001000B	; put pattern for 3 on display
	CALL delay
	CLR P3.3		; enable display 0
	MOV P1, #10000011B	; put pattern for 4 on display
	CALL delay
	JMP start		; jump back to start

; a crude delay
delay:
	MOV R0, #200
	DJNZ R0, $
	RET