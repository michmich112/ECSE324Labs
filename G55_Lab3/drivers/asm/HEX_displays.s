		.text
		.equ HEX_BASE1, 0xFF200020
		.equ HEX_BASE2, 0xFF200030

		// Mapping for ints to display codes
		.equ DISPLAY_ZERO, #63
		.equ DISPLAY_ONE, #3
		.equ DISPLAY_TWO, #91
		.equ DISPLAY_THREE, #79
		.equ DISPLAY_FOUR, #102
		.equ DISPLAY_FIVE, #109
		.equ DISPLAY_SIX, #125
		// Since 7 in binary is the correct display code we just skip this
		.equ DISPLAY_EIGHT, #127
		.equ DISPLAY_NINE, #103
		.equ DISPLAY_A, #119
		.equ DISPLAY_B, #127
		.equ DISPLAY_C, #57
		.equ DISPLAY_D, #63
		.equ DISPLAY_E, #121
		.equ DISPLAY_F, #113
		
		.global HEX_clear_ASM
		.global	HEX_flood_ASM
		.global HEX_write_ASM

// R0 = valuemapping
// R1 = template
// R2 = counter 1
// R3 = OG Values
// R4 = new value

MAIN_LOOP:
		CMP R2, #7 									//Compare the value in our counter with 7 (which would be what it would equal to after 2 shifts)
		BEQL SET_VALUES_HEXBASE2  	//If R2 = 7 then we store the value in R4 into HEX_BASE_2, this loads the next instruction into LR
		CMP R2, #0									//Compare to see if the value in R2 is 0, in that case we are done looping and should put the value in R4 into HEX_BASE1
		BEQ SET_VALUES_HEXBASE1
		LSL R4, #8									// We shift the new Value in R4 By 8 bits to have 8 - 0 valued bits to work with
		CMP R0, R2 									// We compare the values in R0 and R2 to see if there is a 1 at the bit of interest
		BLE SET_OG									// IF its Less than or equal then we can directly set the new value for the 8 bits to be the Original values stored in the HEX_BASE
		LDR R5, R2									// We copy our counter value into R5 
		ADD R5, R5, #1							// We increment the copied counter value by one to get the bit of interest to be one
		EOR R0, R0, R5							// We use exclusive or to set the bit of interest in the value mapping to 0 and preserve the rest of the bits (incrementing the value mapping if you want to see it that way)
		EOR R4, R4, R1 							// Since there was a 1 we apply the template (stored in R1 to the new Value)
		B SET_NEXT_LOOP

SET_OG:
		LDR R5, R3									// Copy the Original value into R5
		AND R5, R5, #255						// We want 24 Zeros Followed with 8 ones for the end so we only have the final 8 bits to deal with
		EOR R4, R4, R5							// We set in R4 the value or R4 && R5 which is equivalent to copying the last 8 bits of R5 into the last 8 bits of R4

SET_NEXT_LOOP:
		LSR R2, #1									// We shift the counter to the right which allows us to make our program function
		B MAIN_LOOP									// Branches back to the main loop


SET_VALUES_HEXBASE2:
		STR R4, HEX_BASE2						// Set the current new value into the HEX_BASE2 location ( HEX4 - HEX5 )
		LDR R4, #0 									// Reset The new value to be empty ( not necessary but helps )
		BX													// Branch back to the next instruction in LR

SET_VALUES_HEXBASE1:
		STR R4, HEX_BASE1						// Set the current new value into the HEX_BASE1 Location (HEX0 - HEX3)
		.end												// We have finished upating everything once we reach this point


HEX_clear_ASM:
		LDR R1, #0									// for clear the template will be all 0's
		LDR R2, #63									// We set the counter to 63 which is 6 1's as the LSBs
		B MAIN_LOOP									// We branch to the main loop to start updating the values
		

HEX_flood_ASM:
		LDR R1, #127								// for flood the template will be 25 0's and 7 1's
		LDR R2, #63									// We set the counter to 63 which is 6 1's as the LSBs
		B MAIN_LOOP									// We branch to the main loop to start updating the values

HEX_write_ASM:
		LDR R2, #63									// We set the counter to 63 which is 6 1's as the LSBs
		
		// We map the interger to the correct template
		CMP R1, #15				
		BEQ SET_DISPLAY_F
		CMP R1, #14
		BEQ SET_DISPLAY_E
		CMP R1, #13
		BEQ SET_DISPLAY_D
		CMP R1, #12
		BEQ SET_DISPLAY_C
		CMP R1, #11
		BEQ SET_DISPLAY_B
		CMP R1, #10
		BEQ SET_DISPLAY_A
		CMP R1, #9
		BEQ SET_DISPLAY_NINE
		CMP R1, #8
		BEQ SET_DISPLAY_EIGHT
		CMP R1, #7
		BEQ MAIN LOOP 							// since 7 in binary is the correct template we just loop to the main loop
		CMP R1, #6
		BEQ SET_DISPLAY_SIX
		CMP R1, #5
		BEQ SET_DISPLAY_FIVE
		CMP R1, #4
		BEQ SET_DISPLAY_FOUR
		CMP R1, #3
		BEQ SET_DISPLAY_THREE
		CMP R1, #2
		BEQ SET_DISPLAY_TWO
		CMP R1, #1
		BEQ SET_DISPLAY_ONE
		CMP R1, #0
		BEQ SET_DISPLAY_ZERO

SET_DISPLAY_ZERO:
		LDR R1, DISPLAY_ZERO
		B MAIN_LOOP

SET_DISPLAY_ONE:
		LDR R1, DISPLAY_ONE
		B MAIN_LOOP

SET_DISPLAY_TWO:
		LDR R1, DISPLAY_TWO
		B MAIN_LOOP

SET_DISPLAY_THREE:
		LDR R1, DISPLAY_THREE
		B MAIN_LOOP

SET_DISPLAY_FOUR:
		LDR R1, DISPLAY_FOUR
		B MAIN_LOOP

SET_DISPLAY_FIVE:
		LDR R1, DISPLAY_FIVE
		B MAIN_LOOP

SET_DISPLAY_SIX:
		LDR R1, DISPLAY_SIX
		B MAIN_LOOP

SET_DISPLAY_EIGHT:
		LDR R1, DISPLAY_EIGHT
		B MAIN_LOOP

SET_DISPLAY_NINE:
		LDR R1, DISPLAY_NINE
		B MAIN_LOOP

SET_DISPLAY_A:
		LDR R1, DISPLAY_A
		B MAIN_LOOP

SET_DISPLAY_B:
		LDR R1, DISPLAY_B
		B MAIN_LOOP

SET_DISPLAY_C:
		LDR R1, DISPLAY_C
		B MAIN_LOOP

SET_DISPLAY_D:
		LDR R1, DISPLAY_D
		B MAIN_LOOP

SET_DISPLAY_E:
		LDR R1, DISPLAY_E
		B MAIN_LOOP

SET_DISPLAY_F:
		LDR R1, DISPLAY_F
		B MAIN_LOOP