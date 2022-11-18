; Program name: "Testing keyNum2Ascii.asm"
; Purpose: To test whether the subroutine "keyNum2Ascii" generates correct ASCII code in register B.
main:
CLR P2.0                                      	
; Open SW0
MOV A,#1H
CALL keyNum2ascii ; B = 30H = '0'
MOV A,#2H
CALL keyNum2ascii ; B = 2AH = '*'
MOV A,#3H
CALL keyNum2ascii ; B = 39H = '9'
; Close SW0
MOV A,#1H
CALL keyNum2ascii ; B = 2FH = '/'
MOV A,#2H
CALL keyNum2ascii ; B = 2DH = '-'
MOV A,#3H
CALL keyNum2ascii ; B = 5EH = '^'
 
JMP         	main
 
 
 
; Subroutine name: keyNum2Ascii
; Function: Convert a key number to the ASCII code of the corresponding key symbol
; Input: Acc = key number, SW0 = open or closed
; Output: If SW0 is open,   register B = ASCII code of the original key symbol
;             If SW0 is closed, register B = ASCII code of the extended key symbol
keyNum2Ascii:
    MOV R0,A
    DEC R0
    JB P2.0 ,ext
orig:
    MOV DPTR,#asciiOrig
    CALL movDptr    
    MOVC A,@A+DPTR
    MOV B,A
    RET
ext:
    MOV DPTR,#asciiExt
    CALL movDptr
    MOVC A,@A+DPTR
    MOV B,A
    RET
movDptr:
    DJNZ R0,finish
    
    INC DPTR
    CALL movDptr
finish:
    RET
keyNum:
    db 0H,1H,2H,3H,4H,5H,6H,7H,8H,9H,0AH,0BH       	; Key number
asciiOrig:
    db '#','0','*','9','8','7','6','5','4','3','2','1' ; ASCII code of key symbol
asciiExt:
    db '=','/','-','^','x','+','F','E','D','C','B','A' ; ASCII code of extended key symbol
