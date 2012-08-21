



// http://wiki.processing.org/w/Register_events

public class PixelController { 
	
	int originX;
	int originY;
	color[] colorAnimationPerPixel = new color[numFrames];
	
	PGraphics frameColors;
	
	PixelController(int _originX, int _originY) {
		
		originX = _originX;
		originY = _originY;
		
		app.registerDraw(this);
	}
	
	
	void draw() {	
				
		updateaAllPixelColorsWithCurrentFrame(displayManager.animation.currentFrame);				//populate pixels with colors from current frame
	}
	
	
	void init() {

		for (int i = 1; i <= numPixels; i++) {
			allPixels.addElement(new Pixel(i, 0, 0, originX, originY));			// load pixels for the first time, but don't display yet
		}
	}
	
	void updateaAllPixelColorsWithCurrentFrame(int _frameToGetColorsFrom) {

		
		_frameToGetColorsFrom = _frameToGetColorsFrom - 1;		// adjusting frame number so it matches actual frame value 1-10, rather than 0-9
	
		displayManager.canvas.allFrames.get(_frameToGetColorsFrom).frameGraphic.beginDraw();
		displayManager.canvas.allFrames.get(_frameToGetColorsFrom).frameGraphic.loadPixels();
		
		for(int i = 0; i < numPixels; i++) {			
			allPixels.get(i).allPixelColors[_frameToGetColorsFrom] = displayManager.canvas.allFrames.get(_frameToGetColorsFrom).frameGraphic.pixels[allPixels.get(i).myCenterInPixelArray()];
		}
		
		displayManager.canvas.allFrames.get(_frameToGetColorsFrom).frameGraphic.endDraw();
		

		/*/////// This could be made more efficient by loading all the pixels colors with a single frame load
		///////// code above does that
		//cycle through all pixels
		for(int i = 0; i < numPixels; i++) {
			// and query canvas for their color. pass to canvas the pixel location
			allPixels.get(i).glassC = displayManager.canvas.getColorFromCurrentFrame(allPixels.get(i).myCenterInPixelArray());
			
		}
		*/	
	}
	
	void updateAllPixelsWithNewFrame() {
		
		for (int i = 0; i < numFrames; i++) {
			updateaAllPixelColorsWithCurrentFrame(i);
		}
		
	}
	
	
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
  color rimC;
  color glassC;
  boolean hidden;
  boolean selected;
  boolean scanned;
  boolean labelWithId;
  Point centroid;
  	
  color[] allPixelColors;

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
	
	allPixelColors = new color[numFrames];		// stores pixel colors for a whole animation
    
    app.registerDraw(this);
    app.registerMouseEvent(this);
  }
  
  void draw() {
   
	if (scanned) {

		pushMatrix();
		translate(originX+x, originY+y);
		
	     	stroke(125);
	     	fill(rimC);
	     	rect(0,0,w,h); 
     
	     	fill(allPixelColors[displayManager.animation.currentFrame-1]);
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
  

	int myCenterInPixelArray() {

		int myCenter = x+10 + (320*(y+10));
		
		return myCenter;	
	}


   void mouseEvent(MouseEvent event) {
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
  
  boolean checkHit(int mx, int my) {
	
	if (mx > x && mx < x+w) {
		if(my > y && my < y+h) {
			return true;
		}	
	} 
	return false;
  }	

}













