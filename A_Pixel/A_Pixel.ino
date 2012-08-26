/*

 This App receives color information through IR and then displays it with RGB LED.
 
0x  [Always 0 4 bits to indicate start] [4 bits to indicate function or color]     [pixel id] [pixel id]   [r] [g] [b]    [4 termination bits]   


 */

#include <IRremote.h>

#define RECV_PIN 	2
#define EMITIR_PIN 	6
#define RED_PIN		9
#define	GREEN_PIN	10
#define	BLUE_PIN	11


#define PIXELID		0x04

#define STARTNIBBLE	0xA
#define COLORS		0xA		
#define	IR			0xB		
#define	STREAM		0xC		
#define	SHOW		0xD
#define	GREYCODE	0xE		
#define GREYCODEDELAY 500


//typedef for 32 bit message packets
typedef struct {

	unsigned int checksum : 4;
	unsigned int blue : 4;
	unsigned int green : 4;
	unsigned int red : 4;
	unsigned int pixelId : 8;
	unsigned int function : 4;
	unsigned int start : 4;

} __attribute__ ((__packed__)) packet;


int myRed = 0;
int myGreen = 0;
int myBlue = 0;


packet message;

IRrecv irrecv(RECV_PIN);

decode_results results;




void setup()
{
  Serial.begin(115200);
  irrecv.enableIRIn(); // Start the receiver

  pinMode(EMITIR_PIN, OUTPUT);
  digitalWrite(EMITIR_PIN, HIGH);      // HIGH to turn off, LOW to turn on

  Serial.println("awake now");
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
		
			case COLORS:
				//Serial.println("got color");
				assignColors();
				paintPixel();
				break;
			case IR:
				//Serial.println("got IR");
				pulseIR();
				break;	
			case STREAM:
				//Serial.println("got stream");
				assignColors();				
				break;	
			case SHOW:
				//Serial.println("got show");
				paintPixel();			
				break;
			case GREYCODE:
				//Serial.println("got greycode");
				greyCodeSequence();			
				break;										
			default:
				break;
		}
	}

	// clean up
	*(unsigned long*)&message = 0x00000000;
}




void assignColors() {
	myRed = message.red;
	myGreen = message.green;
	myBlue = message.blue;
}




void paintPixel() {
	analogWrite(RED_PIN,255-map(myRed, 0, 15, 0, 255));
	analogWrite(GREEN_PIN,255-map(myGreen, 0, 15, 0, 255));
	analogWrite(BLUE_PIN,255-map(myBlue, 0, 15, 0, 255));	
}

void pulseIR() {
	digitalWrite(EMITIR_PIN, HIGH);
	delay(map(myRed, 0, 15, 0, 500));
	digitalWrite(EMITIR_PIN, LOW);
	//delay(GREYCODEDELAY);	
}


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






