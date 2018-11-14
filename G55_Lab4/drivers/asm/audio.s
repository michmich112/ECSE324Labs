	.text

	.equ CONTROL_BASE, 0xFF203040
	.equ FIFOSPACE_BASE, 0xFF203044
	.equ LEFTDATA_BASE, 0xFF203048
	.equ RIGHTDATA_BASE, 0xFF20304C

	.global write_audio_data_ASM

// R0 = data
write_audio_data_ASM:
	PUSH {R1-R4}
	LDR R1, =FIFOSPACE_BASE
	LDR R2, [R1]				// R2 hold contents of Fifospace
	AND R3, R2, #0xFF000000		// R3 holds WSLC
	AND R4, R2, #0x00FF0000		// R4 holds WSRC
	CMP R3, #0					// Check if WSLC is full
	BEQ full
	CMP R4, #0					// Check if WSRC is full
	BEQ full
	LDR R3,	=LEFTDATA_BASE		// Point to left data
	LDR R4, =RIGHTDATA_BASE		// Point to right data
	STR R0, [R3]				// Store data in left 
	STR R0, [R4]				// Store data in right
	MOV R0, #1					// Return 1 cause valid
	POP {R1-R4}
	BX LR
	

full:
	MOV R0, #0					// Return 0
	POP {R1-R4}
	BX LR

	.end
