class Particles {

  Blob[] blobs;
  int numBlobs = 200;
  int blobSize = 10;

  float degMin = 130;
  float degMax = 250;

  NoiseField nF;

  boolean nFVisible = false;

  Particles(PApplet parent) {
    nF = new NoiseField();
    blobs = new Blob[numBlobs];

    for (int i = 0; i < numBlobs; i ++) {
      blobs[i] = new Blob(random(3, blobSize));
    }
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
   // background(100);

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
}

