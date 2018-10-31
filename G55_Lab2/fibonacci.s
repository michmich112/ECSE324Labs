			.text
			.global _start
_start:		
			LDR R0, N				// R0 holds contents of N 
			SUB R0, R0, 1			// To take into account the
			MOV R1, #0				// initialize
			MOV R2, #0				// initialize
			PUSH {R0, R1, R2, LR}	// Push R0 - R2 and LR 
			BL FIB					// Branch to fib and save next intrusction in LR
			STR R0, RESULT			// Store result
			POP {R0, R1, R2, LR}	// Restore registers to original values
			B END					// branch to end loop

FIB:		PUSH {LR}				// Push LR
			CMP R0, #2				// Compare R0 - 2
			BLT isOne				// If N is less than 2 result is 1
			SUB R1, R0, #1			// F(n-1)
			SUB R2, R0, #2			// F(n-2)
			PUSH {R2}				// Store n-2
			MOV R0, R1				// change recursion conditional to n-1
			BL FIB					// recursion for F(n-1)
			POP {R2}				// R2 holds n-1
			PUSH {R0}				// store value for f(n-1)
			MOV R0, R2				// change recursion conditional to n-2
			BL FIB					// recursion for F(n-2)		
			MOV R2, R0				// set R2 to value of F(n-2)
			POP {R1}				// Pop the value of F(n-1) to R1 
			ADD R0, R1, R2			// F(n-1) + F(n-2)
			POP {LR}				
			BX LR					// Branch back to caller

isOne:		MOV R0, #1				// Set result to 1
			POP {LR}
			BX LR					// Branch back to caller

END:		B END

N:			.word	7
RESULT: 	.word	0
