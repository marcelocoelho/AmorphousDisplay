

	

// HANDLES ALL THE IMAGE CREATION ELEMENTS
// -------------------------------------------------------------------------------------------
public class DisplayManager {
	
	Canvas canvas;
	ColorPalette colorPalette;
	Animation animation;
	
	
	DisplayManager() {
		
		canvas = new Canvas(40,200,320,240);
		colorPalette = new ColorPalette();
		animation	= new Animation();
		
		app.registerDraw(this);
	
		initAnimationInterface();	
	}
	
	
	
	void draw() {
		
		controlP5.getController("browser").setValue(displayManager.animation.currentFrame);

	}
	
	

	
}



// Interface Assignments 
// -------------------------------------------------------------------------------------------
void initAnimationInterface() {
	
	controlP5.addSlider("browser")											// slider
     		.setPosition(200,140)
     		.setSize(320,20)
     		.setRange(1,numFrames)
     		.setNumberOfTickMarks(numFrames)
     		;
	controlP5.getController("browser").setCaptionLabel("Timeline");
					
	controlP5.addButton("playPause",										// play button	
								0,
								100, 500,
								60, 15
								);							
													
	controlP5.addCheckBox("autoLoop", 400, 290).addItem("loop", 0);				// loop button		
	
	
}



void playPause() {
	
	displayManager.animation.playPause();
	
	
	
}




public class Animation {
	
	int initFrame;
	int currentFrame;
	int finalFrame;
	float runningTime;
	
	float scrollSpeed;
	
	boolean isPlaying = false;
	
	Animation() {
		
		initFrame = 1;
		currentFrame = 1;
		runningTime = 1;
		finalFrame = 10;
		scrollSpeed = 0.5;
		
		app.registerDraw(this);
	}
	
	void draw() {
		
		if (isPlaying) {
			if (currentFrame > finalFrame) {
				currentFrame = 1;
				runningTime = 1;
			} else {
				runningTime = runningTime+scrollSpeed/frameRate;
				currentFrame = int(runningTime);
				//currentFrame = int(currentFrame+scrollSpeed/frameRate);
			}
		}
		println(currentFrame);
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





// CANVAS FOR DRAWING AND DISPLAYING LOADED IMAGES
// -------------------------------------------------------------------------------------------
public class Canvas {
	
	int x, y, w, h;
	
	int currentFrame;
	
	Vector<Frame> allFrames = new Vector<Frame>();
		
	Canvas( int _x, int _y, int _w, int _h ) {
		x = _x;
		y = _y;
		w = _w;
		h = _h;
		
		currentFrame = 0;
		
		// load frames
		for (int i = 0; i < numFrames; i++) {
			allFrames.addElement(new Frame(200,200, 320, 240));
		}
		
		// set-up each frame with a white background
		for (int i = 0; i < numFrames; i++) {
			allFrames.get(i).init();
		}
		
		app.registerDraw(this);
		app.registerMouseEvent(this);
	}
	
	void draw() {
		
		//draw current frame
		currentFrame = (int)controlP5.getController("browser").getValue()-1;
		allFrames.get(currentFrame).drawFrame();
		
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




/*
// CANVAS FOR DRAWING AND DISPLAYING LOADED IMAGES
// -------------------------------------------------------------------------------------------
public class Canvas {
	
	int x, y, w, h;
	
	PGraphics drawingSheet;
	PImage loadedImage;
	
	
	Canvas( int _x, int _y, int _w, int _h ) {
		x = _x;
		y = _y;
		w = _w;
		h = _h;
		
		initDrawingSheet();	
			
		app.registerDraw(this);
		app.registerMouseEvent(this);
			
	}
		
	void initDrawingSheet() {
		drawingSheet = createGraphics(w,h, P2D);
		drawingSheet.beginDraw();
		drawingSheet.background(255);		
		drawingSheet.endDraw();			
	}
	
	void drawWithBrush() {
		drawingSheet.beginDraw();
		drawingSheet.smooth();
		drawingSheet.fill(displayManager.colorPalette.selectedColor);
		drawingSheet.noStroke();
		drawingSheet.ellipseMode(CENTER);
		drawingSheet.ellipse(mouseX-x,mouseY-y,20,20);
		drawingSheet.endDraw();
	}
	
	void displayLoadedImage(PImage _loadedImage) {
		//drawingSheet = (PGraphics)_loadedImage;
		
		loadedImage = _loadedImage;
		//println("imageloaded");
	}
	
	
	
	void draw() {
		image(drawingSheet,x,y);
	
		if (isImageLoaded) {
			image(loadedImage,300,400);
		}
	
	}
	
	
	void mouseEvent(MouseEvent event) {
	
		switch (event.getID()) {
			
				case MouseEvent.MOUSE_DRAGGED:
					drawWithBrush();
				break;
				
				case MouseEvent.MOUSE_PRESSED:
					drawWithBrush();
				break;
			
		}
	}

}
*/



public class Frame {
	
	PGraphics frameGraphic;
	int x,y,w,h;
	
	Frame(int _x, int _y, int _w, int _h) {
		
		x = _x;
		y = _y;
		w = _w;
		h = _h;
		
		frameGraphic = createGraphics(w, h, P2D);
	}		
	
	void init() {
	
		frameGraphic.beginDraw();
		frameGraphic.background(255);		
		frameGraphic.endDraw();	

		
	}
	
	
	void drawFrame() {
		
		image(frameGraphic,x,y);
	}
	
	void pencilDown() {
		frameGraphic.beginDraw();
		frameGraphic.smooth();
		frameGraphic.fill(displayManager.colorPalette.selectedColor);
		frameGraphic.noStroke();
		frameGraphic.ellipseMode(CENTER);
		frameGraphic.ellipse(mouseX-x,mouseY-y,20,20);
		frameGraphic.endDraw();
	}
}
	
	
	
	





// COLORS THAT CAN BE USED TO DRAW ON CANVAS
// -------------------------------------------------------------------------------------------
public class ColorPalette {

	Vector<Swatch> allSwatches = new Vector<Swatch>();	
	
	color selectedColor;
	
	
	ColorPalette() {
	
		selectedColor = color(255,255,255,255);
		
		allSwatches.addElement(new Swatch(20, 20, 255, 0, 0));
		allSwatches.addElement(new Swatch(20, 42, 0, 255, 0));
		
		app.registerDraw(this);
		
		
	}
	
	void draw() {
		
		fill(selectedColor);
		rect(0,0,100,20);
	}
	
	
	void selectColor(int _r, int _g, int _b) {
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
	int h = 20;
	boolean isSelected;
	color sColor;
			
	
	Swatch(int _x, int _y, int _r, int _g, int _b) {
		r = _r;
		g = _g;
		b = _b;
		x = _x;
		y = _y;
		
		sColor = color(r, g, b, 255);
		
		app.registerDraw(this);
		app.registerMouseEvent(this);
		
	}
	
	
	void draw() {
		
		fill(sColor);
		noStroke();
		rect(x,y,w,h);
	}
	
	
	
	void mouseEvent(MouseEvent event) {
		int mx = event.getX();
    	int my = event.getY();

		switch (event.getID()) {
			case MouseEvent.MOUSE_RELEASED:
		    	if (checkHit(mx, my)) {
					isSelected = true;
					displayManager.colorPalette.selectColor(r,g,b);
				}
			break;
		}
	}
	
	
	boolean checkHit(int mx, int my) {

		if (mx > x && mx < x+w) {
			if(my > y && my < y+h) {
				return true;
			}	
		} 
		return false;
  	}

}








