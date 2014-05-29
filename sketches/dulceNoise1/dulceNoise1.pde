Blob[] blobs;
int numBlobs = 10;
int blobSize = 10;

NoiseField nF;

void setup() {
  size(300, 300);
  smooth();
  
  nF = new NoiseField();
  blobs = new Blob[numBlobs];

  for (int i = 0; i < numBlobs; i ++) {
    blobs[i] = new Blob(blobSize);
  }
}

void draw() {
  nF.update();
  
  background(255);

  stroke(0);

  for (int i = 0; i < numBlobs; i ++) {
    float mag = nF.getValue(blobs[i].x, blobs[i].y)*2;
    blobs[i].move(mag);
    blobs[i].draw();
  }
  
  
}

