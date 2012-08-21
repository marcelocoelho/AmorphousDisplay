

import hypermedia.video.*;
import processing.video.*;

import java.awt.*;


//ControlP5 vCP5;

OpenCV opencv;
//Capture myCapture;
//String[] captureDevices;


int vBrightness = 0;
int vContrast = 0;
int vThreshold = 190;
int minBlobArea = 50;
int maxBlobArea = 3000;

int displayWidth = 320;
int displayHeight = 240;

int visionX = 900;
int visionY = 20;

int menuX = visionX;
int menuY = 380+visionY;

boolean displayId = false;



// Load up all camera related stuff
// -------------------------------------------------------------------------------------------
void initVision() {
	
	opencv = new OpenCV(this);
	
	opencv.capture(displayWidth, displayHeight);
	
	opencv.allocate(displayWidth, displayHeight);

	
	initVizControls();
	
}




// Display camera views
// -------------------------------------------------------------------------------------------
void loadCameraViews() {

	opencv.read();

	opencv.brightness(vBrightness);
	opencv.contrast(vContrast);


	
	image( opencv.image(), visionX, visionY );								// top SOURCE IMAGE
	image( opencv.image(OpenCV.MEMORY), visionX, visionY+254, 160, 120 );			// left IMAGE STORED IN MEMORY
	
	
	opencv.absDiff();
	opencv.threshold(vThreshold);
	
	image( opencv.image(), visionX+165, visionY+254, 160, 120 );						// right BUFFERED OPENCV.IMAGE()
	PImage buffered = opencv.image();
	

	Blob[] blobs = opencv.blobs( minBlobArea, maxBlobArea, numPixels, false );
			
			
	noFill();

	
	// DRAW BLOBS
    for( int i=0; i < blobs.length; i++ ) {
		
		
		// Draw Blobs (RED)
		stroke(255, 0, 153);
		beginShape();
		for( int j=0; j < blobs[i].points.length; j++ ) {
            vertex( blobs[i].points[j].x+visionX, blobs[i].points[j].y+visionY );
		}
		endShape(CLOSE);


		// draw bounding rectangles (GREEN)
		stroke(0, 220, 50);
		Rectangle bounding_rect = blobs[i].rectangle;
		rect( bounding_rect.x+visionX, bounding_rect.y+visionY, bounding_rect.width, bounding_rect.height );


		// draw centroids (BLUE)
		stroke(0, 255, 255);
		Point centroid = blobs[i].centroid;
		line(centroid.x-2+visionX, centroid.y-2+visionY, centroid.x+2+visionX, centroid.y+2+visionY);
		line(centroid.x-2+visionX, centroid.y+2+visionY, centroid.x+2+visionX, centroid.y-2+visionY);

    }

}



// LOCATE PIXELS
// -------------------------------------------------------------------------------------------
void matchPix() {
	
	// show IR in quick succession
	for (int i = 0; i < numPixels; i++) {
						
			allPixels.get(i).scanned = true;
			
			// send IR			
			packet.send( i+1, IR, 119, 0, 0 );			// ir=63; delay=240;

			// wait for pixels to display IR
			delay(220);
			
			// read and remember image with IR
			//myCapture.read();
			//opencv.copy(myCapture);
			opencv.read();

			opencv.remember(1);
			
			// wait for pixels to finish IR
			delay(210);
			
			// read image without IR
			//myCapture.read();
			//opencv.copy(myCapture);
			opencv.read();

			
			// compare images with and without IR
			opencv.absDiff();
			opencv.threshold(vThreshold);

			// assign pixel irImage
			//allPixels.get(i).irImage = opencv.image();
			//allPixels.get(i).irDefault = new LabeledVer(opencv.image(), "Pixel "+(i+1)).image();
			//imageCollection.add(opencv.image());
			//imageCollection.add(allPixels.get(i).irDefault);

			// find blobs in thresholded image
			Blob[] oneBlob = opencv.blobs( minBlobArea, maxBlobArea, 1, false );

			
			if (oneBlob.length != 0) {
				// assign pixel rectangle
				allPixels.get(i).x = oneBlob[0].rectangle.x;
				allPixels.get(i).y = oneBlob[0].rectangle.y;
				allPixels.get(i).w = oneBlob[0].rectangle.width;
				allPixels.get(i).h = oneBlob[0].rectangle.height;
				
				// assign pixel centroid
				allPixels.get(i).centroid = oneBlob[0].centroid;

				//long mp2 = System.currentTimeMillis()-mp1;
				//println("[MATCHPIX] elapsed time: "+mp2);
				
			} else {
				allPixels.get(i).scanned = false;	// pixels unsuccessfully matched will not be labeled
			}

	
			// update pixel assignments (according to uploaded image)
			//if (overlayUpload) pngAssigned = false;
	
	}

}






// Interface Loading 
// -------------------------------------------------------------------------------------------
void initVizControls() {
	
	//vCP5 = new ControlP5(this);
	
	
	controlP5.addSlider("contrast",
						-128, 128,
						vContrast,
						menuX, menuY+10,
						200, 15
						);
						
	controlP5.addSlider("brightnessLevel",
						-128, 128,
						vBrightness,
						menuX, menuY+30,
						200, 15
						);
						
	controlP5.addSlider("threshold",
						0, 255,
						vThreshold,
						menuX, menuY+50,
						200, 15
						);
						
	controlP5.addRange("blobArea",
						10,			// theMin
						4000, 			// theMax
						minBlobArea,	// theDefaultMinValue
						maxBlobArea, 	// theDefaultMaxValue
						menuX, menuY+70,	// theX, theY
						200,15			// theWidth, theHeight
						);
						
	controlP5.addButton("labelPix",
						0,
						menuX, menuY+90,
						60, 15
						);
						
						
	
						
	controlP5.addButton("matchPix",
						0,
						menuX+70, menuY+90,
						60, 15
						);

						
}



// Interface Assignments 
// -------------------------------------------------------------------------------------------
void contrast() {
	vContrast = (int)(controlP5.controller("contrast").value());
}

void brightnessLevel() {
	vBrightness = (int)(controlP5.controller("brightnessLevel").value());
} 

void threshold() {
	vThreshold = (int)(controlP5.controller("threshold").value());
}

void blobArea() {
	minBlobArea = (int)(controlP5.controller("blobArea").arrayValue()[0]);
	maxBlobArea = (int)(controlP5.controller("blobArea").arrayValue()[1]);
}

void labelPix() {
	for (int i = 1; i <= numPixels; i++) {
		allPixels.get(i).labelWithId = !allPixels.get(i).labelWithId;
	}
}














