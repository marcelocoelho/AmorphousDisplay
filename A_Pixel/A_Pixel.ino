/*

 This App receives color information through IR and then displays it with RGB LED.
 
0x  [Always 0 4 bits to indicate start] [4 bits to indicate function or color]     [pixel id] [pixel id]   [r] [g] [b]    [4 termination bits]   


 */

#include <IRremote.h>

#define RECV_PIN 	2
#define EMITIR_PIN 	6
#define LED_RED		9
#define	LED_GREEN	10
#define	LED_BLUE	11


#define PIXELID		0x04

#define STARTNIBBLE	0xA


#define COLOR			0xA	
#define STOREFRAME		0xB
#define	GOTOFRAME		0xC
#define PLAYALLFRAMES	0xD
#define SHOWFRAME		0xE
#define IR				0xF
	


//typedef for 32 bit message packets
typedef struct {

	unsigned int packet4 : 4;
	unsigned int packet3 : 4;
	unsigned int packet2 : 4;
	unsigned int packet1 : 4;
	unsigned int pixelId : 8;
	unsigned int function : 4;
	unsigned int start : 4;

} __attribute__ ((__packed__)) packet;


#define MAX_NUM_FRAMES 10 				// hard coding the max number of frames a pixel can play, so I don't have to deal with dynamic arrays
#define NUM_VALUES		3
int myFrames[MAX_NUM_FRAMES][NUM_VALUES];
int currentFrame;



packet message;

IRrecv irrecv(RECV_PIN);

decode_results results;




void setup()
{
  Serial.begin(115200);
  irrecv.enableIRIn(); 				// Start the IR receiver

  pinMode(EMITIR_PIN, OUTPUT);		// Turn off IR emitter
  digitalWrite(EMITIR_PIN, HIGH);	// HIGH to turn off, LOW to turn on

  Serial.println("awake now");

  initFrames();

}


void loop() {
  if (irrecv.decode(&results)) {
    Serial.println(results.value, HEX);  // Output full message for debugging

	parseRcvdMessage(results.value);

    //delay(10); 
    irrecv.resume(); // Receive the next value

  }
}




void parseRcvdMessage(long rcvdMessage) {
	
	
	*(unsigned long*)&message = rcvdMessage;
	
	if((message.start == STARTNIBBLE) && (message.pixelId == PIXELID || message.pixelId == 0)) {
		
		switch(message.function) {
		
			case COLOR:			// Display color as soon as it is received
				paintPixel();
				break;
				
			case STOREFRAME:	// Store frame without displaying it
				storeFrame();
				break;
				
			case GOTOFRAME:		// Play specific frame
				goToFrame();
				break;
				
			case PLAYALLFRAMES:	// Play all frames with timing information provided
				playAllFrames();
				break;
				
			case SHOWFRAME:		// Show frame for debugging purposes
				showFrame();
				break;
				
			case IR:				// Pulse IR 
				pulseIR();
				break;	
												
			default:
				break;
		}
	}

	// clean up
	*(unsigned long*)&message = 0x00000000;
}


// Initialize frame array with 0
void initFrames() {	
	
	for (int maxFrames = 0; maxFrames < MAX_NUM_FRAMES; maxFrames++) {

		for (int maxValues = 0; maxValues < NUM_VALUES; maxValues++) {
			myFrames[maxFrames][maxValues] = 0;
		}
	}
}




void paintPixel() {
	analogWrite(LED_RED,255-map(message.packet1, 0, 15, 0, 255));
	analogWrite(LED_GREEN,255-map(message.packet2, 0, 15, 0, 255));
	analogWrite(LED_BLUE,255-map(message.packet3, 0, 15, 0, 255));	
}


void storeFrame() {
	myFrames[message.packet4][0] = message.packet1;
	myFrames[message.packet4][1] = message.packet2;
	myFrames[message.packet4][2] = message.packet3;	
}


void goToFrame() {
	
	int tempRed = 255 - map( myFrames[message.packet4][0], 0, 15, 0, 255 );
	int tempGreen = 255 - map( myFrames[message.packet4][1], 0, 15, 0, 255 );
	int tempBlue = 255 - map( myFrames[message.packet4][2], 0, 15, 0, 255 ); 
		
	analogWrite(LED_RED, tempRed);
	analogWrite(LED_GREEN, tempGreen);
	analogWrite(LED_BLUE, tempBlue);	
}


void playAllFrames() {
	
	
}

void showFrame() {
	
	
}


void pulseIR() {
	digitalWrite(EMITIR_PIN, LOW);
	delay(map(message.packet1, 0, 15, 0, 500));
	digitalWrite(EMITIR_PIN, HIGH);
	//delay(GREYCODEDELAY);	
}


/*

void toggleIRBeacon(boolean _value) {
  if (_value == true) {
      digitalWrite(EMITIR_PIN, HIGH);
  } else {
      analogWrite(EMITIR_PIN, LOW);
  }
}


void greyCodeSequence() {
	for (int i = 0; i < 8; i++) {
		if (bitRead(PIXELID,i) == 0b1) {
			digitalWrite(EMITIR_PIN, HIGH);
			delay(GREYCODEDELAY);
			digitalWrite(EMITIR_PIN, LOW);
			delay(GREYCODEDELAY);	
		} else {
			delay(GREYCODEDELAY*2);
		}		
	}
}

*/




