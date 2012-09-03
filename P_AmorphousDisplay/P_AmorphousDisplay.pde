
/*

* TO DO

*	- wire 4 pixels with leds and see if I can detect them
*	- write arduino and packet code, so I can send all frames in one shot time
*		- then send STREAM with FPS defined
*	
*	FUNCTIONS
*	- drawing 
*		- lets you create animations, frame by frame
*			- save and load animation
*			- maybe (draw in all)
*	- load image 
*		- lets you display a single image
*			- remove frames in this case? but then how can you modify your image by drawing?
*	- load alpha
*		- lets you create changing patterns
*			- actually make this alpha, rather than a full image
*	- load phase
*		- actually phase is a full animation cycle
*	
*	

*/

// ------------------------------------
// USED BY SEVERAL CLASSES
import controlP5.*;
import java.awt.*;
//import de.looksgood.ani.*;



ControlP5 controlP5;



PApplet app = this;



int numPixels = 4;		// pixels 1-3
int numFrames = 10;		// frames 0-9

Vector<Pixel> allPixels = new Vector<Pixel>();

Packet packet = new Packet(0xA0, 0x0F);

DisplayManager displayManager;

PixelController pixelController;


// INTERFACE POSITIONING STUFF, ACCESSIBLE BY ALL
int frameWidth = 320;
int frameHeight = 240;


int appMarginTop = 30;
int appMarginSides = 30;

int leftColumnX = 80;
int leftColumnY = 50;

int middleColumnX = leftColumnX*2 + frameWidth;
int middleColumnY = leftColumnY;

int rightColumnX = leftColumnX*3 + frameWidth*2;
int rightColumnY = leftColumnY;



void setup() {
	
	size(1300,800);
	frameRate(10);
		
	controlP5 = new ControlP5(this);
	
	
	displayManager = new DisplayManager(this);
	
	pixelController = new PixelController();
	pixelController.init();
	
	
	initVision();
	initLoadImg();
	initSerial();
	
}


void draw() {
	
	background(125);
	
	loadCameraViews();
	
}



public void stop() {
	opencv.stop();
	super.stop();
}


