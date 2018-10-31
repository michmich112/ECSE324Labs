			.text
			.global _start
_start:
			LDR R4, =RESULT		// R4 holds location of RESULT
			LDR R2, [R4, #4]	// R2 holds the number of elements in the list
			ADD R3, R4, #8		// R3 point to the first number
			LDR R0, [R3]		// Holds first number in the list
			LDR R5, [R3]		// Stores max value 
			LDR R6, [R3]		// Stores min value

LOOP:		SUBS R2, R2, #1		// Decrements number of elements
			BEQ DONE			// Branch to DONE when done looping
			ADD R3, R3, #4		// R3 points to the next value in the list
			LDR R1, [R3]		// R1 stores the value of R3
			CMP R5, R1			// Compare the max value and the new value of R1
			BGE FINDMIN			// If max is greater than or equal, branch to FINDMIN
			MOV R5, R1			// If greater switch R1 to max
			B LOOP				// Branch to LOOP

FINDMIN:    CMP R1, R6			// Compare the R1 with min
			BGE LOOP			// If R1 is greater or equal than min branch to LOOP
			MOV R6, R1			// If R1 is less than min, store R1 in R6
			B LOOP				// Branch to LOOP

DONE:		SUBS R1, R5, R6 	// Subtract the max value by the min value
			LSR R4, R1, #2		// Divide the difference by 4 and store in R4

END:		B END				// End

RESULT:		.word	0
N:			.word	8
NUMBERS:	.word	4, 5, 3, 6
			.word	2, 8, 2, 18

