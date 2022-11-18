ORG 13H			; external 1 interrupt vector
	JMP ext1ISR		; jump to the external 1 ISR
Pre:
	MOV R1,#30H
	CLR 2FH.7
	SETB IT1		; set external 1 interrupt as edge-activated
	SETB EX1		; enable external 1 interrupt
	SETB EA			; set the global interrupt enable bit
	JMP $			; jump back to the same line (ie: do nothing)

; ========= Subroutine ==============
; Name: keyPadScan
; Function: Scan the keypad. If a key is pressed, put the pressed key's key number in R0 and set F0.
;           If no key is pressed, clear F0.
; Input: No.
; Output: B = the key number of the pressed key.
;         F0 = 1 if  a key is pressed;
;         F0 = 0 if no key is pressed.
ext1ISR:
	CALL keyPadScan
	RETI			; return from interrupt
keyPadScan:
 	MOV R0, #0		; clear R0 - the first key is key0
	; scan row0
	ANL P0,#11110000B	; The effect of the ANL and ORL instructions is equivalent to 
	ORL P0,#00001110B	; | SETB P0.3; SETB P0.2; SETB P0.1; CLR P0.0
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
				; | (because the pressed key was found and its number is in  R0)

	; scan row1
	ANL P0,#11110000B	; The effect of the ANL and ORL instructions is equivalent to 
	ORL P0,#00001101B	; | SETB P0.3; SETB P0.2; CLR P0.1; SETB P0.0
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
				; | (because the pressed key was found and its number is in  R0)

	; scan row2
	ANL P0,#11110000B	; The effect of the ANL and ORL instructions is equivalent to 
	ORL P0,#00001011B	; | SETB P0.3; CLR P0.2; SETB P0.1; SETB P0.0
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
				; | (because the pressed key was found and its number is in  R0)

	; scan row3
	ANL P0,#11110000B	; The effect of the ANL and ORL instructions is equivalent to 
	ORL P0,#00000111B	; | CLR P0.3; SETB P0.2; SETB P0.1; SETB P0.0
	CALL colScan		; call column-scan subroutine
	JB F0, finish		; | if F0 is set, jump to end of program 
						; | (because the pressed key was found and its number is in  R0)
	CLR 2FH.7
	JMP keyPadScan
finish:
	JB 2FH.7, keyPadScan
	MOV @R1,AR0
	INC R1
	SETB 2FH.7
	JMP keyPadScan
; column-scan subroutine
colScan:
	CLR	F0
	JNB P0.4, gotKey	; if col0 is cleared - key found
	INC R0			; otherwise move to next key
	JNB P0.5, gotKey	; if col1 is cleared - key found
	INC R0			; otherwise move to next key
	JNB P0.6, gotKey	; if col2 is cleared - key found
	INC R0			; otherwise move to next key
	RET			; return from subroutine - key not found
gotKey:
	SETB F0			; key found - set F0
	MOV	 A,R0
	CALL keyNum2Ascii
	CALL TransmitOneByte
	RET			; and return from subroutine


; ======= Technique for changing partial bits ==================
	ANL P0,#11110000B	; The effect of the ANL and ORL instructions is equivalent to 
	ORL P0,#00001101B	; | SETB P0.3; SETB P0.2; CLR P0.1; SETB P0.0
					; | The high nybble is not affected.

TransmitOneByte:
Initialize:
	  MOV A,B
	  PUSH Acc
          CLR SM0                  ; |
          SETB SM1                 ; | put serial port in 8-bit UART mode
          MOV A, PCON        ; ~
          SETB ACC.7           ; ~
          MOV PCON, A         ; ~ set SMOD in PCON to double Baud rate
SetupTimer1:
          MOV TMOD, #20H      ;= put timer 1 in 8-bit auto-reload interval timing mode
          MOV TH1, #243          ;= put ?13 in timer 1 high byte (timer will overflow every 13 us)
          MOV TL1, #243          ;= put same value in low byte so when timer is first started it will overflow after 13 us
          SETB TR1                  ;= Start timer 1
Transmit:
          POP Acc
          MOV C, P               ;* move parity bit to the carry
          MOV Acc.7, C        ;* and move the carry to the accumulator MSB
          MOV SBUF, A        ;* move data to be sent to the serial port
          JNB TI, $                ;* wait for TI to be set, indicating serial port has finished sending byte
ResetFlags:
          CLR TI                   ; clear TI
	  CLR TR1                ;= Stopr Timer 1
          RET
keyNum2Ascii:
PUSH	Acc

JNB		P2.0,SW0_closed
SW0_open:
MOV		DPH,#high(asciiOrig)
MOV		DPL,#low(asciiOrig)
JMP		getAsciiCode
SW0_closed:
MOV		DPH,#high(asciiExt)
MOV		DPL,#low(asciiExt)
getAsciiCode:
MOVC	A,@A+DPTR
MOV		B,A
POP		Acc
RET

keyNum:
    db 0H,1H,2H,3H,4H,5H,6H,7H,8H,9H,0AH,0BH           ; Key number
asciiOrig:
    db '#','0','*','9','8','7','6','5','4','3','2','1' ; ASCII code of key symbol
asciiExt: 
    db '=','/','-','^','x','+','F','E','D','C','B','A' ; ASCII code of extended key symbol