// ------------------------------------------------------------------------
//
//  LOAD IMAGES AND ANIMATIONS
//
// ------------------------------------------------------------------------


PImage loadedImage;					// stores loaded image
FileDialog fdImg;					// opens file chooser for uploading images

ControlP5 loadCP5;

boolean isImageLoaded = false;

int loadImgX = 0;
int loadImgY = 0;


// INTERFACE FOR IMAGE LOADING
// -------------------------------------------------------------------------------------------
void initLoadImg() {
	
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
	
	
	loadCP5 = new ControlP5(this);
	
	// Create button
	loadCP5.addButton("loadImg",
						0,
						340, 290,
						80, 20
						).setCaptionLabel("Load Image");
	
}


// LOAD IMAGE
// -------------------------------------------------------------------------------------------
void loadImg() {
	
	fdImg.setVisible(true);
	
	if (fdImg.getFile() != null) {
		loadedImage = loadImage(fdImg.getFile());
		loadedImage.resize(320, 240);
		
		isImageLoaded = true;
		
		
		//displayManager.canvas.displayLoadedImage(loadedImage);

		// show the image and update pixel colors
		//overlayUpload = true;
		//pngAssigned = false;	// need to reassign pixel sequences
		//println("uploading png sequence...");
	}
	
	
	
}