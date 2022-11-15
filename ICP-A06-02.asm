	ORG 0000H ;Reset
	LJMP MAIN
	ORG 0023H ;Serial port vector
	LJMP SPISR
	ORG 0030H ;Main program entry
MAIN: 
	CLR SM0			; |
	SETB SM1		; | put serial port in 8-bit UART mode

	MOV A, PCON		; |
	SETB ACC.7		; |
	MOV PCON, A		; | set SMOD in PCON to double baud rate

	MOV TMOD, #20H		; put timer 1 in 8-bit auto-reload interval timing mode
	MOV TH1, #243		; put -13 in timer 1 high byte (timer will overflow every 13 us)
	MOV TL1, #243		; put same value in low byte so when timer is first started it will overflow after 13 us
	SETB TR1		; start timer 1

	MOV 30H, #'a'		; |
	MOV 31H, #'b'		; |
	MOV 32H, #'c'		; | put data to be sent in RAM, start address 30H

	MOV 33H, #0		; null-terminate the data (when the accumulator contains 0, no more data to be sent)
	MOV R0, #30H		; put data start address in R0

	MOV SCON, #42H ; Mode 1. Set TI
	MOV IE, #90H ;enable serial port intrrrupt
	SJMP $ ;do nothing
SPISR: 
	MOV A, @R0		; move from location pointed to by R0 to the accumulator
	JNZ read		; if the accumulator contains 0, no more data to be sent, jump to finish
	JMP finish		; send next byte
finish:
	JMP $			; do nothing
read:
	MOV C, P		; otherwise, move parity bit to the carry
	;CPL C
	MOV ACC.7, C		; and move the carry to the accumulator MSB
	MOV SBUF, A		; move data to be sent to the serial port
	INC R0			; increment R0 to point at next byte of data to be sent
	;JNB TI, $		; wait for TI to be set, indicating serial port has finished sending byte
	CLR TI	
	RETI
	END