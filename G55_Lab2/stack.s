			.text
   			.global _start
_start:
			MOV sp, #0x00000100	// Set the stack pointer
			MOV R0, #1			// Set R0 = 1 
			MOV R1, #2			// Set R1 = 2
			MOV R2, #3			// Set R3 = 3
			STR R0, [sp, #-4]!	// Store R0 in [sp - 4] then decrement stack by 4
			STR R1, [sp, #-4]!	// Store R1 in [sp - 4] then decrement stack by 4
			STR R2, [sp, #-4]!	// Store R2 in [sp - 4] then decrement stack by 4
			LDR R2, [sp], #4	// Load value at sp and increment stack by 4
			LDR R1, [sp], #4	// Load value at sp and increment stack by 4	
			LDR R0, [sp], #4	// Load value at sp and increment stack by 4		

END:		B END
