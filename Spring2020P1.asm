ORG 0
	JMP main 
ORG 0023H 			  ; serial port interrupt vector
	JMP serialPortISR ; jump to serial port ISR

ORG 0030H ; main program entry point
main:
	MOV TMOD, #20H ; timer 1 in 8-bit auto-reload timer mode
	MOV TH1, #0FDH ; high byte value to generate baud rate of 9600
	mov A, PCON		; |
	setb ACC.7		; |
	mov PCON, A		; | set SMOD in PCON to double baud rate (19200)
	SETB TR1 ; start timer 1
	CLR SM0
	SETB SM1 ;  puts serial port into mode 1
	SETB REN ; receiver ?ISR ISRISRiii - This bit must be set to enable data receiving.
	SETB ES ; enable serial port interrupts
	SETB EA ; global interrupt enable

	JMP $   ; do nothing but wait for interrupt

; ################################
; Please program the ISR "serialPortISR" below.
; --------------------------------
serialPortISR:
	inc R2
	JNB RI,testTI
	inc R3
	CLR RI


	MOV A, SBUF
	MOV R1,A
	push Acc
	MOV R7,#07H
	MOV R5,#00H
	CLR Acc.7
	CALL numeralTest
	pop Acc
	MOV SBUF, R5

	JMP endSerialPortISR		; if it is the terminating character, jump to the end of the program

testTI:
	inc R4
	JNB TI,endSerialPortISR
	CLR TI
endSerialPortISR:
	RETI		; do nothing

numeralTest:
	RRC A
	JNC Li
	INC R5
Li:
	DJNZ R7,numeralTest
	RET

