class Blob {
  float x;
  float y;
  PVector intension;
  float size;
  float radMin, radMax;

  Blob(float size) {
    this.size = size;

    x = random(width);
    y = random(height);
reset();
   // println(degrees(radMin), degrees(radMax));

    intension = new PVector(0, -1);
    intension.normalize();
  }

void reset(){
  
    radMin = radians(random(degMin - 10, degMin + 10)); 
    radMax = radians(random(degMax - 10, degMax + 10));

}
  void move(float speed, float mag) {

    float angleNew = radMin + (radMax - radMin)*mag;
   // speed *= abs(0.5 - mag)/0.5;
    //speed *= 2;
  
    x += sin(angleNew);// * mag;//intension.x*mag;
    y += cos(angleNew) * 0.1;// + speed;//intension.y*mag;

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

