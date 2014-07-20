class BlobCapture { //<>//

  BlobDetection bD;
  PImage img;
  Boolean invalidated;
  int width, height;
  int x, y;
  float scale = 0.2;
  int imgWidth;
  int imgHeight;
  int minSize = 40;
  int maxSize = 100;

  BlobCapture(int w, int h, float scale) {
    this.width = w;
    this.height = h;
    this.scale = scale;
    x = 0;
    y = 0;
    imgWidth = (int)(w*scale);
    imgHeight = (int)(h*scale);
    img = new PImage(imgWidth, imgHeight);
    bD = new BlobDetection(imgWidth, imgHeight);
    bD.setPosDiscrimination(true);
    bD.setThreshold(0.2f);
    bD.setBlobMaxNumber(6);
  } 

  void draw() {
    if (invalidated) {
      invalidated = false; 

      bD.computeBlobs(img.pixels);
    }

    //draw input
    //image(img, 10, 10);


    drawBlobs();
  }

  void drawBlobs() {
    Blob b;
    EdgeVertex eA, eB;
    //  println("num blobs : " + bD.getBlobNb());

    for (int n=0; n<bD.getBlobNb (); n++)
    {
      b=bD.getBlob(n);
      if (b!=null)
      {
        strokeWeight(3);
        stroke(0, 255, 0);

        // println(b.getEdgeNb ());
       // println(b.w, b.h);
        if (b.w > minSize && b.h > minSize && b.w < maxSize && b.h < maxSize) {
          //create blob
          for (int m=0; m<b.getEdgeNb (); m++)
          {
            eA = b.getEdgeVertexA(m);
            eB = b.getEdgeVertexB(m);
            if (eA !=null && eB !=null)
              line(
              eA.x*this.width, eA.y*this.height, 
              eB.x*this.width, eB.y*this.height
                );
          }
        }
      }
    }
  }

  void read(PImage src) {
    img.copy(src, 0, 0, src.width, src.height, 0, 0, imgWidth, imgHeight);
    invalidated = true;
  }

  void setThreshold(float value) {
    bD.setThreshold(value);
  }

  void setMinSize(int size) {
    minSize = size;
  }

  void setMaxSize(int size) {
    maxSize = size;
  }
}
