
/*

* TO DO
*	
*	- TWO BUGS TO FIX
*		2- when frames are cleared, pixels retain their color information
*		3- if pixel positions are loaded after image was loaded, they won't get the new image colors unless I go to their frame
*		1- when I load an alpha channel (after loading an image) and scroll the animations, pixels will blink colors of last frame
*			- this stops after I've scrolled through all frames in the animation, meaning the pixels are updated with the appropriate color
*	- write code to stream all frames to pixels
*	
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



int numPixels = 10;		// pixels 1-3
int numFrames = 10;		// frames 0-9

Vector<Pixel> allPixels = new Vector<Pixel>();

Packet packet = new Packet(0xA0, 0x0F);

DisplayManager displayManager;

PixelController pixelController;


int appMarginTop = 30;
int appMarginSides = 30;


void setup() {
	
	size(1300,800);
	frameRate(60);
		
	controlP5 = new ControlP5(this);
	
	
	displayManager = new DisplayManager(this);
	
	pixelController = new PixelController(appMarginSides, appMarginTop);
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


