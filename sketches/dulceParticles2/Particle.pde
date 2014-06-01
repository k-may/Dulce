class Particle {
  //float x, y;
  int size = 2;
  PVector position;

  Particle() {
    position = new PVector(random(width), random(height));
  }

  void reset() {
    position = new PVector(random(width), random(height));
    size = 2;
  }
  void draw() {

    ellipse(position.x, position.y, size, size);
  } 

  void move(PVector pos) {
    position.add(pos);
    while (position.x < 0) {
      position.x+=width;
    }
    while (position.x > width - 1) {
      position.x-=width;
    }
    while (position.y < 0) {
      position.y+=height;
    }
    while (position.y > height - 1) {
      position.y-=height;
    }
  }
}

