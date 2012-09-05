
// Packet format
// 0x  [Always 4 bits to indicate start nibble] [4 bits to indicate function or command]     [pixel id] [pixel id]   [r] [g] [b]    [4 termination bits]   
// This class handles all the data preparation and sending it to Arduino that then retransmits it over IR


/*
// processing doesn't support enums
public static final int COLORS = 0;
public static final int IR = 1;
public static final int STREAM = 2;
public static final int SHOW = 3;
public static final int GREYCODE = 4;
*/




public static final byte LOCATIONMASTER 	= 	0x9;
public static final byte COLOR 	=	 	0xA;
public static final byte STOREFRAME 	= 	0xB;
public static final byte GOTOFRAME 	= 	0xC;
public static final byte PLAYALLFRAMES = 0xD;
public static final byte SHOWFRAME 	= 	0xE;
public static final byte IR 	= 			0xF;

class Packet {
  
   byte start;  
   byte checksum;		  
   boolean waitingConfirmation;

   // packet initialization	
   public Packet(int _start, int _checksum) {
     start = (byte)_start;
     checksum = (byte)_checksum;
   }
   
   

  byte boundColor(int _color) {
    if (_color > 15) _color = 15;
    return (byte)_color;
  }

 byte remapColor(int _color) {
	
	byte colorByte;
	
	_color = (int)map(_color, 0, 255, 0, 15);
	colorByte = (byte)_color;
	
	return colorByte;
}


  byte boundPixelId(int _pixelId) {
    if (_pixelId > 255) _pixelId = 255;
    return (byte)_pixelId;
  }

  void gotConfirmation() {	
	waitingConfirmation = false;
  }


  void sendNew(int _pixelId, byte _function, int _value1, int _value2, int _value3, int _value4) {
    
	while(waitingConfirmation) {
		// waiting for confirmation
		// this prevents processing from sending more data, before arduino is done
	}
	
	// now that I'm ready to send more data, go do it
	waitingConfirmation = true;
    
	// this sends 32 bits, but 8 bits at a time
	myPort.write(start | _function);        	// start nibble and function/command   
    myPort.write( boundPixelId(_pixelId) );						// pixel ID 
    myPort.write(remapColor(_value1) << 4 | remapColor(_value2));	// color red and green
    myPort.write(remapColor(_value3) << 4 | _value4);			// color blue and checksum (which we are not using now)
    
	print(remapColor(_value1));
	print("   ");
	print(remapColor(_value2));	
	print("   ");
	println(remapColor(_value3));	

  }



  void sendOld(int _pixelId, byte _function, int _red, int _green, int _blue) {
    
	while(waitingConfirmation) {
		// waiting for confirmation
		// this prevents processing from sending more data, before arduino is done
	}
	
	// now that I'm ready to send more data, go do it
	waitingConfirmation = true;
    
	// this sends 32 bits, but 8 bits at a time
	myPort.write(start | _function);        	// start nibble and function/command   
    myPort.write( boundPixelId(_pixelId) );						// pixel ID 
    myPort.write(boundColor(_red) << 4 | boundColor(_green));	// color red and green
    myPort.write(boundColor(_blue) << 4 | checksum);			// color blue and checksum (which we are not using now)
    
  }
  
}

