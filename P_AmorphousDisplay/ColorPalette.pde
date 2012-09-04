




// COLORS THAT CAN BE USED TO DRAW ON CANVAS
// -------------------------------------------------------------------------------------------
public class ColorPalette {

	Vector<Swatch> allSwatches = new Vector<Swatch>();	
	
	boolean anySelected;
	
	color selectedColor;
	
	int x, y;
	
	ColorPalette(float _x,  float _y) {
	
		x = int(_x);
		y = int(_y);
	
		anySelected = false;
	
		selectedColor = color(0,0,0,255);
		
		
									     // column row				
		// shades of grey
		for (int i = 2; i <= 15; i=i+2) {
			allSwatches.addElement(new Swatch(this,	i/2,	1,	remap(15-i), remap(15-i), remap(15-i)));			
			
		}
		
		// shades of green and blue
		for (int i = 1; i <= 15; i++) {
			allSwatches.addElement(new Swatch(this,	i,	2,	0, remap(i), remap(15-i)));			
		}		
		
		// shades of red and blue
		for (int i = 1; i <= 15; i++) {
			allSwatches.addElement(new Swatch(this,	i,	3,	remap(i), 0, remap(15-i)));			
		}		
		
		// shades of red and green
		for (int i = 1; i <= 15; i++) {
			allSwatches.addElement(new Swatch(this,	i,	4,	remap(i), remap(15-i), 0));			
		}		
		
		// shades of red and green
		for (int i = 1; i <= 8; i++) {
			allSwatches.addElement(new Swatch(this,	i,	5,	remap(15-i), remap(15-i), 0));			
		}		
		
		// shades of red and green
		for (int i = 1; i <= 8; i++) {
			allSwatches.addElement(new Swatch(this,	i,	6,	remap(15-i), 0, remap(15-i)));			
		}		
		
		// shades of red and green
		for (int i = 1; i <= 8; i++) {
			allSwatches.addElement(new Swatch(this,	i,	7,	0, remap(15-i), remap(15-i)));			
		}		
		
		/*
		allSwatches.addElement(new Swatch(this,	1,	1,	255, 255, 255));							
		allSwatches.addElement(new Swatch(this,	2,	1,	238, 238, 238));
		allSwatches.addElement(new Swatch(this,	3,	1,	221, 221, 221));
		allSwatches.addElement(new Swatch(this,	4,	1,	204, 255, 255));							
		allSwatches.addElement(new Swatch(this,	5,	1,	187, 238, 238));
		allSwatches.addElement(new Swatch(this,	6,	1,	170, 221, 221));
		allSwatches.addElement(new Swatch(this,	7,	1,	153, 255, 255));							
		allSwatches.addElement(new Swatch(this,	8,	1,	136, 238, 238));
		allSwatches.addElement(new Swatch(this,	9,	1,	119, 221, 221));		
		allSwatches.addElement(new Swatch(this,	10,	1,	102, 221, 221));
		allSwatches.addElement(new Swatch(this,	11,	1,	85, 221, 221));
		allSwatches.addElement(new Swatch(this,	12,	1,	68, 221, 221));
		allSwatches.addElement(new Swatch(this,	13,	1,	51, 221, 221));						
		allSwatches.addElement(new Swatch(this,	14,	1,	34, 221, 221));
		allSwatches.addElement(new Swatch(this,	15,	1,	17, 221, 221));
		allSwatches.addElement(new Swatch(this,	16,	1,	0, 221, 221));
		*/	

		/*							
		allSwatches.addElement(new Swatch(this,	1,	1,	255, 0, 0));
		allSwatches.addElement(new Swatch(this,	1,	2,	0, 255, 0));
		allSwatches.addElement(new Swatch(this, 1, 	3,	0, 0, 255));
		allSwatches.addElement(new Swatch(this, 1, 4, 	255, 0, 255));
				
		allSwatches.addElement(new Swatch(this, 2, 1, 	0, 0, 0));
		allSwatches.addElement(new Swatch(this, 2, 2, 	125, 125, 125));		
		allSwatches.addElement(new Swatch(this, 2, 3, 	255, 255, 255));
		*/
		
		
		
		app.registerDraw(this);
		
		
	}
	
	int remap(int _colorValue) {
		
		int returnColor = (int)map(_colorValue, 0, 15, 0, 255);
		
		return returnColor;
	}
	
	
	void draw() {
		
		if(anySelected) {		
			fill(selectedColor);
			rect(int(x), int(y), 40, 20);			
		} else {
			drawUnselected();
		}
	}
	
	
	void drawUnselected () {
		fill(0);
		
		int posX = int(x);
		int posY = int(y);
		
		pushMatrix();
		translate(posX, posY);
		
		rect(0, 0, 40, 20);
		
		stroke(color(255, 0, 0));
		line(0, 0, 40, 20);
		line(0, 20, 40, 0);					
	
		popMatrix();
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
	int h = w;
	boolean isSelected;
	color sColor;
	
	ColorPalette parent;
			
	
	Swatch(ColorPalette _this, int _column, int _row, int _r, int _g, int _b) {
		r = _r;
		g = _g;
		b = _b;
		
		parent = _this;		
		x = parent.x+((_column-1)*w);
		y = parent.y+10+(_row*h);
		
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
					parent.anySelected = true;
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








