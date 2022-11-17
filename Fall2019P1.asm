;count number of 1s
main:
	MOV A,#0C8H
	MOV R3,#0
	MOV R7,#8
	CALL numeralTest
	MOV A,#0FEH
	MOV R3,#0
	MOV R7,#8
	CALL numeralTest
	JMP $   ; do nothing but wait for interrupt

; ################################
; Please program the ISR "serialPortISR" below.
; --------------------------------



numeralTest:
	RRC A
	JNC Li
	INC R3
Li:
	DJNZ R7,numeralTest
	RET