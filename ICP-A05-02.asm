Pre:
	MOV R1,#30H
	CLR 2FH.7


; ========= Subroutine ==============
; Name: keyPadScan
; Function: Scan the keypad. If a key is pressed, put the pressed key's key number in R0 and set F0.
;           If no key is pressed, clear F0.
; Input: No.
; Output: B = the key number of the pressed key.
;         F0 = 1 if  a key is pressed;
;         F0 = 0 if no key is pressed.

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
	MOV	 B,R0
	RET			; and return from subroutine


; ======= Technique for changing partial bits ==================
	ANL P0,#11110000B	; The effect of the ANL and ORL instructions is equivalent to 
	ORL P0,#00001101B	; | SETB P0.3; SETB P0.2; CLR P0.1; SETB P0.0
					; | The high nybble is not affected.