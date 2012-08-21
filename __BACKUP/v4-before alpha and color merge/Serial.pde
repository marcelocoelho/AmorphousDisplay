import processing.serial.*;
Serial myPort;


// Init stuff
// --------------------------------------------------------------------------------------------------------------
void initSerial() {
	String portName = Serial.list()[0];						// first available port
	myPort = new Serial(this, portName, 115200); 				// Serial 'myPort'; port 'portName'
}


// Serial Event for incoming data
// --------------------------------------------------------------------------------------------------------------
void serialEvent (Serial myPort) {
	
	

	packet.gotConfirmation();


	
}




void colorPixel(int _pixelID, color _c) {
	myPort.write(_pixelID);          
  	myPort.write(int(red(_c)));
  	myPort.write(int(green(_c)));
  	myPort.write(int(blue(_c)));
}


/*
// Turn single pixel IR ON
// --------------------------------------------------------------------------------------------------------------
void turnSinglePixelIrOn(int _pixelID) { 
    myPort.write(0x0);          
    myPort.write(_pixelID);
    myPort.write(0xAA);
    myPort.write(0xFF);
    delay(100);
}


// Turn single pixel IR OFF
// --------------------------------------------------------------------------------------------------------------
void turnSinglePixelIrOff(int _pixelID) { 
    myPort.write(0x0);          
    myPort.write(_pixelID);
    myPort.write(0xCC);
    myPort.write(0xFF);
    //delay(100);
}
*/
