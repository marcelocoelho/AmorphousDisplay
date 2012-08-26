
// Packet format
// 0x  [Always 4 bits to indicate start nibble] [4 bits to indicate function or command]     [pixel id] [pixel id]   [r] [g] [b]    [4 termination bits]   
// This class handles all the data preparation and sending it to Arduino that then retransmits it over IR


// processing doesn't support enums
public static final int COLORS = 0;
public static final int IR = 1;
public static final int STREAM = 2;
public static final int SHOW = 3;
public static final int GREYCODE = 4;


class Packet {
  
   byte start;  
   byte checksum;		  
   boolean waitingConfirmation;

   // packet initialization	
   public Packet(int _start, int _checksum) {
     start = (byte)_start;
     checksum = (byte)_checksum;
   }
   
   
  // this choses what nibble to send when I call a certain command through packet.send() 
  byte chooseFunction(int _function) {
    
    byte val = 0x00;
    
    switch(_function) {
     case COLORS:
       val = 0x0A;
       break;
     case IR: 
       val = 0x0B;
       break;
     case STREAM: 
       val = 0x0C;
       break;
     case SHOW: 
       val = 0x0D;
       break;
     case GREYCODE: 
       val = 0x0E;
       break;
     default: 
      break;
    }
    
    return val;
  }
   

  byte boundColor(int _color) {
    if (_color > 15) _color = 15;
    return (byte)_color;
  }


  byte boundPixelId(int _pixelId) {
    if (_pixelId > 255) _pixelId = 255;
    return (byte)_pixelId;
  }

  void gotConfirmation() {	
	waitingConfirmation = false;
  }

  void send(int _pixelId, int _function, int _red, int _green, int _blue) {
    
	while(waitingConfirmation) {
		// waiting for confirmation
		// this prevents processing from sending more data, before arduino is done
	}
	
	// now that I'm ready to send more data, go do it
	waitingConfirmation = true;
    
	// this sends 32 bits, but 8 bits at a time
	myPort.write(start | chooseFunction(_function));        	// start nibble and function/command   
    myPort.write( boundPixelId(_pixelId) );						// pixel ID 
    myPort.write(boundColor(_red) << 4 | boundColor(_green));	// color red and green
    myPort.write(boundColor(_blue) << 4 | checksum);			// color blue and checksum (which we are not using now)
    
  }
  
}

