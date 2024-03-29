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
						leftColumnX+60, leftColumnY+frameHeight+50,
						60, 20
						).setCaptionLabel("Image")
						.setImages(loadImage("UI/image-idle.png"), loadImage("UI/image-over.png"), loadImage("UI/image-active.png"));																								
						
	
	
	
	// Create Alpha
	controlP5.addButton("loadAlpha",
						0,
						leftColumnX+120, leftColumnY+frameHeight+50,
						60, 20
						).setCaptionLabel("Phase")
						.setImages(loadImage("UI/alpha-idle.png"), loadImage("UI/alpha-over.png"), loadImage("UI/alpha-active.png"));	

	// Create Period
	controlP5.addButton("loadPeriod",
						0,
						leftColumnX+180, leftColumnY+frameHeight+50,
						60, 20
						).setCaptionLabel("Period")
						.setImages(loadImage("UI/period-idle.png"), loadImage("UI/period-over.png"), loadImage("UI/period-active.png"));
	
	// Load Video
	controlP5.addButton("loadMovie",
						0,
						leftColumnX+240, leftColumnY+frameHeight+50,
						60, 20
						).setCaptionLabel("Movie")
						.setImages(loadImage("UI/movie-idle.png"), loadImage("UI/movie-over.png"), loadImage("UI/movie-active.png"));

	
	// Save Current Frame
	textfieldFrameName = controlP5.addTextfield("frameName")
							.setPosition(leftColumnX,leftColumnY+frameHeight+100)
							.setSize(100,25)
							//.setAutoClear(true)
							.setCaptionLabel("")
							;
	
	
	controlP5.addButton("saveSingleFrame",
						0,
						leftColumnX+110, leftColumnY+frameHeight+100,
						60, 20
						).setCaptionLabel("Save Frame")
						.setImages(loadImage("UI/saveframe-idle.png"), loadImage("UI/saveframe-over.png"), loadImage("UI/saveframe-active.png"));	
	
	
	// Save Movie
	textfieldMovieName = controlP5.addTextfield("movieName")
							.setPosition(leftColumnX, leftColumnY+frameHeight+135)
							.setSize(100,25)
							//.setAutoClear(true)
							.setCaptionLabel("")
							;	

	controlP5.addButton("saveMovie",
						0,
						leftColumnX+110, leftColumnY+frameHeight+135,
						60, 20
						).setCaptionLabel("Save Movie")
						.setImages(loadImage("UI/savemovie-idle.png"), loadImage("UI/savemovie-over.png"), loadImage("UI/savemovie-active.png"));
		
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











