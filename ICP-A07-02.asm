; Title: ICP-A07-02 = Transmit a numeral ASCII after receiving it from serial input (at 19200 bps)- template
; Note: When you run this program, set the system clock at 11.059 MHz and baud rate at 19200 bps.
; Note: In this template, the content of the ISR "serialPortISR" and the subroutine "numeralTest" ae empty.
;       You need to program these two parts.
; Note: When this program runs, serial tansmission and receiving can happen simulaneously.
;       Hence, the ISR "serialPortISR" needs to be able to handle the two serial interrupt flags TI and RI.


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
	CLR Acc.7
	CALL numeralTest
	pop Acc

	JNC endSerialPortISR
 

	MOV SBUF, R1

	JMP endSerialPortISR		; if it is the terminating character, jump to the end of the program
testTI:
	inc R4
	JNB TI,endSerialPortISR
	CLR TI
endSerialPortISR:
	RETI		; do nothing

numeralTest:
	SUBB A, #'0'  ;  A = a - '0'
	CLR  C
	MOV  R0, A    ; R2 = a - '0'
	MOV A, #9    ;  A = '9' - '0'
	SUBB A, R0    ;  C = 1 if ('9' - '0') < (a - '0')
	CPL C
	RET

