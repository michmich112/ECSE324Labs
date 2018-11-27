#include <stdlib.h>
#include "./drivers/inc/vga.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/audio.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/int_setup.h"
#include "./drivers/inc/wavetable.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/ps2_keyboard.h"
#include "./drivers/inc/HEX_displays.h"
#include "./drivers/inc/slider_switches.h"

//array to store the keys currently pressed
char keysPressed[8] = {};
//array holding the frequencies, index matched to the keys pressed
float frequencies[] = {130.813, 146.832, 164.814, 174.614, 195.998, 220.000, 246.942, 261.626};

// Get the sample based on the frequency and the "index"
// Returns double: signal
double getSampleOld(float freq, int t) {

	int index = (((int)freq) * t)%48000;
	double signal = sine[index];

	return signal;
}

// Get the sample based on the frequency and the "index" using linear interpolation
// Returns double: signal
double getSample(float freq, int t) {
	int truncatedIndex = ((int) freq)*t;
	double fractional = (freq*t) - truncatedIndex;

	int index = truncatedIndex % 48000;
	//calculate linear interpolation
	//sine[casted + fractional] = (1-fractional)*sine[index] + fractional[index+1]
	double signal = (1.0 - fractional) * sine[index] + fractional * sine[index + 1]; //lol lets hope it doesnt overflow

	return signal;
}

// Generate the signal from each frequency pressed and add them together
// Returns double: summed signal
double generateSignal(char* keys, int t) {
	int i;
	double data = 0;
	// Loop through all keys
	for(i = 0; i < 8; i++){
		// Check if key is pressed
		if(keys[i] == 1){
			// Sum all frequency samples
			data += getSampleOld(frequencies[i], t);
			//data += getSample(frequencies[i], t);
		}
	}
	return data;
}

//Screen is 79 x 59
void writeNames(){
	VGA_write_char_ASM(01, 01, 'M');
	VGA_write_char_ASM(02, 01, 'i');
	VGA_write_char_ASM(03, 01, 'c');
	VGA_write_char_ASM(04, 01, 'h');
	VGA_write_char_ASM(05, 01, 'e');
	VGA_write_char_ASM(06, 01, 'l');

	VGA_write_char_ASM( 8, 01, 'C');
	VGA_write_char_ASM( 9, 01, 'a');
	VGA_write_char_ASM(10, 01, 'n');
	VGA_write_char_ASM(11, 01, 't');
	VGA_write_char_ASM(12, 01, 'a');
	VGA_write_char_ASM(13, 01, 'c');
	VGA_write_char_ASM(14, 01, 'u');
	VGA_write_char_ASM(15, 01, 'z');
	VGA_write_char_ASM(16, 01, 'e');
	VGA_write_char_ASM(17, 01, 'n');
	VGA_write_char_ASM(18, 01, 'e');

	VGA_write_char_ASM(01, 02, 'J');
	VGA_write_char_ASM(02, 02, 'a');
	VGA_write_char_ASM(03, 02, 'k');
	VGA_write_char_ASM(04, 02, 'e');

	VGA_write_char_ASM(06, 02, 'P');
	VGA_write_char_ASM(07, 02, 'e');
	VGA_write_char_ASM( 8, 02, 't');
	VGA_write_char_ASM( 9, 02, 'e');
	VGA_write_char_ASM(10, 02, 'r');
	VGA_write_char_ASM(11, 02, 's');
}

void writeVolume(int volume){
	VGA_write_char_ASM(70, 01, 'V');
	VGA_write_char_ASM(71, 01, 'o');
	VGA_write_char_ASM(72, 01, 'l');
	VGA_write_char_ASM(73, 01, 'u');
	VGA_write_char_ASM(74, 01, 'm');
	VGA_write_char_ASM(75, 01, 'e');
	VGA_write_char_ASM(76, 01, ':');
	if(volume < 10){
		VGA_write_char_ASM(77, 01, '0');
		VGA_write_char_ASM(78, 01, volume + 48);
	}else{
		VGA_write_char_ASM(77, 01, '1');
		VGA_write_char_ASM(78, 01, '0');
	}
}

int main() {

	int keyReleased = 0;
	double history[320] = { 0 };
	int volume = 1;
	char value;
	
	while(1){
		writeNames();
		writeVolume(volume);

		if(read_ps2_data_ASM(&value)) {
			switch (value) {
				case 0x55:
					if(keyReleased){
						if(volume<10){
							volume++;
						}
						keyReleased = 0;
					}
					break;
				case 0x4E:
					if(keyReleased){
						if(volume>1){
							volume--;
						}
						keyReleased = 0;
					}
					break;
				case 0xF0: //the break code is the same for all keys
					keyReleased = 1;
					break;
				default:
					keyReleased = 0;
			}
		}


	}

	return 0;
}
