import gab.opencv.*;
import blobDetection.*;
import controlP5.*;
import processing.video.*;

PVector trackedPoint;

PFont font;

ControlP5 controls;
OpenCV opencv;

VideoCapture video;

Boolean isBlobs = false;
Boolean isTracking = false;
Boolean isBackgroundIgnored = false;
boolean isMouseDown;
boolean clicked = false;

PImage output;

int brightnessAmt = 122;
int thresholdAmt = 122;

private int videoWidth = 640;
private int videoHeight = 480;

int screenWidth = 853;
int screenHeight = 480;

float cv_scale = 1;

BlobCapture blobCapture;

void setup() {
  size(screenWidth + videoWidth, 480, P2D);

  trackedPoint = new PVector();

  font = createDefaultFont(10);


  opencv = new OpenCV(this, (int)(videoWidth*cv_scale), (int)(videoHeight*cv_scale));
  opencv.startBackgroundSubtraction(5, 3, 0.5);

  video = new VideoCapture(this, videoWidth, videoHeight);
  video.x = screenWidth + 10;
  video.y = 170;

  blobCapture = new BlobCapture(screenWidth, screenHeight, cv_scale);

  controls = new ControlP5(this);

  controls.setBroadcast(false);

  controls.addToggle("tracking").setCaptionLabel("Tracking").setPosition(screenWidth + 10, 50);  
  controls.addToggle("backgroundIgnored").setCaptionLabel("Background Sub").setPosition(screenWidth + 70, 50);

  //blobs
  controls.addToggle("blobs").setCaptionLabel("Show Blobs").setPosition(screenWidth + 200, 10);
  controls.addSlider("blobThreshold").setCaptionLabel("Blob Threshold").setPosition(screenWidth + 200, 50).setRange(0, 1).setValue(0.2);
  controls.addSlider("blobMin").setCaptionLabel("Blob Minimum").setPosition(screenWidth + 200, 75).setRange(0, videoWidth).setValue(40);
  controls.addSlider("blobMax").setCaptionLabel("Blob Maximum").setPosition(screenWidth + 200, 100).setRange(0, videoWidth).setValue(100);

  controls.setBroadcast(true);
  controls.addSlider("contrast").setPosition(screenWidth + 10, 10).setRange(0, 255).setValue(38);
  controls.addSlider("threshold").setPosition(screenWidth + 10, 25).setRange(0, 255).setValue(229);


  noStroke();
  smooth();
}


void draw() {

  if (video.available()) {
    background(50, 53, 52);

    video.draw();

    PImage cropped = video.croppedImage(new int[] {
      0, 0, 
      opencv.width, 0, 
      opencv.width, opencv.height, 
      0, opencv.height
    }
    );

    opencv.loadImage(cropped);
    if (isBackgroundIgnored)
      opencv.updateBackground();

    opencv.brightness(brightnessAmt);  
    opencv.threshold(thresholdAmt);

    output = opencv.getOutput();
    output.loadPixels();

    image(output, 0, 0, screenWidth, screenHeight);

    if (isBlobs) {
      blobCapture.read(output);
      blobCapture.draw();
    }

    if (isTracking) {
      PVector pos = getPoint(output);
      trackedPoint = PVector.lerp(trackedPoint, pos, 0.1);
      // Draw a large, yellow circle at the brightest pixel
      fill(255, 204, 0, 128);
      ellipse(trackedPoint.x, trackedPoint.y, 20, 20);
    }
  }

  fill(255);
  textFont(controls.getFont().getFont());
  text("FRAME RATE: " + frameRate, screenWidth + 10, 130);

  if (clicked) {
    clicked = false;
    saveFrame("screenGrab.png");
  }
}

PVector getPoint(PImage input) {
  int index = 0;
  int brightestX = 0; // X-coordinate of the brightest video pixel
  int brightestY = 0; // Y-coordinate of the brightest video pixel
  float brightestValue = 0; // Brightness of the brightest video pixel
  // Search for the brightest pixel: For each row of pixels in the video image and
  // for each pixel in the yth row, compute each pixel's index in the video

  for (int y = 0; y < input.height; y++) {
    for (int x = 0; x < input.width; x++) {
      // Get the color stored in the pixel
      int pixelValue = input.pixels[index];
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

  return new PVector(brightestX, brightestY);
}

void mouseDragged() {
  if (mouseX > video.x)
    video.dragged(mouseX - video.x, mouseY - video.y);
}

void mousePressed( ) {
  if (mouseX > video.x) {
    isMouseDown = true;
    video.down(mouseX - video.x, mouseY - video.y);
  } else {
    //save image
    clicked = true;
  }
}

void mouseReleased() {
  isMouseDown = false;
  video.up(mouseX - video.x, mouseY - video.y);
}


//-------------controlP5------------------
void contrast(float value) {
  brightnessAmt = (int)value;
}

void backgroundIgnored(boolean value) {
  isBackgroundIgnored = value;
}

void threshold(float value) {
  thresholdAmt = (int)value;
}

void blobThreshold(float value) {
  blobCapture.setThreshold(value);
}

void blobMin(float value) { 
  blobCapture.setMinSize((int)value );
}


void blobMax(float value) {
  blobCapture.setMaxSize((int)value );
}

void tracking(boolean value) {
  isTracking = value;
}

void blobs(boolean value) {
  isBlobs = value;
}
