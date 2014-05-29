import controlP5.*;

Blob[] blobs;
int numBlobs = 200;
int blobSize = 10;

float degMin = 130;
float degMax = 250;

NoiseField nF;

void setup() {
  size(600, 600);
  smooth();
  noStroke();


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
  control.addSlider("noise_x", 0, 100).setLabel("noise x").setMin(-1.0).setMax(1).setValue(nF.direction.x).linebreak();
  control.addSlider("noise_y", 0, 100).setLabel("noise y").setMin(-1.0).setMax(1).setValue(nF.direction.y).linebreak();
  control.addSlider("noise_z", 0, 100).setLabel("noise z").setMin(-1.0).setMax(1).setValue(nF.direction.z).linebreak();
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
public void noise_x(float v){ nF.direction.x = v; }
public void noise_y(float v){ nF.direction.y = v; }
public void noise_z(float v){ nF.direction.z = v; }



void resetBlobs() {
  for (int i = 0; i < numBlobs; i ++) {
    blobs[i].reset();
  }
}

void draw() {
  background(255);

  nF.update();

  nF.draw();

  //stroke(0);
  fill(255);

  for (int i = 0; i < numBlobs; i ++) {
    float mag = nF.getValue(blobs[i].x, blobs[i].y);

    float speed = (1- blobs[i].size/blobSize) ;
    //mag *= mag;
    blobs[i].move(speed, mag);
    blobs[i].draw();
  }
}

