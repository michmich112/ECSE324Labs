		.text
		.equ HEX_BASE1, 0xFF200020
		.equ HEX_BASE2, 0xFF200030
		.global HEX_clear_ASM
		.global	HEX_flood_ASM
		.global HEX_write_ASM

//R0 = valuemappig
//r1 = template
//r2 = counter
//r3 = OG Values
		



START:
	LDR R3, HEX_BASE1
	LDR R2, #31
	


FIND_HEXS:
		LDR R1, R0
		CMP R1, #15
		BGT SET_ALL
		B SET_RIGHT 

SET_ALL:
		LDR R1, =HEX_BASE2
		LDR R2, #6
		BX LR

SET_RIGHT:
		LDR R1 =HEX_BASE1
		LDR R2, #4
		BX LR

HEX_clear_ASM:
		BL FIND_HEXS
		

		
	
