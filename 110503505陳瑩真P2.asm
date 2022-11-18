; Program title: "Testing TransmitOneByte.asm"
; Purpose: To check whether TransmitOneByte.asm is able to transmit one byte suceesfully.
;
          CLR SM0                     ; |
          SETB SM1                   ; | put serial port in 8-bit UART mode
 
          MOV A, PCON           ; |
          SETB ACC.7                ; |
          MOV PCON, A           ; | set SMOD in PCON to double Baud rate
 
          MOV TMOD, #20H            ; put timer 1 in 8-bit auto-reload interval timing mode
          MOV TH1, #243                 ; put ?13 in timer 1 high byte (timer will overflow every 13 us)
          MOV TL1, #243                  ; put same value in low byte so when timer is first started it will overflow after 13 us
          SETB TR1               ; start timer 1
main:
	MOV		A,#'P'
	CALL TransmitOneByte
	MOV		A,#'r'
	CALL	TransmitOneByte
	MOV		A,#'e'
	CALL	TransmitOneByte
	MOV		A,#'s'
	CALL	TransmitOneByte
	MOV		A,#'s'
	CALL	TransmitOneByte
	MOV		A,#'!'
	CALL	TransmitOneByte
	MOV		A,#' '
	CALL	TransmitOneByte
 	JMP	main


; Subroutine name: TransmitOneByte
; Function: Transmit an ASCII code 
; Input: Acc = the ASCII code to be transmitted
; Output: UART showing the ASCII CODE 
; Source: We implement this subroutine by transforming "Example 8.asm" of edsim51 into a subroutine. 
;
TransmitOneByte:
          MOV C, P               ; otherwise, move parity bit to the carry
          MOV ACC.7, C           ; and move the carry to the accumulator MSB
          MOV SBUF, A             ; move data to be sent to the serial port
          JNB TI, $                ; wait for TI to be set, indicating serial port has finished sending byte
          CLR TI                           ; clear TI
          RET
