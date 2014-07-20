import controlP5.*;

/**
 * Brightness Tracking 
 * by Golan Levin. 
 *
 * Tracks the brightest pixel in a live video signal. 
 */


import processing.video.*;

Capture video;
ControlP5 controls;

PGraphics graphics;
float thresholdAmt = 0.5;

void setup() {
  size(640, 480);

  controls = new ControlP5(this);
  controls.addSlider("threshold").setPosition(10,10).setRange(0, 1).setValue(0.5);
  graphics = createGraphics(width, height);

  // Uses the default video input, see the reference if this causes an error
  String[] cameras = Capture.list();

  int i = 0;
  for (; i < cameras.length; i ++) {
    println(cameras[i]); 
    if (cameras[i].indexOf("Dazzle") != -1)
      break;
  }

  video = new Capture(this, cameras[i]);
  video.start();  
  noStroke();
  smooth();
}

void threshold(float value){
  thresholdAmt = value;
}
void draw() {
  if (video.available()) {
    video.read();
    graphics.beginDraw();
    graphics.image(video, 0, 0, width, height); // Draw the webcam video onto the screen
   // graphics.filter(THRESHOLD, thresholdAmt);
    int brightestX = 0; // X-coordinate of the brightest video pixel
    int brightestY = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel
    // Search for the brightest pixel: For each row of pixels in the video image and
    // for each pixel in the yth row, compute each pixel's index in the video

    graphics.endDraw();

    graphics.loadPixels();
    int index = 0;
    for (int y = 0; y < graphics.height; y++) {
      for (int x = 0; x < graphics.width; x++) {
        // Get the color stored in the pixel
        int pixelValue = graphics.pixels[index];
        // Determine the brightness of the pixel
        float pixelBrightness = brightness(pixelValue);
        // If that value is brighter than any previous, then store the
        // brightness of that pixel, as well as its (x,y) location
        if (pixelBrightness > brightestValue) {
          brightestValue = pixelBrightness;
          brightestY = y;
          brightestX = x;
        }
        index++;
      }
    }
    image(graphics, 0, 0);
    // Draw a large, yellow circle at the brightest pixel
    fill(255, 204, 0, 128);
    ellipse(brightestX, brightestY, 200, 200);
  }
}
