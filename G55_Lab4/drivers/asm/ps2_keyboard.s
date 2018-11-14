	.text
	.equ PS2_DATA_BASE, 0xFF200100
	.equ PS2_CONTROL_BASE, 0xFF200104
	.global read_PS2_data_ASM

// R0 = data
read_PS2_data_ASM:
	PUSH {R1-R5}
	LDR R1, =PS2_DATA_BASE
	LDR R2, [R1]			// R2 hold ps2's data
	AND R3, R2, #0x8000		// Check 15th bit if valid
	CMP R3, #0
	BEQ INVALID				// If invalid return 0
	STRB R2, [R0]			// Store data in address 
	MOV R0, #1				// Return 1 to show it is valid
	POP {R1-R5}
	BX LR

INVALID:
	MOV R0, #0				// return 0 
	POP {R1-R5}
	BX LR

	.end
