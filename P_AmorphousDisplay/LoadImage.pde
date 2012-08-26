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
void loadImg() {
	
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
void loadAlpha(){
	
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
void loadPeriod(){
	
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
void loadMovie() {
	
	
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
void saveSingleFrame() {
	
	displayManager.canvas.saveCurrentFrame(textfieldFrameName.getText());
	textfieldFrameName.clear();
}




// SAVE MOVIE
// -------------------------------------------------------------------------------------------
void saveMovie() {
	
	displayManager.canvas.saveAllFrames(textfieldMovieName.getText());
	//saveMovieGrabFrames(textfieldMovieName.getText());
	textfieldMovieName.clear();
	
}











