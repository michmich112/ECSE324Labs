			.text
			.global _start
_start:
			LDR R5, =COUNTER	// R5 points to counter location	
			LDR R4, AVERAGE		// R4 holds the average average	
			LDR R2, N			// R2 holds the number of elements in the list
			LDR R3, =NUMBERS	// R3 points to the first number
			LDR R0, [R3]		// R0 holds the first number in the list
			ADD R2, R2, #1		// Add one to the number of elements to correct for decrementation	

LOOP:		SUBS R2, R2, #1		// Decrement list counter by 1
			BEQ SGETAVG			// Get average when counter equals zero
			ADD R4, R4, R0		// Adds the past sum with R0
			ADD R3, R3, #4		// R3 points to next element in the list
			LDR R0, [R3]		// R0 holds the next value in the list
			B LOOP				// loop backs

SGETAVG:	LDR R2, N			// R2 holds the number of elements in the list
			LDR R6, [R5]		// R6 holds the value of counter
GETAVG:		SUBS R1, R2, R6		// Subtract number of elements by the counter
			BEQ STRCENTER		// Once average is found start centering
			LSL R6, R6, #1		// Left shift counter by 1
			LSR R4, R4, #1		// Right shift sum by 1
			B GETAVG			// Branch to GETAVG

STRCENTER:	LDR R2, N 			// R2 holds the number of elements in the list
			LDR R3, =NUMBERS	// R3 points to the first number
			ADD R2, R2, #1		// Add one to the number of elements to correct for decrementation
CENTER:		SUBS R2, R2, #1		// Decrement list counter by 1
			BEQ END				// Done once centered
			LDR R0, [R3]		// R0 holds the number in the list
			SUBS R1, R0, R4		// Subtract number by average
			STR R1, [R3]		// Store the difference back into R3
			ADD R3, R3, #4		// R3 points to the next value in the list
			B CENTER			// Loop back

END:		B END


COUNTER:	.word 1
AVERAGE:	.word 0
N:			.word 8 
NUMBERS:	.word 4, 5, 3, 6
			.word 1, 8, 2, 5

