; Title: Sine wave on scope
; Function: DIsplay a sine wave on the scope
; Data source:
;     Below the label "SIN_50" are 50 waveform points that constitute a cycle of sine wave. 
;
;
	CLR A
up: 
	MOV DPTR,#SIN_50
	MOV R0,#50
	CLR P0.7	; enable the DAC WR line
label:
	MOVC	A, @A+DPTR
	MOV P1, A	; move data in the accumulator to the ADC inputs (on P1)
	CLR A
	INC DPTR
	DJNZ R0,label
	SJMP up




SIN_50:      ; 50 points in a cycle of sinusoidal waveform
DB 128,144,160,175,190,203,216,227,236,244,250,254,255,255,254,250,244,236,227,216
DB 203,190,175,160,144,128,112, 96, 81, 66, 53, 40, 29, 20, 12,  6,  2,  0,  0,  2
DB 6, 12, 20, 29, 40, 53, 66, 81, 96,112
