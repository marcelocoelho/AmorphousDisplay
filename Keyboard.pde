


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
	int[][] pixelAnimation = new int[numPixels][numFrames];
	
	/*
	// load all images
	for ()
		displayManager.canvas.allFrames.get(i).returnPixelArray
		

		// load all pixels
		allPixels.get(i).
	*/
}