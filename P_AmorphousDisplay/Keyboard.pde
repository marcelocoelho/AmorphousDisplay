


/* -----------------------------------------------
*	
*	Some auxiliary code that is invisible to user
*	
-------------------------------------------------- */



public void keyPressed() {

	if(key == 'h') loadPixelsRandomly();
	
	if(key == 's') transmitAndPlayPhysicalPixels();

	if(key == 'd') debug();
	
	if(key == 'z') packet.send(0, COLOR, 15, 15, 15);
	if(key == 'x') packet.send(0, COLOR, 15, 0, 0);
	if(key == 'c') packet.send(0, COLOR, 0, 15, 0);
	if(key == 'v') packet.send(0, COLOR, 0, 0, 15);
	
	if (key == 'm') packet.send(1, IR, 15, 15, 15);
	if (key == 'n') packet.send(2, IR, 15, 15, 15);
	
	if (key == 'f') packet.sendNew(0, STOREFRAME, 15, 0, 15, 0);
	if (key == 'g') packet.sendNew(0, STOREFRAME, 0, 15, 15, 1);
	if (key == 'h') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 0);
	if (key == 'j') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 1);
	if (key == 'k') packet.sendNew(0, GOTOFRAME, 0, 0, 0, 2); 	
	
	/*
	if (key =='q') {}
		// send all frames of one pixel for all pixels
    	for (int i = 0; i < numFrames; i++) {
			packet.sendNew(0, STOREFRAME, 15, 0, 15, 0);
		}
	}
	*/

	
	
	
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