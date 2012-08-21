




// COLORS THAT CAN BE USED TO DRAW ON CANVAS
// -------------------------------------------------------------------------------------------
public class ColorPalette {

	Vector<Swatch> allSwatches = new Vector<Swatch>();	
	
	color selectedColor;
	
	int x, y;
	
	ColorPalette(float _x,  float _y) {
	
		x = int(_x);
		y = int(_y);
	
	
		selectedColor = color(255,255,255,255);
		
		allSwatches.addElement(new Swatch(int(x)+5, int(y)+25, 255, 0, 0));
		allSwatches.addElement(new Swatch(int(x)+5, int(y)+50, 0, 255, 0));
		allSwatches.addElement(new Swatch(int(x)+5, int(y)+75, 0, 0, 0));
		allSwatches.addElement(new Swatch(int(x)+5, int(y)+100, 255, 255, 255));
		
		app.registerDraw(this);
		
		
	}
	
	void draw() {
		
		fill(selectedColor);
		rect(int(x)+5,int(y),45,20);
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








