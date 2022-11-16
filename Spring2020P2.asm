;
; The "main" section is used to test the subroutine.
;
main:
	MOV	A,#00001111B
	CALL	bitReverse
	MOV	R0,A		; Expected R0 = 11110000B (F0H)
	MOV R7,#4
	MOV	A,#11000101B
	CALL	bitReverse
	MOV	R1,A		; Expected R1 = 10100011B (A3H)

	JMP	$


; ------------- Subroutine -----------------
; Subroutine name : bitReverse 
; Function:  Reverse the bits in Acc
; Input:   Acc
; Output:  Acc
; Example:
;          Input Acc          Output Acc
;          ---------          ----------
;          00001111B (0FH)    11110000B (F0H)
;          11000101B (C5H)    10100011B (A3H)
;


bitReverse:
	MOV R7,#0
	RLC A
	MOV B,A
	MOV	A,R7
	MOV Acc.0,C
	MOV R7,A
	MOV A,B

	RLC A
	MOV B,A
	MOV	A,R7
	MOV Acc.1,C
	MOV R7,A
	MOV A,B

	RLC A
	MOV B,A
	MOV	A,R7
	MOV Acc.2,C
	MOV R7,A
	MOV A,B

	RLC A
	MOV B,A
	MOV	A,R7
	MOV Acc.3,C
	MOV R7,A
	MOV A,B

	RLC A
	MOV B,A
	MOV	A,R7
	MOV Acc.4,C
	MOV R7,A
	MOV A,B

	RLC A
	MOV B,A
	MOV	A,R7
	MOV Acc.5,C
	MOV R7,A
	MOV A,B

	RLC A
	MOV B,A
	MOV	A,R7
	MOV Acc.6,C
	MOV R7,A
	MOV A,B

	RLC A
	MOV B,A
	MOV	A,R7
	MOV Acc.7,C

	RET
