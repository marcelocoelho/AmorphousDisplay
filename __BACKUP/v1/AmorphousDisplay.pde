
/*

* TO DO
*	- Create array of PGraphics
*	- When an image is loaded it is copied to all instances of the array, like this http://processing.org/discourse/beta/num_1263153287.html
*	- Now we can draw on all frames without a problem


*/

// ------------------------------------
// USED BY SEVERAL CLASSES
import controlP5.*;
import java.awt.*;
import de.looksgood.ani.*;

ControlP5 controlP5;



PApplet app = this;



int numPixels = 4;		// pixels 1-3
int numFrames = 10;		// frames 0-9

Vector<Pixel> allPixels = new Vector<Pixel>();

Packet packet = new Packet(0xA0, 0x0F);

DisplayManager displayManager;

AniSequence seq;



void setup() {
	
	size(1200,800);
	frameRate(60);
	
	controlP5 = new ControlP5(this);
	
	Ani.init(this);
	//seq = new AniSequence(this);
	
	displayManager = new DisplayManager();
	
	initVision();
	initLoadImg();
	initSerial();
	
	
	// prep pixel array
	for (int i = 1; i <= numPixels; i++) {
		allPixels.addElement(new Pixel(i, 0, 0));
	}	
	
}


void draw() {
	
	background(125);
	
	loadCameraViews();
	
}



public void stop() {
	opencv.stop();
	super.stop();
}


