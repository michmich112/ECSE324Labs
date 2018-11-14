	.text

	.equ PIXEL_BASE, 0xC8000000
	.equ CHAR_BASE, 0xC9000000

	.global VGA_clear_charbuff_ASM
	.global VGA_clear_pixelbuff_ASM
	.global VGA_write_char_ASM    
	.global VGA_write_byte_ASM    
	.global VGA_draw_point_ASM

	.equ Three_twenty, 320
	.equ Three_nineteen, 319

	
VGA_clear_charbuff_ASM:
	PUSH {R0-R4}
	LDR R0, =CHAR_BASE
	MOV R1, #-1			// X counter
	MOV R2, #0			// Y counter
	MOV R3, #0			// Clear value
	
clearcharX:
	ADD R1, R1, #1	 	// increment x counter
	CMP R1, #80	
	BEQ end_char_clear	// Once end is reached clear is done
	MOV R2, #0			// reset Y counter to 0

clearcharY:
	CMP R2, #60 
	BEQ clearcharX		// After clearing column go to next X
	LSL R4, R2, #7		// R4 gets the y value and shift by 7 bits so its in Y part of address
	ORR R4, R4, R1		// Get correct x and y parts of address
	ADD R4, R4, R0		// Add base address
	STRB R3, [R4]		// set address to 0
	ADD R2, R2, #1		// increment y counter
	B clearcharY

end_char_clear:
	POP {R0-R4}
	BX LR



VGA_clear_pixelbuff_ASM:
	PUSH {R0-R6}
	LDR R0, =PIXEL_BASE
	MOV R1, #-1			// X counter
	MOV R2, #0			// Y counter
	MOV R3, #0			// Clear value
	MOV R6, #320
	//LDR R6, =Three_twenty
	
	
clearpixX:
	ADD R1, R1, #1	 	// increment x counter
	CMP R1, R6
	BEQ end_pix_clear	// Once end is reached clear is done
	MOV R2, #0			// reset Y counter to 0

clearpixY:
	CMP R2, #240 
	BEQ clearpixX		// After clearing column go to next X
	LSL R4, R2, #10		// Get y value and shift by 10 bits so its in Y part of address
	LSL R5, R1, #1		// Get x value in X part of address
	ADD R4, R4, R5		// Add correct x parts of address
	ADD R4, R4, R0		// Add base address
	STRH R3, [R4]		// set address to 0
	ADD R2, R2, #1		// increment y counter
	B clearpixY

end_pix_clear:
	POP {R0-R6}
	BX LR



//R0 = x, R1 = y, R2 = char
VGA_write_char_ASM:
	PUSH {R0-R3}

	// Check if x is a valid input
	CMP R0, #0
	BLE done_char
	CMP R0, #79 
    BGE done_char
	
	// Check if y is a valid input
	CMP R1, #0
	BLE done_char
	CMP R1, #59 
    BGE done_char
	
	LDR R3, =CHAR_BASE
	LSL R1, #7			// Place y component in proper place
	ADD R1, R1, R0		// Add y and x component
	ADD R4, R1, R3		// Add base address component
	STRB R2, [R4]		// store char

done_char:
	POP {R0-R3}
	BX LR



//R0 = x, R1 = y, R2 = byte
VGA_write_byte_ASM:
	PUSH {R0-R7}	

	// Check if x is a valid input
	CMP R0, #0
	BLT done_byte
	CMP R0, #79 
    BGT done_byte
	
	// Check if y is a valid input
	CMP R1, #0
	BLT done_byte
	CMP R1, #59 
    BGT done_byte

	LSL R1, R1, #7	 		// shift y component so it is in the proper place
	LDR R3, =CHAR_BASE 
	ADD R1, R1, R0 			// Add y to x value
	ADD R7, R1, R3			// Get proper address
	
	LDR R4, =ASCII_CHAR 	// Point to character array
	MOV R5, R2 
	LSR R5, #4 				// Get first byte
	LDRB R6, [R4, R5] 		// find proper ASCII value the byte corresponds with
	STRB R6, [R7] 			// Store first byte	
	ADD R7, R7, #1 			// Increment x component of address 
	MOV R5, R2 
	AND R5, #0xF 			// Get second byte
	LDRB R6, [R4, R5] 		// find proper ASCII value the byte corresponds with
	STRB R6, [R7] 			// Store second byte		
	B done_byte

done_byte:
	POP {R0-R7}
	BX LR


// R0 = x, R1 = y, R2 = colour
VGA_draw_point_ASM:

	PUSH {R0-R5}
	LDR R4, =Three_twenty

	// Check if x is a valid input
	CMP R0, #0
	BLT done_draw
	CMP R0, R4				// R4 = 320
    BGE done_draw
	
	// Check if y is a valid input
	CMP R1, #0
	BLT done_draw
	CMP R1, #239 
    BGT done_draw

	LDR R3, =PIXEL_BASE
	LSL R4, R1, #10			// Get y value and shift by 10 bits so its in Y part of address
	LSL R5, R0, #1			// Get x value in X part of address
	ADD R5, R4, R5 			// Add x component
	ADD R5, R5, R3			// Add y component
	STRH R2, [R5]			// store colour

done_draw:
	POP {R0-R5}
	BX LR


ASCII_CHAR:	.byte 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 65, 66, 67, 68, 69, 70	// 0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F

	.end
