/*

 This App receives color information from the Processing app and then retransmits it through IR.
 
 IRsend uses an infrared LED connected to output pin 3.
 
 */

#include <IRremote.h>

IRsend irsend;

int incomingByte;      // a variable to read incoming serial data into


#define SIZE 4              // message size
byte id = 1;                // 
long message[SIZE];         // array with the full message I'm transmitting over IR
int message_index;          // where we are in the message
boolean message_complete;   // flag to indicate we got the whole message
boolean is_listening;       // listen to incoming serial or not?

long messageToDisplay = 0;    // stores 4 bytes





void setup()
{
  Serial.begin(115200);

  // debug LED
  pinMode(13, OUTPUT);


  // populate all variables with zero
  message_index = 0;
  message_complete = false;
  is_listening = true;
  for (int i=0; i<SIZE; i++) {
    message[i] = i;
  }


}

void loop() {
  	if (Serial.available() > 0) 
		readSerial();
}



void readSerial() {

  // store incoming byte into array and advance array`  
  message[message_index] = Serial.read();
  message_index++;

  if((message_index == SIZE) && ((message[0] >> 4) == 0xA)) {
	message_index = 0;

	//Serial.print(message[0] >> 4);

    // package message into a single long variable   
    messageToDisplay |= (message[0] << 24);
    messageToDisplay |= (message[1] << 16);
    messageToDisplay |= (message[2] << 8);
    messageToDisplay |= (message[3] << 0);      

    irsend.sendSony(messageToDisplay, 32);

    // Clean up everything
    messageToDisplay = 0x00000000;
    for (int i=0;i<4;i++) {
      message[i] = 0x00000000;
    }

    delay(10);  // time it takes for pixel to decode receiving message    
    Serial.print("k");   // tell processing that arduino is ready

  }



}




void blinkLED() {
  digitalWrite(13, HIGH);
  //delay(100);
  //digitalWrite(13, LOW);
  //delay(100);   
} 



/////////////////////////////////////////////////////////////////////////
// SNIPETS OF CODE
////////////////////////////////////////////////////////////////////////


// THIS IS AWESOME AND WORKS WELL
/*
    for (int i = 0; i < 3; i++) {
 //irsend.sendSony(0xa90, 12); // Sony TV power code
 irsend.sendSony(0xFADED, 20); // 4 bits * 5
 delay(100);
 }
 */

/*
  if (Serial.available() > 0) {
 incomingByte = Serial.read();
 for (int i = 0; i < 3; i++) {
 irsend.sendSony(incomingByte, 12); // Sony TV power code
 delay(100);
 }
 }
 */

/*
  if (Serial.read() != -1) {
 for (int i = 0; i < 3; i++) {
 irsend.sendSony(0xa90, 12); // Sony TV power code
 delay(100);
 }
 }
 */


    /* // THIS WORKS WELL
     messageToDisplay = 0xFADEDABE;
     irsend.sendSony(messageToDisplay, 32);
     delay(100);
     */

    //irsend.sendSony(0xFADED, 20); // 4 bits * 5
    // delay(100);  










