

// http://wiki.processing.org/w/Register_events

public class Pixel {
  int id;
  int x;
  int y;
  int w;
  int h;
  int border;
  color rimC;
  color glassC;
  boolean hidden;
  boolean selected;
  boolean scanned;
  boolean labelWithId;
  Point centroid;
  	


  Pixel(int _id, int _x, int _y) {
    id = _id;
    x = _x;
    y = _y;
    w = 20;
    h = w;
    border = 2;
    rimC = color(255,255,255);
    glassC = color(125,125,125);
    hidden = true;
	selected = false;
	scanned = false;			// when true, pixel has been found by vision tracker
	labelWithId = true;
    
    app.registerDraw(this);
    app.registerMouseEvent(this);
  }
  
  void draw() {
   
	if (scanned) {


		pushMatrix();
		translate(x,y);
		
	     	noStroke();
	     	fill(rimC);
	     	rect(0,0,w,h); 
     
	     	fill(glassC);
	     	rect(border,border,w-border*2,h-border*2);

			if (labelWithId) {
				textSize(10);
				fill(255, 255, 255);
				text(id+"", w+3, -10, 20, 20);
			}
		
		popMatrix();
    }
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


  //void updatePhysical() {
	//colorPixel(id, glassC);
  //}

}

