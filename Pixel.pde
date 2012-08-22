



// http://wiki.processing.org/w/Register_events

public class PixelController { 
	
	int pixelOriginX = leftColumnX;
	int pixelOriginY = leftColumnY;
	
	int pixelTimelineOriginX = middleColumnX;
	int pixelTimelineOriginY = middleColumnY;
	
	int pixelTimelineWidth = frameWidth/numFrames;
	int pixelTimelineHeight = 20;
	
	int spacer = 1;
	
	PGraphics frameColors;
	
	PixelController() {
		
		app.registerDraw(this);
	}
		
	
	
	void init() {		// Load pixels for the first time, but don't display yet

		for (int i = 1; i <= numPixels; i++) {
			allPixels.addElement(new Pixel(i, 0, 0, pixelOriginX, pixelOriginY));			
		}
	}
	
	
	
	void draw() {		// Update all pixels with all frames

		for (int f = 0; f < numFrames; f++) {

			int[] imagePixelArray = displayManager.canvas.allFrames.get(f).returnPixelArray();

			for (int p = 0; p < numPixels; p++) {

				allPixels.get(p).allPixelColors[f] = imagePixelArray[ allPixels.get(p).myCenterInPixelArray() ];
				noStroke();
				fill( allPixels.get(p).allPixelColors[f] );
				rect( pixelTimelineOriginX+(f*pixelTimelineWidth), pixelTimelineOriginY + (p * (pixelTimelineHeight + spacer)), pixelTimelineWidth, pixelTimelineHeight );

			}
		}		
	}	
	
	
	
	void updateaAllPixelColorsWithCurrentFrame(PGraphics _frameGraphic) {

		_frameGraphic.beginDraw();
		_frameGraphic.loadPixels();
		
		for(int i = 0; i < numPixels; i++) {			
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
	     	//fill(glassC);
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
  
	void debug() {
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













