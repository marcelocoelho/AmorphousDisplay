


/* -----------------------------------------------
*	
*	Some auxiliary code that is invisible to user
*	
-------------------------------------------------- */



public void keyPressed() {

	if(key == 'r') loadPixelsRandomly();
	
	if(key == 's') transmitAndPlayPhysicalPixels();

	if(key == 'd') debug();
	
	if(key == 'z') packet.sendNew(0, COLOR, 255, 255, 255, 0);
	if(key == 'x') packet.sendNew(0, COLOR, 255, 0, 0, 0);
	if(key == 'c') packet.sendNew(0, COLOR, 0, 255, 0, 0);
	if(key == 'v') packet.sendNew(0, COLOR, 0, 0, 255, 0);
	
	if (key == 'm') packet.sendNew(1, IR, 255, 255, 255, 0);
	if (key == 'n') packet.sendNew(2, IR, 255, 255, 255, 0);
	
	if (key == 'f') packet.sendNew(0, STOREFRAME, 255, 0, 255, 0);
	if (key == 'g') packet.sendNew(0, STOREFRAME, 0, 255, 255, 1);

	if (key == '1') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 0);
	if (key == '2') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 1);
	if (key == '3') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 2); 	
	if (key == '4') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 3);
	if (key == '5') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 4);
	if (key == '6') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 5);	
	if (key == '7') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 6); 	
	if (key == '8') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 7);
	if (key == '9') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 8);
	if (key == '0') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 9);	
	
	
	// USED FOR PAINT MODE, FRAME 0
	if (key == 'o') {
		
		syncVirtualAndPhysical = !syncVirtualAndPhysical;
		
		/*
		for (int p = 0; p < numPixels; p++) {
			packet.sendNew(p+1, COLOR, int(red(allPixels.get(p).allPixelColors[0])) , int(green(allPixels.get(p).allPixelColors[0])), int(blue(allPixels.get(p).allPixelColors[0])), 0 );	
		}
		*/
	}
	
	
	
	// USED TO ENABLE MASTER PIXEL MODE
	if (key == 'y') {
		singlePixelTracking = true;
	}
	if (key == 'u') {
		singlePixelTracking = false;
	}
	
	
	if (key =='q') {
		// send all frames of one pixel to all pixels
    	for (int f = 0; f < numFrames; f++) {
			print(f);
			print("    ");
			print(packet.remapColor(int(red(allPixels.get(0).allPixelColors[f]))));			// get(0) =  pixelId 1
			print("  ");
			print(packet.remapColor(int(green(allPixels.get(0).allPixelColors[f]))));	
			print("  ");
			println(packet.remapColor(int(blue(allPixels.get(0).allPixelColors[f]))));						
			
			//packet.sendNew(0, STOREFRAME, int(red(allPixels.get(0).allPixelColors[f])), int(red(allPixels.get(0).allPixelColors[f])), int(red(allPixels.get(0).allPixelColors[f])), f);
		}
	}
	

	
	
	
}


void loadPixelsRandomly() {
	
	for(int i = 0; i < numPixels; i++) {
		allPixels.get(i).x = int(random(1,300));
		allPixels.get(i).y = int(random(1,220));		
		allPixels.get(i).w = 20;			
		allPixels.get(i).h = 20;	
		allPixels.get(i).scanned = true; // this displays the pixels	
	}	
}


void testSendIR() {
	
	
	
	
}


boolean debug = false;
void debug() {
	
	debug = !debug;
	
}


void transmitAndPlayPhysicalPixels() {
	
	// two-dimensional array to store all pixel frames
	//int[][] pixelAnimation = new int[numPixels][numFrames];
	
	int initX = 500;
	int initY = 500;
	
	// load all images
	for (int f = 0; f < numFrames; f++) {
		
		int[] imagePixelArray = displayManager.canvas.allFrames.get(f).returnPixelArray();
		
		
		for (int p = 0; p < numPixels; p++) {
			
			allPixels.get(p).allPixelColors[f] = imagePixelArray[allPixels.get(p).myCenterInPixelArray()];
			//color pixelColor =	imagePixelArray[allPixels.get(p).myCenterInPixelArray()];
			noStroke();
			fill(allPixels.get(p).allPixelColors[f]);
			rect(initX+(f*20), initY+(p*25), 20, 20);
		
		}
		
	}

		// load all pixels
		//allPixels.get(i).
	
}