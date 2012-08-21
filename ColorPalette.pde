




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
		allSwatches.addElement(new Swatch(this, 1, 1, 255, 0, 0));
		allSwatches.addElement(new Swatch(this, 1, 2, 0, 255, 0));
		allSwatches.addElement(new Swatch(this, 1, 3, 0, 0, 255));
		allSwatches.addElement(new Swatch(this, 1, 4, 255, 0, 255));
				
		allSwatches.addElement(new Swatch(this, 2, 1, 0, 0, 0));
		allSwatches.addElement(new Swatch(this, 2, 2, 125, 125, 125));		
		allSwatches.addElement(new Swatch(this, 2, 3, 255, 255, 255));
		
		app.registerDraw(this);
		
		
	}
	
	
	void draw() {
		
		if(anySelected) {		
			fill(selectedColor);
			rect(int(x)+20, int(y), 40, 20);			
		} else {
			drawUnselected();
		}
	}
	
	
	void drawUnselected () {
		fill(0);
		rect(int(x)+20, int(y), 40, 20);
		stroke(color(255, 0, 0));
		line(int(x)+20, int(y), int(x)+60, int(y)+20);
		line(int(x)+60, int(y), int(x)+20, int(y)+20);					
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
		x = parent.x+(_column*w);
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








