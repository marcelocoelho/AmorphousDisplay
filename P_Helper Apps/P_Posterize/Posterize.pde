PGraphics bam;
PImage b;
float range;
int currentFrame;

currentFrame = 3;

bam = createGraphics(320, 240, P2D);

range = (255/10) * currentFrame;

b = loadImage("ripple.png");


size(320,240);

bam.beginDraw();
bam.image(b, 0, 0);
bam.filter(GRAY);
bam.filter(POSTERIZE, 10);

/*
bam.loadPixels();

for (int i = 0; i < bam.pixels.length; i++) {
   if (red(bam.pixels[i]) > range+10 || red(bam.pixels[i]) < range-10) {
     bam.pixels[i] = color(255,255,255,255);
   } else {
     bam.pixels[i] = color(0,0,0, 255);     
   }
}
*/

bam.updatePixels();


bam.endDraw();

image(bam,0,0);




