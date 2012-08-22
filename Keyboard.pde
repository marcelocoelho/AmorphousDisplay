


/* -----------------------------------------------
*	
*	Some auxiliary code that is invisible to user
*	
-------------------------------------------------- */



public void keyPressed() {

	if(key == 'h') loadPixelsRandomly();
	
	if(key == 's') transmitAndPlayPhysicalPixels();

	if(key == 'd') debug();
	
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