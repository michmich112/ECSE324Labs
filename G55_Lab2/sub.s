			.text
   			.global _start
_start:
			LDR R1, =NUMBERS	// R1 points to location of first number in list
			LDR R2, N			// R2 holds the number of elements
			LDR R0, [R1]   		// R0 holds the first number in the list
			PUSH {R0-R2, LR}	// PUSH Registers R0 to R2 & link register
			BL find_max			// Brand to find_max and store next intrustion in LR
			STR R0, RESULT		// Store max
			POP {R0-R2, LR}		// POP Registers R0 to R2 & link register
			B END

find_max:	PUSH {R4}			// Push R4 	
LOOP:		SUBS R2, R2 , #1	// Decrement Loop Counter
			BEQ RETURN			// End when finished
			ADD R1, R1, #4		// R1 points to next element
			LDR R4, [R1]		// Holds value of R4	
			CMP R0, R4			// Compare R0 - R4
			BGE LOOP   			// If greater or equal to 0, Loop
			MOV R0, R4			// Update max
			B LOOP
		

RETURN:		POP {R4}			// POP R4 to restore value
			BX LR				// Branch to LR

END:		B END				// Loop END


RESULT:   	.word    0
N:   		.word    7
NUMBERS:	.word    4, 2, 3, 6
   			.word    1, 8, 12
