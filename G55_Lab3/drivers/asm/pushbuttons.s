//    .text
//
//    .equ DATA_REGISTER_BASE, 0xFF200050
//    .equ INT_MASK_REGISTER_BASE, 0xFF200058
//    .equ EDGE_CAPTURE_REGISTER_BASE, 0xFF20005C
//
//    .global read_PB_data_ASM;
//    .global PB_data_is_pressed_ASM;
//    .global read_PB_edgecap_ASM;
//    .global PB_edgecap_is_pressed_ASM;
//    .global PB_clear_edgecap_ASM;
//    .global enable_PB_INT_ASM;
//    .global disable_PB_INT_ASM;
//
//
//read_PB_data_ASM:
//  	LDR R0, =DATA_REGISTER_BASE                  // We return  the value stored in the EDGE_CAPTURE_REGISTER_BASE memory location
//  	BX LR
//
//PB_data_is_pressed_ASM:
//  	LDR R1, =DATA_REGISTER_BASE                  // load in R1 the current state of the DATA_REGISTER_BASE
//  	AND R1, R1, R0                              // logical And to weed out any other bits that are not of interest  
//  	SUB R0, R1, R0                              // substract the formated DATA_REGISTER_BASE and the filter value. we return this since if they are equal then it will return 0 which will be true else it will retun something else which wil be false
//  	BX LR
//
//
//read_PB_edgecap_ASM:
//  	LDR R0, =EDGE_CAPTURE_REGISTER_BASE          // We return  the value stored in the EDGE_CAPTURE_REGISTER_BASE memory location
//  	BX LR
//
//PB_edgecap_is_pressed_ASM:
// 	LDR R1, =EDGE_CAPTURE_REGISTER_BASE          // Load into R1 the current state of the EDGE_CAPTURE_REGISTER_BASE
//	AND R1, R1, R0                              // Logical AND with the filter to remove any unwanted bits
// 	SUBS R0, R1, R0                             // substract the formated EDGE_CAPTURE_REGISTER_BASE and the filter value. we return this since if they are equal then it will return 0 which will be true else it will retun something else which wil be false
//	BX LR
//
//PB_clear_edgecap_ASM:
//  	MVN R0, R0                                 // We do a logical NOT on R0 to inverse the bits for the next operation
//  	LDR R1, =EDGE_CAPTURE_REGISTER_BASE         // We load the value stored in EDGE_CAPTURE_REGISTER_BASE onto R1
//  	AND R0, R1, R0                             // Logical AND on whats currently in the EDGE_CAPTURE_REGISTER_BASE and the values we want to change. since we inversed the bits only the bits that were selected by the user are changed to a 0 and the rest remains unchanged
//  	STR R0, =EDGE_CAPTURE_REGISTER_BASE         // Store the value held in R0 into the memory location pointed by EDGE_CAPTURE_REGISTER_BASE
//  	BX LR
//
//enable_PB_INT_ASM:
//  	LDR R1, =INT_MASK_REGISTER_BASE             // We load the value stored in INT_MASK_REGISTER_BASE into R1
//  	ORR R0, R1, R0                             // logical OR on what is stored in R1 ( the current values ) and what is stored in R0 (the new values). Since we apply a logical or, only the values we want are turned into 1's and the rest remains unchanged
//  	STR R0, =INT_MASK_REGISTER_BASE             // Store the new value into the memory location pointed by INT_MASK_REGISTER_BASE
//  	BX LR
//
//
//disable_PB_INT_ASM:
//  	MVN R0, R0                                 // We do a logical NOT on R0 to inverse the bits for the next operation
//  	LDR R1, =INT_MASK_REGISTER_BASE             // We load the value stored in INT_MASK_REGISTER_BASE into R1
//  	AND R0, R1, R0                             // Logical AND on the current value of the INT_MASK_REGISTER_BASE ( stored in R0 ) and the new values to turn to 0 (the but inversed R0). Since we bit inversed it, only the values we want to turn to 0 are affected and the rest stay the same.
//  	STR R0, =INT_MASK_REGISTER_BASE             // Store the new value in the memory location pointed by INT_MASK_REGISTER_BASE
//  	BX LR
//
//