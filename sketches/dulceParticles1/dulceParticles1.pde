import controlP5.*;

Blob[] blobs;
int numBlobs = 200;
int blobSize = 10;

float degMin = 130;
float degMax = 250;

NoiseField nF;

boolean nFVisible = false;

void setup() {
  size(1000, 1000);
  smooth();
  noStroke();

  println(nFVisible);


  nF = new NoiseField();
  blobs = new Blob[numBlobs];

  for (int i = 0; i < numBlobs; i ++) {
    blobs[i] = new Blob(random(3, blobSize));
  }


  ControlP5 control = new ControlP5(this);
  control.setBroadcast(false);

  control.begin(10, 10);
  control.addSlider("degrees_min", 0, 100).setLabel("degrees min").setMin(0).setMax(360).setValue(degMin).linebreak();
  control.addSlider("degrees_max", 0, 100).setLabel("degrees max").setMin(0).setMax(360).setValue(degMax).linebreak();
  control.addSlider("noise_x", 0, 100).setLabel("noise x").setMin(-0.1).setMax(0.1).setValue(nF.direction.x).linebreak();
  control.addSlider("noise_y", 0, 100).setLabel("noise y").setMin(-0.1).setMax(0.1).setValue(nF.direction.y).linebreak();
  control.addSlider("noise_z", 0, 100).setLabel("noise z").setMin(-0.1).setMax(0.1).setValue(nF.direction.z).linebreak();
  control.addToggle("show_noise").setWidth(20).setValue(nFVisible);
  control.end();
  control.setBroadcast(true);
}

public void degrees_min(int v) { 
  println("broadcast");
  if (v != 0) degMin = v; 
  resetBlobs();
}
public void degrees_max(int v) { 
  if (v != 0) degMax = v; 
  resetBlobs();
}
public void noise_x(float v) { 
  nF.direction.x = v;
}
public void noise_y(float v) { 
  nF.direction.y = v;
}
public void noise_z(float v) { 
  nF.direction.z = v;
}

public void show_noise(boolean b) {
  nFVisible = b;
}

void resetBlobs() {
  for (int i = 0; i < numBlobs; i ++) {
    blobs[i].reset();
  }
}

void draw() {
  background(100);

  nF.update();

  if (nFVisible)
    nF.drawField();

  //stroke(0);
  fill(255);

  for (int i = 0; i < numBlobs; i ++) {
    float mag = nF.getValue(blobs[i].x, blobs[i].y);

    float speed = (1- blobs[i].size/blobSize) ;
    //println(speed);
    //mag *= mag;
    blobs[i].move(speed, mag);
    blobs[i].draw();
  }
}
