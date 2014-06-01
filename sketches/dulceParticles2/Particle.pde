class Particle {
  //float x, y;
  PVector position;

  Particle() {
    position = new PVector(random(width), random(height));
  }

  void draw() {
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
    ellipse(position.x, position.y, 10, 10);
  } 

  void move(PVector pos) {
    position.add(pos);
  }
}

