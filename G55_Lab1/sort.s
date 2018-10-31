	.text
	.global _start
_start:
SETSTART:	LDR R2, N 			// R2 Holds the number of elements in the list
			LDR R4, SORTED		// R4 takes the sorted value
			LDR R3, =NUMBERS	// R3 holds the address of the list of numbers 
			ADD R1, R3, #4		// R1 points to the next value in the list

LOOP:		SUBS R2, R2, #1		// Decrement the loop counter
			BEQ CHECKSORT		// Go to check if sorted when zero
			LDR R5, [R1] 		// Load the value held in R1 into R5
			LDR R6, [R3] 		// Load the value held in R3 into R6
			CMP R5, R6 			// Compare values 
			BMI SWITCH 			// If the val before is bigger switch them
			B INCREMENT 		// Increment position in the list

SWITCH:		STR R5, [R3] 		// Store the value of R5 into the address at R3
			STR R6, [R1] 		// Store the value held in R6 into the address at R1
			ADD R4, R4, #1 		// Since we switched the array we increment sorted so its != 0

INCREMENT:	ADD R3, R3, #4 		// Set the address held in R3 to the next value in the list
			ADD R1, R1, #4 		// Select the next element in the list
			B LOOP 				// Go to Loop

CHECKSORT:	CMP R4, #0 			// Check if R4 still has its initial value (i.e. hasnt gone through SWITCH)
			BEQ END 			// If it is sorted go to the end
			B SETSTART 			// Else do another pass in the sorting loop

END: B END


SORTED:		.word 0
N: 			.word 8 
NUMBERS:	.word 4, 5, 3, 6
			.word 1, 8, 2, 5
