Main:
; The purpose of the main program is to test the subroutine numeralTest.
; If the subroutine is correct, you will get [P1.3 P1.2 P1.1 P1.0] = [ 0 1 0 1].
;
; Test '0'

	MOV	A,#'0'
	CALL 	numeralTest	; Output: C = 1
	MOV	P1.0,C
; Test 'h'
	MOV	A,#'h'
	CALL 	numeralTest	; Output: C = 0
	MOV	P1.1,C
; Test '8'
	MOV	A,#'8'
	CALL 	numeralTest	; Output: C = 1
	MOV	P1.2,C
; Test '&'
	MOV	A,#'&'
	CALL 	numeralTest	; Output: C = 0
	MOV	P1.3,C
	NOP
	JMP	$



; [ICP-A07-01
; Subroutine name: numeralTest
; Learning object: To learn the encoding of ASCII code
; Function: 
;      This subroutine tests whether the accumulator contains the ASCII code
;      of a numeral symbol (i.e., 0, 1, 2, ..., or 9). 
; Input: Acc = the code to be tested.
; Output: C = 1, if '0' =< Acc =< '9' and
;            C = 0, otherwise.
; Note: '0' = 30H, '1' = 31H, ..., '9' = 39H      
;                      
numeralTest:
	SUBB A, #'0'  ;  A = a - '0'
	CLR  C
	MOV  R1, A    ; R1 = a - '0'
	MOV  A, #9    ;  A = '9' - '0'
	SUBB A, R1    ;  C = 1 if ('9' - '0') < (a - '0')
	CPL C
	RET

	
	