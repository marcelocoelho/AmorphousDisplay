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

import processing.video.*;				// moviemaker

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
		
		//w = 320;		
		//h = 240;
		
		startPosition = new PVector(appMarginSides,appMarginTop);		// change these to modify interface look
		dimension = new PVector(320,240);
		//x = 40;
		//y = 200;
		

		canvas = new Canvas(root, startPosition, dimension);		
		colorPalette = new ColorPalette(startPosition.x + dimension.x, startPosition.y);
		animation	= new Animation(startPosition.x, startPosition.y + dimension.y, dimension.x);
		
		app.registerDraw(this);
	}
	
	
	void draw() {
		
			
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
		scrollSpeed = 0.5;
		
		app.registerDraw(this);
		
		initAnimationInterface(_x, _y, _w, scrollSpeed);
	}
	
	void draw() {
		
		if (isPlaying) {
			controlP5.getController("playPause").setCaptionLabel("pause");
			if (currentFrame > finalFrame) {
				currentFrame = 1;
				runningTime = 1;
			} else {
				runningTime = runningTime+scrollSpeed/frameRate;
				currentFrame = int(runningTime);
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

	
	void playPause() {
		
		isPlaying = !isPlaying;

	}
	
	void pause() {
		
		//isPlaying = false;
	}
	
	void stop() {
		
	}
	
	void resume() {
		
	}
	
}


// Animation Interface Assignments 
// -------------------------------------------------------------------------------------------
void initAnimationInterface(float _x, float _y, float _w, float _speed) {
	
	controlP5.addSlider("browser")											// slider for animation control
     		.setPosition(_x,_y+5)
     		.setSize(int(_w),20)
     		.setRange(1,numFrames)
     		.setNumberOfTickMarks(numFrames)
     		;
			controlP5.getController("browser").setCaptionLabel("Timeline");
					
	controlP5.addButton("playPause",										// play or pause animation	
			0,
			int(_x), int(_y)+40,
			60, 20
			);		
			controlP5.getController("playPause").setCaptionLabel("Play");	
			
	
	controlP5.addNumberbox("updateScrollSpeed")									//scroll speed
		     .setPosition(int(_x)+130, int(_y)+40)
		     .setSize(60,20)
		     .setRange(0.1, 10)
			 .setMultiplier(1)
		     .setValue(_speed)
			 .setCaptionLabel("Scroll Speed")
		     ;


	/* ------  color palette related, moved it to a different class later? ---- */

	controlP5.addButton("clearFrame",										// clear all frames	
			0,
			int(_x)+325, int(_y)-45,
			70, 20
			);		
			controlP5.getController("clearFrame").setCaptionLabel("Clear Frame");

	controlP5.addButton("clearAll",										// clear all frames	
			0,
			int(_x)+325, int(_y)-20,
			70, 20
			);		
			controlP5.getController("clearAll").setCaptionLabel("Clear All");																									
}

void playPause() {

	displayManager.animation.playPause();
}

void updateScrollSpeed() {
	//displayManager.animation.scrollSpeed = controlP5.getController("updateScrollSpeed").getValue();
}

void clearAll() {
	displayManager.canvas.clearAll();
}

void clearFrame() {
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
		for (int i = 0; i < numFrames; i++) {
			allFrames.addElement(new Frame(_startPosition.x, _startPosition.y, _dimension.x, _dimension.y));
		}
		
		// set-up each frame with a black background
		for (int i = 0; i < numFrames; i++) {
			allFrames.get(i).init();
		}
		
		app.registerDraw(this);
		app.registerMouseEvent(this);
	}
	
	void draw() {
		
		// draw current frame
		currentFrame = displayManager.animation.currentFrame-1;
		allFrames.get(currentFrame).drawFrame();
		
	}
	
	
	void clearCurrentFrame() {
		allFrames.get(currentFrame).init();
	}
	
	void clearAll() {
		for (int i = 0; i < numFrames; i++) {
			allFrames.get(i).init();			
		}
	}
	
	/*PGraphics getSpecificFrame(int _specificFrame) {
		return allFrames.get(_specificFrame).frameGraphic;
		
	}*/
	
	color getColorFromCurrentFrame(int _pixelLocation) {
		
		return allFrames.get(currentFrame).getColor(_pixelLocation);
	}
	
	
	void saveCurrentFrame(String _filename) {
		allFrames.get(currentFrame).frameGraphic.save("data/saved/"+ _filename +".png");
	}
	
	void saveAllFrames(String _folderName) {
		for (int i = 0; i < numFrames; i++) {
			allFrames.get(i).frameGraphic.save("data/"+_folderName+"/frame"+ i +".png");			
		}
	}
	
	void loadMovieSequence(String _folderName) {
		
		PImage tempImage;
		
		for (int i = 0; i < numFrames; i++) {
			tempImage = loadImage(_folderName+"/frame"+ i +".png");
			allFrames.get(i).loadImage(tempImage);
		}
	}
	


	void loadImageInAllFrames(PImage _selectedImage) {
		
		for (int i = 0; i < numFrames; i++) {
			allFrames.get(i).loadImage(_selectedImage);
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
			allFrames.get(i).loadImage(_loadedImage);		
		}
		

	}
	*/
	
	
	void loadAlpha(PImage _alphaImage) {
		
		PGraphics alphaImage = createGraphics(320,240, P2D);
		PGraphics tempImage = createGraphics(320,240, P2D);
		
		//_alphaImage.loadPixels();

		alphaImage.beginDraw();
		alphaImage.image(_alphaImage, 0, 0);
		alphaImage.filter(GRAY);
		alphaImage.filter(POSTERIZE, numFrames);  		
		alphaImage.endDraw();
		
		for (int i = 0; i < numFrames; i++) {

			tempImage.beginDraw();
			
			tempImage.copy(alphaImage,0,0,320,240,0,0,320,240);
			
			tempImage.loadPixels();	
			
			float boundary = map(i, 0, 9, 0, 255);
			//println(int(boundary));
			
			
			for (int j = 0; j < tempImage.pixels.length; j++) {
				
				if (red(tempImage.pixels[j]) > int(boundary)+2 || red(tempImage.pixels[j]) < int(boundary)-2) {  // 2 here is just a margin of safety
			     tempImage.pixels[j] = color(0,0,0,255);
			   } else {
			     tempImage.pixels[j] = color(255,255,255,0);     
			   }
			}
			
			//_alphaImage.updatePixels();
			
			tempImage.updatePixels();
			tempImage.endDraw();
			
			allFrames.get(i).loadImage(tempImage);
		}		
	}
	
	
	
	void loadPeriod(PImage _periodImage) {
		
		PGraphics periodImage = createGraphics(320,240, P2D);
		PGraphics tempImage = createGraphics(320,240, P2D);
		
		
		periodImage.beginDraw();
		periodImage.image(_periodImage, 0, 0);
		periodImage.filter(GRAY);
		periodImage.filter(POSTERIZE, 10);  // 10 is numebr of frames		
		periodImage.endDraw();
		
		for (int i = 0; i < numFrames; i++) {

			tempImage.beginDraw();
			
			tempImage.copy(periodImage,0,0,320,240,0,0,320,240);
			
			tempImage.loadPixels();	
			
			float boundary = map(i, 0, 9, 0, 255);
			//println(int(boundary));
			
			
			for (int j = 0; j < tempImage.pixels.length; j++) {
				
				if (red(tempImage.pixels[j]) > int(boundary)+2) {  // 2 here is just a margin of safety
			     tempImage.pixels[j] = color(0,0,0,255);
			   } else {
			     tempImage.pixels[j] = color(255,255,255,0);     
			   }
			}
			
			
			tempImage.updatePixels();
			tempImage.endDraw();
			
			allFrames.get(i).loadImage(tempImage);
		}
	}


	
	
	void mouseEvent(MouseEvent event) {
	
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
void saveMovieGrabFrames(String _filename) {
	
	movieToSave = new MovieMaker(this, 320, 240, "data/saved/"+_filename+".mov");
	
	for (int i = 0; i < numFrames; i++) {
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
		
		frameGraphic = createGraphics(int(_w), int(_h), P2D);
	}		
	
	void init() {
	
		frameGraphic.beginDraw();
		frameGraphic.background(0);		
		frameGraphic.endDraw();	
	}
	
	
	void drawFrame() {
		
		image(frameGraphic, x, y);
	}
	
	void pencilDown() {
		frameGraphic.beginDraw();
		frameGraphic.smooth();
		frameGraphic.fill(displayManager.colorPalette.selectedColor);
		frameGraphic.noStroke();
		frameGraphic.ellipseMode(CENTER);
		frameGraphic.ellipse(mouseX - x, mouseY - y, 20, 20);
		frameGraphic.endDraw();
	}
	
	void loadImage(PImage _selectedImage) {
		frameGraphic.beginDraw();
		frameGraphic.fill(0);
		frameGraphic.image(_selectedImage,0,0);
		frameGraphic.endDraw();
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
	
	color getColor(int _pixelLocation) {
		
		color tempColor;
				
		frameGraphic.beginDraw();
		frameGraphic.loadPixels();
		tempColor = frameGraphic.pixels[_pixelLocation];
		frameGraphic.endDraw();

		return tempColor;	
	}
	
	
	int[] returnPixelArray() {
		
		frameGraphic.beginDraw();
		frameGraphic.loadPixels();

		int[] tempArray = new int[320*240];
		
		for (int j = 0; j < frameGraphic.pixels.length; j++) {
			tempArray[j] = frameGraphic.pixels[j];
		}
		
		return tempArray;
	}
	
}
	
	
	
	



