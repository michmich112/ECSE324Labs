#include <stdio.h>

#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/VGA.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/audio.h"


void test_char() {
	int x,y;
	char c = 0;
	
	for (y=0; y<=59; y++) 
		for (x=0; x<=79; x++) { 
			VGA_write_char_ASM(x, y, c++);
		}		
}

void test_byte() {
	int x,y;
	char c = 0;
	
	for (y=0; y<=59; y++) 
		for (x=0; x<=79; x+=3)
			VGA_write_byte_ASM(x, y, c++);
}

void test_pixel() {
	int x,y;
	unsigned short colour = 0;
	
	for (y=0; y<=239; y++) 
		for (x=0; x<=319; x++) 
			VGA_draw_point_ASM(x,y,colour++);
}

int main() {
	// VGA Test
	/*
	// Clear both buffers
	VGA_clear_charbuff_ASM();
	VGA_clear_pixelbuff_ASM();
	while(1) {
		// first button
		if (read_PB_data_ASM() == 1) {
			if (read_slider_switches_ASM() == 0) {
				test_char();
			} else {
				test_byte();
			}
		} 
		if (read_PB_data_ASM() == 2) {
			test_pixel();
		} 
		if (read_PB_data_ASM() == 4) {
			VGA_clear_charbuff_ASM();
		}  
		if (read_PB_data_ASM() == 8) {			
			VGA_clear_pixelbuff_ASM();
		}
	}
	*/

	// Keyboard Test
	/*
	char data;
	int x=0;
	int y=0;
	int x_max = 78;					// Space for 2 characters
	int y_max = 59;

	VGA_clear_charbuff_ASM();		// Clear buffer
	VGA_clear_pixelbuff_ASM();		// Clear buffer

	while(1) {
		if (read_PS2_data_ASM(&data)) {
			VGA_write_byte_ASM(x, y, data);
			x += 3;					// Incement by three since displays two chars
			if (x > x_max) {
				x = 0;
				y++;
				if (y > y_max) {
					y = 0;
					VGA_clear_charbuff_ASM();
				}
			}
		}

	}
	*/

	///*
	// Audio Test
	// 100 Hz with default sample rate of 48K samples/sec 
	// So want 100 cycles in 48K sample/sec means each cycle is 480 samples/cycle
	// Play square wave with 240 samples/half cycle
	int i; 
	int on = 0x00FFFFFF;
	int off = 0x00000000;

	while(1) {
		for (i = 0; i<240; i++) {
			write_audio_data_ASM(on);
		}
		i =0;
		for (i = 0; i<240; i++) {
			write_audio_data_ASM(off);
		}
	}
	//*/


	return 0;
}
	


