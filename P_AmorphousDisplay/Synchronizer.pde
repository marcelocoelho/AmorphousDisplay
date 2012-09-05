




// THIS IS A BIT OF HACK TO GET PAINT MODE WORKING FOR A SINGLE FRAME

boolean syncVirtualAndPhysical = false;
int timerForPaintPixelTransmission = 0;

void syncPixels() {
	
	if (syncVirtualAndPhysical) {

		if (timerForPaintPixelTransmission > 5) timerForPaintPixelTransmission = 0;

		if (timerForPaintPixelTransmission == 0) {
			
			for (int p = 0; p < numPixels; p++) {
				packet.sendNew(p+1, COLOR, int(red(allPixels.get(p).allPixelColors[0])) , int(green(allPixels.get(p).allPixelColors[0])), int(blue(allPixels.get(p).allPixelColors[0])), 0 );	
			}
		}
		timerForPaintPixelTransmission++;
	}
	
}




