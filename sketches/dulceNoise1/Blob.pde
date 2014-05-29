class Blob {
  float x;
  float y;
  PVector intension;
  int size;

  Blob(int size) {
    this.size = size;
    
    x = random(width);
    y = random(height);
    
    intension = new PVector(random(10), random(10));
    intension.normalize();
  }

  void move(float mag) {
    
    //intension.mult(mag);
    
    x += intension.x*mag;
    y += intension.y*mag;
    
    while (x < 0) {
      x+=width;
    }
    while (x > width - 1) {
      x-=width;
    }
    while (y < 0) {
      y+=height;
    }
    while (y > height - 1) {
      y-=height;
    }
  }
  void draw() {
    ellipse(x, y, size, size);
  }
}

