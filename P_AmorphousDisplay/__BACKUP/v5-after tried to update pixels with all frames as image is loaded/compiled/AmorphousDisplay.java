import processing.core.*; 
import processing.xml.*; 

import controlP5.*; 
import java.awt.*; 
import processing.video.*; 
import processing.serial.*; 
import hypermedia.video.*; 
import processing.video.*; 
import java.awt.*; 

import java.applet.*; 
import java.awt.Dimension; 
import java.awt.Frame; 
import java.awt.event.MouseEvent; 
import java.awt.event.KeyEvent; 
import java.awt.event.FocusEvent; 
import java.awt.Image; 
import java.io.*; 
import java.net.*; 
import java.text.*; 
import java.util.*; 
import java.util.zip.*; 
import java.util.regex.*; 

public class AmorphousDisplay extends PApplet {


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


public void setup() {
	
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


public void draw() {
	
	background(125);
	
	loadCameraViews();
	
}



public void stop() {
	opencv.stop();
	super.stop();
}


/*-------------------------------------------------------------------------------------------
*	
*	Display Manager
*	- loads everything: canvas, colorpalette, animation
*	
*	
*	Animation
*	- handles the animation playback (frame advancing, speed etc)
*	- initializes animation interface
*	- updates timeline slider
*	
*	Canvas
*	- Loads all blank frames and handles drawing
*	
*	Frame
*	- does the drawing
*	
*	
*	
*	
-------------------------------------------------------------------------------------------*/ 	

				// moviemaker

MovieMaker movieToSave;




// HANDLES ALL THE IMAGE CREATION ELEMENTS
// -------------------------------------------------------------------------------------------
public class DisplayManager {
	
	PApplet root;
	
	Canvas canvas;
	ColorPalette colorPalette;
	Animation animation;
	
	int w, h;
	
	PVector startPosition;	// where to start drawing things
	PVector dimension;		// size of drawing and image area. this is not a vector per se.
	
	DisplayManager(PApplet _root) {
		
		root = _root;
		
		startPosition = new PVector(appMarginSides,appMarginTop);		// change these to modify interface look
		dimension = new PVector(320,240);
		

		canvas = new Canvas(root, startPosition, dimension);		
		colorPalette = new ColorPalette(startPosition.x + dimension.x, startPosition.y);
		animation	= new Animation(startPosition.x, startPosition.y + dimension.y, dimension.x);
		
		app.registerDraw(this);
	}
	
	
	public void draw() {
	
		canvas.draw();
		pixelController.updateaAllPixelColorsWithCurrentFrame( canvas.allFrames.get(animation.currentFrame-1).frameGraphic);
			
	}
}




// HANDLES ALL THE IMAGE ANIMATION STUFF
// -------------------------------------------------------------------------------------------
public class Animation {
	
	int initFrame;
	int currentFrame;
	int finalFrame;
	float runningTime;
	
	float scrollSpeed;
	
	boolean isPlaying = false;
	
	Animation(float _x, float _y, float _w) {
		
		
		initFrame = 1;
		currentFrame = 1;
		runningTime = 1;
		finalFrame = numFrames;
		scrollSpeed = 0.5f;
		
		app.registerDraw(this);
		
		initAnimationInterface(_x, _y, _w, scrollSpeed);
	}
	
	public void draw() {
		
		if (isPlaying) {
			controlP5.getController("playPause").setCaptionLabel("pause");
			if (currentFrame >  finalFrame) {
				currentFrame = 1;
				runningTime = 1;
			} else {
				runningTime = runningTime+scrollSpeed/frameRate;
				currentFrame = PApplet.parseInt(runningTime);
				//currentFrame = int(currentFrame+scrollSpeed/frameRate);
			}
		} else {
			controlP5.getController("playPause").setCaptionLabel("play");
			currentFrame = (int)controlP5.getController("browser").getValue();
			runningTime = currentFrame;
			
		}
		//println(currentFrame);
		
		// updates position of timeline slider
		controlP5.getController("browser").setValue(displayManager.animation.currentFrame);
		
	}

	
	public void playPause() {
		
		isPlaying = !isPlaying;

	}
	
}


// Animation Interface Assignments 
// -------------------------------------------------------------------------------------------
public void initAnimationInterface(float _x, float _y, float _w, float _speed) {
	
	controlP5.addSlider("browser")											// slider for animation control
     		.setPosition(_x,_y+5)
     		.setSize(PApplet.parseInt(_w),20)
     		.setRange(1,numFrames)
     		.setNumberOfTickMarks(numFrames)
     		;
			controlP5.getController("browser").setCaptionLabel("Timeline");
					
	controlP5.addButton("playPause",										// play or pause animation	
			0,
			PApplet.parseInt(_x), PApplet.parseInt(_y)+40,
			60, 20
			);		
			controlP5.getController("playPause").setCaptionLabel("Play");	
			
	
	controlP5.addNumberbox("updateScrollSpeed")									//scroll speed
		     .setPosition(PApplet.parseInt(_x)+130, PApplet.parseInt(_y)+40)
		     .setSize(60,20)
		     .setRange(0.1f, 10)
			 .setMultiplier(1)
		     .setValue(_speed)
			 .setCaptionLabel("Scroll Speed")
		     ;


	/* ------  color palette related, moved it to a different class later? ---- */

	controlP5.addButton("clearFrame",										// clear all frames	
			0,
			PApplet.parseInt(_x)+325, PApplet.parseInt(_y)-45,
			70, 20
			);		
			controlP5.getController("clearFrame").setCaptionLabel("Clear Frame");

	controlP5.addButton("clearAll",										// clear all frames	
			0,
			PApplet.parseInt(_x)+325, PApplet.parseInt(_y)-20,
			70, 20
			);		
			controlP5.getController("clearAll").setCaptionLabel("Clear All");																									
}

public void playPause() {

	displayManager.animation.playPause();
}

public void updateScrollSpeed() {
	//displayManager.animation.scrollSpeed = controlP5.getController("updateScrollSpeed").getValue();
}

public void clearAll() {
	displayManager.canvas.clearAll();
}

public void clearFrame() {
	displayManager.canvas.clearCurrentFrame();
}




// CANVAS FOR DRAWING AND DISPLAYING LOADED IMAGES
// -------------------------------------------------------------------------------------------
public class Canvas {
	
	
	PApplet root;
	int w, h;
	private int currentFrame;		// Only accessible by its own class. Animation should be dictating currentFrame for everybody
	Vector<Frame> allFrames = new Vector<Frame>();
	
		
	Canvas(PApplet _root, PVector _startPosition, PVector _dimension) {
	
		root = _root;
		
		currentFrame = 0;
		
		// load frames
		for (int i = 0; i <  numFrames; i++) {
			allFrames.addElement(new Frame(_startPosition.x, _startPosition.y, _dimension.x, _dimension.y));
		}
		
		// set-up each frame with a black background
		for (int i = 0; i <  numFrames; i++) {
			allFrames.get(i).init();
		}
		
		//app.registerDraw(this);
		app.registerMouseEvent(this);
	}
	
	public void draw() {
		
		// draw current frame
		currentFrame = displayManager.animation.currentFrame-1;
		allFrames.get(currentFrame).drawFrame();
				
		// this works but with a delay, I moved this to displayManager to see if it is faster
		//pixelController.updateaAllPixelColorsWithCurrentFrame(allFrames.get(currentFrame).frameGraphic, currentFrame);

		
		
		if (debug) {
			image(allFrames.get(8).frameGraphic, 400, 600);
			
			for (int i = 0; i <  numPixels; i++) {
				allPixels.get(i).debug();
			}
			
		}
		
	}
	
	
	public void clearCurrentFrame() {
		allFrames.get(currentFrame).init();
	}
	
	public void clearAll() {
		for (int i = 0; i <  numFrames; i++) {
			allFrames.get(i).init();			
		}
	}
	
	/*PGraphics getSpecificFrame(int _specificFrame) {
		return allFrames.get(_specificFrame).frameGraphic;
		
	}*/
	
	/*  // got rid of encapsulation to make code faster
	color getColorFromCurrentFrame(int _pixelLocation) {
		
		return allFrames.get(currentFrame).getColor(_pixelLocation);
	}
	*/
	
	public void saveCurrentFrame(String _filename) {
		allFrames.get(currentFrame).frameGraphic.save("data/saved/"+ _filename +".png");
	}
	
	public void saveAllFrames(String _folderName) {
		for (int i = 0; i <  numFrames; i++) {
			allFrames.get(i).frameGraphic.save("data/"+_folderName+"/frame"+ i +".png");			
		}
	}
	
	public void loadMovieSequence(String _folderName) {
		
		PImage tempImage;
		
		for (int i = 0; i <  numFrames; i++) {
			tempImage = loadImage(_folderName+"/frame"+ i +".png");
			allFrames.get(i).loadImageIntoFrameBuffer(tempImage);
		}
	}
	


	public void loadImageInAllFrames(PImage _selectedImage) {
		
		for (int i = 0; i <  numFrames; i++) {
			allFrames.get(i).loadImageIntoFrameBuffer(_selectedImage);
		}	
	}
	
	
/*	
	void loadAlpha(PImage _loadedImage) {
		
		// this method: copies alpha channel to a buffer, posterizes it and then copies it back to original image
		
		PGraphics loadedImage  = createGraphics(320,240, P2D);
		PGraphics alphaChannel  = createGraphics(320,240, P2D);
		
		alphaChannel.beginDraw();
		alphaChannel.image(_loadedImage, 0, 0);
		alphaChannel.loadPixels();
		
		for (int p = 0; p < alphaChannel.pixels.length; p++) {
			
			int alphaPixel = (alphaChannel.pixels[p] >> 24) & 0xFF;   							// extract alpha
			alphaChannel.pixels[p] = color(alphaPixel, alphaPixel, alphaPixel, alphaPixel);		// make all pixels alpha
			
		}
		
		alphaChannel.updatePixels();
		alphaChannel.filter(POSTERIZE, numFrames);  		
		alphaChannel.endDraw();		
		
		
		_loadedImage.alpha(alphaChannel);
		
		for (int i = 0; i < numFrames; i++) {		
			allFrames.get(i).loadImageIntoFrameBuffer(_loadedImage);		
		}
		

	}
	*/
	
	
	public void loadAlpha(PImage _alphaImage) {
		
		PGraphics alphaImage = createGraphics(320,240, P2D);
		PGraphics tempImage = createGraphics(320,240, P2D);
		
		//_alphaImage.loadPixels();

		alphaImage.beginDraw();
		alphaImage.image(_alphaImage, 0, 0);
		alphaImage.filter(GRAY);
		alphaImage.filter(POSTERIZE, numFrames);  		
		alphaImage.endDraw(); 
		
		for (int i = 0; i <  numFrames; i++) {

			tempImage.beginDraw();
			
			tempImage.copy(alphaImage,0,0,320,240,0,0,320,240);
			
			tempImage.loadPixels();	
			
			float boundary = map(i, 0, 9, 0, 255);
			
			
			for (int j = 0; j <  tempImage.pixels.length; j++) {
				
				if (red(tempImage.pixels[j]) >  PApplet.parseInt(boundary)+2 || red(tempImage.pixels[j]) <  PApplet.parseInt(boundary)-2) {  // 2 here is just a margin of safety
			     tempImage.pixels[j] = color(0,0,0,255);
			   } else {
			     tempImage.pixels[j] = color(255,255,255,0);     
			   }
			}
						
			tempImage.updatePixels();
			
			tempImage.endDraw();
			
			allFrames.get(i).loadImageIntoFrameBuffer(tempImage);
		}		
	}
	
	
	
	public void loadPeriod(PImage _periodImage) {
		
		PGraphics periodImage = createGraphics(320,240, P2D);
		PGraphics tempImage = createGraphics(320,240, P2D);
		
		
		periodImage.beginDraw();
		periodImage.image(_periodImage, 0, 0);
		periodImage.filter(GRAY);
		periodImage.filter(POSTERIZE, 10);  // 10 is numebr of frames		
		periodImage.endDraw();
		
		for (int i = 0; i <  numFrames; i++) {

			tempImage.beginDraw();
			
			tempImage.copy(periodImage,0,0,320,240,0,0,320,240);
			
			tempImage.loadPixels();	
			
			float boundary = map(i, 0, 9, 0, 255);
			//println(int(boundary));
			
			
			for (int j = 0; j <  tempImage.pixels.length; j++) {
				
				if (red(tempImage.pixels[j]) >  PApplet.parseInt(boundary)+2) {  // 2 here is just a margin of safety
			     tempImage.pixels[j] = color(0,0,0,255);
			   } else {
			     tempImage.pixels[j] = color(255,255,255,0);     
			   }
			}
			
			
			tempImage.updatePixels();
			tempImage.endDraw();
			
			allFrames.get(i).loadImageIntoFrameBuffer(tempImage);
		}
	}


	
	
	public void mouseEvent(MouseEvent event) {
	
		switch (event.getID()) {
			
				case MouseEvent.MOUSE_DRAGGED:
					allFrames.get(currentFrame).pencilDown();
				break;
				
				case MouseEvent.MOUSE_PRESSED:
					allFrames.get(currentFrame).pencilDown();
				break;
			
		}
	}
}


// THIS SHOULD BE INSIDE CANVAS, BUT COULDN'T GET ACCESS PERMISSIONS TO WORK WITHOUT THROWING A MEMORY ACCESS ERROR
public void saveMovieGrabFrames(String _filename) {
	
	movieToSave = new MovieMaker(this, 320, 240, "data/saved/"+_filename+".mov");
	
	for (int i = 0; i <  numFrames; i++) {
		movieToSave.addFrame(displayManager.canvas.allFrames.get(i).returnPixelArray(), 320, 240);
	}
	movieToSave.finish();
}







// FRAMES, WHERE STUFF GETS DRAWN
// -------------------------------------------------------------------------------------------
public class Frame {
	
	PGraphics frameGraphic;
	float x,y,w,h;
	
	Frame(float _x, float _y, float _w, float _h) {
		
		x = _x;
		y = _y;
		w = _w;		
		h = _h;	
		
		frameGraphic = createGraphics(PApplet.parseInt(_w), PApplet.parseInt(_h), P2D);
	}		
	
	public void init() {
	
		frameGraphic.beginDraw();
		frameGraphic.background(0);		
		frameGraphic.endDraw();	
		
		//pixelController.updateAllPixelsWithSingleFrame(frameGraphic);
	}
	
	
	public void drawFrame() {
		
		image(frameGraphic, x, y);
	}
	
	public void pencilDown() {
		frameGraphic.beginDraw();
		frameGraphic.smooth();
		frameGraphic.fill(displayManager.colorPalette.selectedColor);
		frameGraphic.noStroke();
		frameGraphic.ellipseMode(CENTER);
		frameGraphic.ellipse(mouseX - x, mouseY - y, 20, 20);
		frameGraphic.endDraw();
	}
	
	public void loadImageIntoFrameBuffer(PImage _selectedImage) {
		frameGraphic.beginDraw();
		//frameGraphic.fill(0);								// this allows a new frame to be overlaid the previous one, change to backgroun(0) to do otherwise
		frameGraphic.image(_selectedImage,0,0);
		frameGraphic.endDraw();
		
		//println("3");
		
		
		//pixelController.updateAllPixelsWithSingleFrame(frameGraphic);
	}
	
	/*
	void loadMovieFromDirectory(String _folderAndFileName) {
	
		PImage tempImage;
		tempImage = loadImage(_folderAndFileName);
		
		frameGraphic.beginDraw();
		frameGraphic.image(tempImage,0,0);
		frameGraphic.endDraw();
	}
	*/
	
	/*/// INEFFICIENT. It was replaced for a single frame call that gets color for all pixels at once
	color getColor(int _pixelLocation) {
		
		color tempColor;
				
		frameGraphic.beginDraw();
		frameGraphic.loadPixels();
		tempColor = frameGraphic.pixels[_pixelLocation];
		frameGraphic.endDraw();

		return tempColor;	
	}
	*/
	
	
	public int[] returnPixelArray() {
		
		frameGraphic.beginDraw();
		frameGraphic.loadPixels();

		int[] tempArray = new int[320*240];
		
		for (int j = 0; j <  frameGraphic.pixels.length; j++) {
			tempArray[j] = frameGraphic.pixels[j];
		}
		
		return tempArray;
	}
	
}
	
	
	
	








// COLORS THAT CAN BE USED TO DRAW ON CANVAS
// -------------------------------------------------------------------------------------------
public class ColorPalette {

	Vector<Swatch> allSwatches = new Vector<Swatch>();	
	
	boolean anySelected;
	
	int selectedColor;
	
	int x, y;
	
	ColorPalette(float _x,  float _y) {
	
		x = PApplet.parseInt(_x);
		y = PApplet.parseInt(_y);
	
		anySelected = false;
	
		selectedColor = color(0,0,0,255);
		
									     // column row
		allSwatches.addElement(new Swatch(this, 1, 1, 255, 0, 0));
		allSwatches.addElement(new Swatch(this, 1, 2, 0, 255, 0));
		allSwatches.addElement(new Swatch(this, 1, 3, 0, 0, 255));
		allSwatches.addElement(new Swatch(this, 1, 4, 255, 0, 255));
				
		allSwatches.addElement(new Swatch(this, 2, 1, 0, 0, 0));
		allSwatches.addElement(new Swatch(this, 2, 2, 125, 125, 125));		
		allSwatches.addElement(new Swatch(this, 2, 3, 255, 255, 255));
		
		app.registerDraw(this);
		
		
	}
	
	
	public void draw() {
		
		if(anySelected) {		
			fill(selectedColor);
			rect(PApplet.parseInt(x)+20, PApplet.parseInt(y), 40, 20);			
		} else {
			drawUnselected();
		}
	}
	
	
	public void drawUnselected () {
		fill(0);
		rect(PApplet.parseInt(x)+20, PApplet.parseInt(y), 40, 20);
		stroke(color(255, 0, 0));
		line(PApplet.parseInt(x)+20, PApplet.parseInt(y), PApplet.parseInt(x)+60, PApplet.parseInt(y)+20);
		line(PApplet.parseInt(x)+60, PApplet.parseInt(y), PApplet.parseInt(x)+20, PApplet.parseInt(y)+20);					
	}
	
	
	public void selectColor(int _r, int _g, int _b) {
		selectedColor = color(_r, _g, _b, 255);
	}
}




// PROTO COLOR SQUARE
// -------------------------------------------------------------------------------------------
public class Swatch {
	int r;
	int g;
	int b;
	int x;
	int y;
	int w = 20; 
	int h = w;
	boolean isSelected;
	int sColor;
	
	ColorPalette parent;
			
	
	Swatch(ColorPalette _this, int _column, int _row, int _r, int _g, int _b) {
		r = _r;
		g = _g;
		b = _b;
		
		parent = _this;		
		x = parent.x+(_column*w);
		y = parent.y+10+(_row*h);
		
		sColor = color(r, g, b, 255);
		
		app.registerDraw(this);
		app.registerMouseEvent(this);
		
	}
	
	
	public void draw() {
		
		fill(sColor);
		noStroke();
		rect(x,y,w,h);
	}
	
	
	
	public void mouseEvent(MouseEvent event) {
		int mx = event.getX();
    	int my = event.getY();

		switch (event.getID()) {
			case MouseEvent.MOUSE_RELEASED:
		    	if (checkHit(mx, my)) {
					isSelected = true;
					parent.anySelected = true;
					displayManager.colorPalette.selectColor(r,g,b);
				}
			break;
		}
	}
	
	
	public boolean checkHit(int mx, int my) {

		if (mx >  x && mx <  x+w) {
			if(my >  y && my <  y+h) {
				return true;
			}	
		} 
		return false;
  	}

}











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


public void loadPixelsRandomly() {
	
	for(int i = 0; i <  numPixels; i++) {
		allPixels.get(i).x = PApplet.parseInt(random(1,300));
		allPixels.get(i).y = PApplet.parseInt(random(1,220));		
		allPixels.get(i).w = 20;			
		allPixels.get(i).h = 20;	
		allPixels.get(i).scanned = true; // this displays the pixels	
	}	
}


boolean debug = false;
public void debug() {
	
	debug = !debug;
	
}


public void transmitAndPlayPhysicalPixels() {
	
	// two-dimensional array to store all pixel frames
	int[][] pixelAnimation = new int[numPixels][numFrames];
	
	/*
	// load all images
	for ()
		displayManager.allFrames.get(i)
		

		// load all pixels
		allPixels.get(i).
	*/
}
// ------------------------------------------------------------------------
//
//  LOAD IMAGES AND ANIMATIONS
//
// ------------------------------------------------------------------------


PImage loadedImage;					// stores loaded image
FileDialog fdImg;					// opens file chooser for uploading images
Movie loadedMovie;


Textfield textfieldFrameName;
Textfield textfieldMovieName;

boolean isImageLoaded = false;

int loadImgX = 0;
int loadImgY = 0;


// INTERFACE FOR IMAGE LOADING
// -------------------------------------------------------------------------------------------
public void initLoadImg() {
	
	// Image file chooser
	fdImg = new FileDialog(this.frame, "Select an Image to Load");
	fdImg.setFilenameFilter(new FilenameFilter(){		// NOTE: filter doesn't work on Win platform
		public boolean accept(File dir, String name) {
			return (name.endsWith(".gif") ||
					name.endsWith(".jpg") ||
					name.endsWith(".tga") ||
					name.endsWith(".png"));
		}
	});	
	
	
	
	// Load Image 
	controlP5.addButton("loadImg",
						0,
						40, 550,
						60, 20
						).setCaptionLabel("Load Image");
	
	
	
	// Create Alpha
	controlP5.addButton("loadAlpha",
						0,
						40, 575,
						60, 20
						).setCaptionLabel("Load Alpha");	

	// Create Period
	controlP5.addButton("loadPeriod",
						0,
						40, 600,
						60, 20
						).setCaptionLabel("Load Period");
	
	// Load Video
	controlP5.addButton("loadMovie",
						0,
						40, 625,
						60, 20
						).setCaptionLabel("Load Movie");

	
	// Save Current Frame
	textfieldFrameName = controlP5.addTextfield("frameName")
							.setPosition(40,650)
							.setSize(100,20)
							//.setAutoClear(true)
							.setCaptionLabel("")
							;
	
	
	controlP5.addButton("saveSingleFrame",
						0,
						150, 650,
						60, 20
						).setCaptionLabel("Save Frame");	
	
	
	// Save Movie
	textfieldMovieName = controlP5.addTextfield("movieName")
							.setPosition(40,675)
							.setSize(100,20)
							//.setAutoClear(true)
							.setCaptionLabel("")
							;	

	controlP5.addButton("saveMovie",
						0,
						150, 675,
						60, 20
						).setCaptionLabel("Save Movie");
		
}


// LOAD IMAGE
// -------------------------------------------------------------------------------------------
public void loadImg() {
	
	fdImg.setVisible(true);
	
	if (fdImg.getFile() != null) {
		loadedImage = loadImage(fdImg.getFile());
		loadedImage.resize(320, 240);
		
		displayManager.canvas.loadImageInAllFrames(loadedImage);
		
		isImageLoaded = true;
		
	}	
}



// LOAD ALPHA
// -------------------------------------------------------------------------------------------
public void loadAlpha(){
	
	fdImg.setVisible(true);
	
	if (fdImg.getFile() != null) {
		loadedImage = loadImage(fdImg.getFile());
		loadedImage.resize(320, 240);
		
		displayManager.canvas.loadAlpha(loadedImage);
		
		isImageLoaded = true;
		
	}
}


// LOAD PERIOD
// -------------------------------------------------------------------------------------------
public void loadPeriod(){
	
	fdImg.setVisible(true);
	
	if (fdImg.getFile() != null) {
		loadedImage = loadImage(fdImg.getFile());
		loadedImage.resize(320, 240);
		
		displayManager.canvas.loadPeriod(loadedImage);
		
		isImageLoaded = true;
		
	}
}



// LOAD MOVIE
// -------------------------------------------------------------------------------------------
public void loadMovie() {
	
	
	fdImg.setVisible(true);
	
	if (fdImg.getFile() != null) {
		println(fdImg.getDirectory());
		
		String fullDirectory = fdImg.getDirectory();
		String[] list = split(fullDirectory, "/");
		String folderName = list[list.length-2];
		
		
		displayManager.canvas.loadMovieSequence(folderName);
		
		//loadedImage = loadImage(fdImg.getFile());
		//loadedImage.resize(320, 240);
		
		//displayManager.canvas.loadAlpha(loadedImage);
		
		//isImageLoaded = true;
		
	}
	
	
	
	/* stopped half way
	
	fdImg.setVisible(true);
	
	if (fdImg.getFile() != null) {
		loadedMovie = new Movie(this, fdImg.getFile());
		//loadedImage.resize(320, 240);
		
		displayManager.canvas.loadPeriod(loadedImage);
		
		isImageLoaded = true;
		
	}
	
	saveMovieGrabFrames(textfieldMovieName.getText());
	textfieldMovieName.clear();
	
	*/
	
}



// SAVE FRAME
// -------------------------------------------------------------------------------------------
public void saveSingleFrame() {
	
	displayManager.canvas.saveCurrentFrame(textfieldFrameName.getText());
	textfieldFrameName.clear();
}




// SAVE MOVIE
// -------------------------------------------------------------------------------------------
public void saveMovie() {
	
	displayManager.canvas.saveAllFrames(textfieldMovieName.getText());
	//saveMovieGrabFrames(textfieldMovieName.getText());
	textfieldMovieName.clear();
	
}












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
  public byte chooseFunction(int _function) {
    
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
   

  public byte boundColor(int _color) {
    if (_color >  15) _color = 15;
    return (byte)_color;
  }


  public byte boundPixelId(int _pixelId) {
    if (_pixelId >  255) _pixelId = 255;
    return (byte)_pixelId;
  }

  public void gotConfirmation() {	
	waitingConfirmation = false;
  }

  public void send(int _pixelId, int _function, int _red, int _green, int _blue) {
    
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





// http://wiki.processing.org/w/Register_events

public class PixelController { 
	
	int originX;
	int originY;
	int[] colorAnimationPerPixel = new int[numFrames];
	
	PGraphics frameColors;
	
	PixelController(int _originX, int _originY) {
		
		originX = _originX;
		originY = _originY;
	}
		
	
	public void init() {

		for (int i = 1; i <= numPixels; i++) {
			allPixels.addElement(new Pixel(i, 0, 0, originX, originY));			// load pixels for the first time, but don't display yet
		}
	}
	
	public void updateaAllPixelColorsWithCurrentFrame(PGraphics _frameGraphic) {

		_frameGraphic.beginDraw();
		_frameGraphic.loadPixels();
		
		for(int i = 0; i <  numPixels; i++) {			
			allPixels.get(i).glassC = _frameGraphic.pixels[allPixels.get(i).myCenterInPixelArray()];
			
		}
		
		_frameGraphic.endDraw();		
		
	}



	/*
	void updateaAllPixelColorsWithCurrentFrame(PGraphics _frameGraphic, int _f) {
		
		_frameGraphic.beginDraw();
		_frameGraphic.loadPixels();
		
		for(int i = 0; i < numPixels; i++) {			
			allPixels.get(i).allPixelColors[_f] = _frameGraphic.pixels[allPixels.get(i).myCenterInPixelArray()];
			
		}
		
		_frameGraphic.endDraw();	
	}
	*/
	
	/*void updateAllPixelsWithSingleFrame(PGraphics _frameGraphic) {
		
		
		for (int f = 0; f < numFrames; f++) {

			_frameGraphic.beginDraw();
			_frameGraphic.loadPixels();

			for(int i = 0; i < numPixels; i++) {			
				allPixels.get(i).allPixelColors[f] = _frameGraphic.pixels[allPixels.get(i).myCenterInPixelArray()];

			}

			_frameGraphic.endDraw();
			
			
		}
		
		
		
		
		
		//for (int f = 0; f < numFrames; f++) {
		//	//allPixels.get(i).allPixelColors[_f] = _frameGraphic.pixels[allPixels.get(i).myCenterInPixelArray()];
		//	
		//	updateaAllPixelColorsWithCurrentFrame(_frameGraphic, f);
		//	
		//	println("4");
		//}	
		
	}*/
	
	
	
}



public class Pixel {
  int id;
  int x;
  int y;
  int w;
  int h;
  int originX;
  int originY;
  int border;
  int rimC;
  int glassC;
  boolean hidden;
  boolean selected;
  boolean scanned;
  boolean labelWithId;
  Point centroid;
  	
  int[] allPixelColors;

  Pixel(int _id, int _x, int _y, int _originX, int _originY) {
    id = _id;
    x = _x;
    y = _y;
	originX = _originX;
	originY = _originY;
    w = 20;
    h = w;
    border = 2;
    rimC = color(255,255,255);
    glassC = color(125,125,125);
    hidden = true;
	selected = false;
	scanned = false;			// when true, pixel has been found by vision tracker
	labelWithId = true;
	
	allPixelColors = new int[numFrames];		// stores pixel colors for a whole animation
    
    app.registerDraw(this);
    app.registerMouseEvent(this);
  }
  
  public void draw() {
   
	if (scanned) {

		pushMatrix();
		translate(originX+x, originY+y);
		
	     	stroke(125);
	     	fill(rimC);
	     	rect(0,0,w,h); 
     
	     	//fill(allPixelColors[displayManager.animation.currentFrame-1]);
	     	fill(glassC);
			rect(border,border,w-border*2,h-border*2);
			noStroke();

			if (labelWithId) {
				textSize(10);
				fill(255, 255, 255);
				text(id+"", w+3, -10, 20, 20);		//pixel id
				//text(x+","+y, w+3, -10, 40, 20);		// pixel x,y location
				//text(x + 320*y+"", w+3, -10, 60, 20);	// pixel location in pixel array
			}
		
		popMatrix();
    }
  }
  
	public void debug() {
		pushMatrix();
		translate(400+x, 600+y);
		stroke(125);
     	fill(rimC);
     	rect(0,0,w,h); 
 
     	fill(allPixelColors[8]);
     	rect(border,border,w-border*2,h-border*2);
		noStroke();	
		popMatrix();
	}


	public int myCenterInPixelArray() {

		int myCenter = x+10 + (320*(y+10));
		return myCenter;	
	}


   public void mouseEvent(MouseEvent event) {
		int mx = event.getX();
    	int my = event.getY();

		switch (event.getID()) {
			case MouseEvent.MOUSE_MOVED:
				if (checkHit(mx, my) && selected != true) {
					rimC = color(0,0,255);
				} else if (selected != true) {
					rimC = color(255,255,255);
				}
			    break;
			 //case MouseEvent.MOUSE_CLICKED:
			case MouseEvent.MOUSE_RELEASED:
		    	if (checkHit(mx, my)) {
					if (selected == false) {
						rimC = color(0,255,0);
						selected = true;
					} else if (selected == true) {
						rimC = color(0,0,255);
						selected = false;						
					}
				}
				break;
			//case MouseEvent.MOUSE_DRAGGED:
			//case MouseEvent.MOUSE_PRESSED:
			//default:	
			}
  }
  
  public boolean checkHit(int mx, int my) {
	
	if (mx >  x && mx <  x+w) {
		if(my >  y && my <  y+h) {
			return true;
		}	
	} 
	return false;
  }	

}














Serial myPort;


// Init stuff
// --------------------------------------------------------------------------------------------------------------
public void initSerial() {
	String portName = Serial.list()[0];						// first available port
	myPort = new Serial(this, portName, 115200); 				// Serial 'myPort'; port 'portName'
}


// Serial Event for incoming data
// --------------------------------------------------------------------------------------------------------------
public void serialEvent (Serial myPort) {
	
	

	packet.gotConfirmation();


	
}




public void colorPixel(int _pixelID, int _c) {
	myPort.write(_pixelID);          
  	myPort.write(PApplet.parseInt(red(_c)));
  	myPort.write(PApplet.parseInt(green(_c)));
  	myPort.write(PApplet.parseInt(blue(_c)));
}


/*
// Turn single pixel IR ON
// --------------------------------------------------------------------------------------------------------------
void turnSinglePixelIrOn(int _pixelID) { 
    myPort.write(0x0);          
    myPort.write(_pixelID);
    myPort.write(0xAA);
    myPort.write(0xFF);
    delay(100);
}


// Turn single pixel IR OFF
// --------------------------------------------------------------------------------------------------------------
void turnSinglePixelIrOff(int _pixelID) { 
    myPort.write(0x0);          
    myPort.write(_pixelID);
    myPort.write(0xCC);
    myPort.write(0xFF);
    //delay(100);
}
*/








//ControlP5 vCP5;

OpenCV opencv;
//Capture myCapture;
//String[] captureDevices;


int vBrightness = 0;
int vContrast = 0;
int vThreshold = 190;
int minBlobArea = 50;
int maxBlobArea = 3000;

int displayWidth = 320;
int displayHeight = 240;

int visionX = 900;
int visionY = 20;

int menuX = visionX;
int menuY = 380+visionY;

boolean displayId = false;



// Load up all camera related stuff
// -------------------------------------------------------------------------------------------
public void initVision() {
	
	opencv = new OpenCV(this);
	
	opencv.capture(displayWidth, displayHeight);
	
	opencv.allocate(displayWidth, displayHeight);

	
	initVizControls();
	
}




// Display camera views
// -------------------------------------------------------------------------------------------
public void loadCameraViews() {

	opencv.read();

	opencv.brightness(vBrightness);
	opencv.contrast(vContrast);


	
	image( opencv.image(), visionX, visionY );								// top SOURCE IMAGE
	image( opencv.image(OpenCV.MEMORY), visionX, visionY+254, 160, 120 );			// left IMAGE STORED IN MEMORY
	
	
	opencv.absDiff();
	opencv.threshold(vThreshold);
	
	image( opencv.image(), visionX+165, visionY+254, 160, 120 );						// right BUFFERED OPENCV.IMAGE()
	PImage buffered = opencv.image();
	

	Blob[] blobs = opencv.blobs( minBlobArea, maxBlobArea, numPixels, false );
			
			
	noFill();

	
	// DRAW BLOBS
    for( int i=0; i <  blobs.length; i++ ) {
		
		
		// Draw Blobs (RED)
		stroke(255, 0, 153);
		beginShape();
		for( int j=0; j <  blobs[i].points.length; j++ ) {
            vertex( blobs[i].points[j].x+visionX, blobs[i].points[j].y+visionY );
		}
		endShape(CLOSE);


		// draw bounding rectangles (GREEN)
		stroke(0, 220, 50);
		Rectangle bounding_rect = blobs[i].rectangle;
		rect( bounding_rect.x+visionX, bounding_rect.y+visionY, bounding_rect.width, bounding_rect.height );


		// draw centroids (BLUE)
		stroke(0, 255, 255);
		Point centroid = blobs[i].centroid;
		line(centroid.x-2+visionX, centroid.y-2+visionY, centroid.x+2+visionX, centroid.y+2+visionY);
		line(centroid.x-2+visionX, centroid.y+2+visionY, centroid.x+2+visionX, centroid.y-2+visionY);

    }

}



// LOCATE PIXELS
// -------------------------------------------------------------------------------------------
public void matchPix() {
	
	// show IR in quick succession
	for (int i = 0; i <  numPixels; i++) {
						
			allPixels.get(i).scanned = true;
			
			// send IR			
			packet.send( i+1, IR, 119, 0, 0 );			// ir=63; delay=240;

			// wait for pixels to display IR
			delay(220);
			
			// read and remember image with IR
			//myCapture.read();
			//opencv.copy(myCapture);
			opencv.read();

			opencv.remember(1);
			
			// wait for pixels to finish IR
			delay(210);
			
			// read image without IR
			//myCapture.read();
			//opencv.copy(myCapture);
			opencv.read();

			
			// compare images with and without IR
			opencv.absDiff();
			opencv.threshold(vThreshold);

			// assign pixel irImage
			//allPixels.get(i).irImage = opencv.image();
			//allPixels.get(i).irDefault = new LabeledVer(opencv.image(), "Pixel "+(i+1)).image();
			//imageCollection.add(opencv.image());
			//imageCollection.add(allPixels.get(i).irDefault);

			// find blobs in thresholded image
			Blob[] oneBlob = opencv.blobs( minBlobArea, maxBlobArea, 1, false );

			
			if (oneBlob.length != 0) {
				// assign pixel rectangle
				allPixels.get(i).x = oneBlob[0].rectangle.x;
				allPixels.get(i).y = oneBlob[0].rectangle.y;
				allPixels.get(i).w = oneBlob[0].rectangle.width;
				allPixels.get(i).h = oneBlob[0].rectangle.height;
				
				// assign pixel centroid
				allPixels.get(i).centroid = oneBlob[0].centroid;

				//long mp2 = System.currentTimeMillis()-mp1;
				//println("[MATCHPIX] elapsed time: "+mp2);
				
			} else {
				allPixels.get(i).scanned = false;	// pixels unsuccessfully matched will not be labeled
			}

	
			// update pixel assignments (according to uploaded image)
			//if (overlayUpload) pngAssigned = false;
	
	}

}






// Interface Loading 
// -------------------------------------------------------------------------------------------
public void initVizControls() {
	
	//vCP5 = new ControlP5(this);
	
	
	controlP5.addSlider("contrast",
						-128, 128,
						vContrast,
						menuX, menuY+10,
						200, 15
						);
						
	controlP5.addSlider("brightnessLevel",
						-128, 128,
						vBrightness,
						menuX, menuY+30,
						200, 15
						);
						
	controlP5.addSlider("threshold",
						0, 255,
						vThreshold,
						menuX, menuY+50,
						200, 15
						);
						
	controlP5.addRange("blobArea",
						10,			// theMin
						4000, 			// theMax
						minBlobArea,	// theDefaultMinValue
						maxBlobArea, 	// theDefaultMaxValue
						menuX, menuY+70,	// theX, theY
						200,15			// theWidth, theHeight
						);
						
	controlP5.addButton("labelPix",
						0,
						menuX, menuY+90,
						60, 15
						);
						
						
	
						
	controlP5.addButton("matchPix",
						0,
						menuX+70, menuY+90,
						60, 15
						);

						
}



// Interface Assignments 
// -------------------------------------------------------------------------------------------
public void contrast() {
	vContrast = (int)(controlP5.controller("contrast").value());
}

public void brightnessLevel() {
	vBrightness = (int)(controlP5.controller("brightnessLevel").value());
} 

public void threshold() {
	vThreshold = (int)(controlP5.controller("threshold").value());
}

public void blobArea() {
	minBlobArea = (int)(controlP5.controller("blobArea").arrayValue()[0]);
	maxBlobArea = (int)(controlP5.controller("blobArea").arrayValue()[1]);
}

public void labelPix() {
	for (int i = 1; i <= numPixels; i++) {
		allPixels.get(i).labelWithId = !allPixels.get(i).labelWithId;
	}
}














  static public void main(String args[]) {
    PApplet.main(new String[] { "--bgcolor=#FFFFFF", "AmorphousDisplay" });
  }
}
