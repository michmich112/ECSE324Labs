		.text
		.equ HEX_BASE1, 0xFF200020
		.equ HEX_BASE2, 0xFF200030
		
		.global HEX_clear_ASM
		.global	HEX_flood_ASM
		.global HEX_write_ASM

HEX_flood_ASM:
		//R0 is going to contain the elements to flood
		//R1 is going to be used as our comparison register
		//R2 is going to hold our original value
		//R3 is going to hold the memory address
		
		// OREQ is used in our subrouting. it only exicutes if the flag is set to EQ (equal). reduces our need for branching

		LDR R3, =HEX_BASE2		//holds the mermory address of hexbase2
		LDR R2, [R3]			//holds the value that is stored in hexbase2
		BIC R1, R0, #32 		//32 in bin is 0100000
		CMP R1, #32
		OREQ R2, R2, 0x0000FF00 // 0x0FF00 is the equivalent of 0...01111111100000000 effectively flooding the data
		BIC R1, R0, #16			//16 in bin is 0010000
		CMP R1, #16
		OREQ R2, R2, 0x000000FF // 0x000FF is the equivalent of 0...00000000011111111 effectively flooding the data
		STR R2, R3 				// Store the new value in the correct memoryspace
		LDR R3, =HEX_BASE1 		//holds the memory address of hexbase1
		LDR R2, [R3]			//holds the value that is stored in hexbase1
		BIC R1, R0, #8
		CMP R1, #8
		OREQ R2, R2, 0xFF000000 // 0xFF000000 is the equivalent of 111111110...0 in bin effectively flooding the data
		BIC R1, R0, #4
		CMP R1, #4
		OREQ R2, R2, 0x00FF0000 // 0x00FF0000 is the equivalent of 00000000111111110...0 in bin effectively flooding the data
		BIC R1, R0, #2
		CMP R1, #2
		OREQ R2, R2, 0x0000FF00
		BIC R1, R0, #1
		CMP R1, #1
		OREQ R2, R2, 0x000000FF
		STR R2, R3				// Store the new value in the correct memory address
		BX LR					// Return to the execution

HEX_clear_ASM:
		// this is the same as HEX_flood_ASM but instead of doing an OREQ we do and BICEQ on the values to clear them

		LDR R3, =HEX_BASE2		//holds the mermory address of hexbase2
		LDR R2, [R3]			//holds the value that is stored in hexbase2
		BIC R1, R0, #32 		//32 in bin is 0100000
		CMP R1, #32
		BICEQ R2, R2, 0x0000FF00 // 0x0FF00 is the equivalent of 0...01111111100000000 effectively clearing the data
		BIC R1, R0, #16			//16 in bin is 0010000
		CMP R1, #16
		BICEQ R2, R2, 0x000000FF // 0x000FF is the equivalent of 0...00000000011111111 effectively clearing the data
		STR R2, R3 				// Store the new value in the correct memoryspace
		LDR R3, =HEX_BASE1 		//holds the memory address of hexbase1
		LDR R2, [R3]			//holds the value that is stored in hexbase1
		BIC R1, R0, #8
		CMP R1, #8
		BICEQ R2, R2, 0xFF000000 // 0xFF000000 is the equivalent of 111111110...0 in bin effectively clearing the data
		BIC R1, R0, #4
		CMP R1, #4
		BICEQ R2, R2, 0x00FF0000 // 0x00FF0000 is the equivalent of 00000000111111110...0 in bin effectively clearing the data
		BIC R1, R0, #2
		CMP R1, #2
		BICEQ R2, R2, 0x0000FF00
		BIC R1, R0, #1
		CMP R1, #1
		BICEQ R2, R2, 0x000000FF
		STR R2, R3				// Store the new value in the correct memory address
		BX LR					// Return to the execution



		