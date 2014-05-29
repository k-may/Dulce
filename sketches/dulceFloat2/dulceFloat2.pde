float[] radsMin;
float[] radsMax;
float degMin = 160;
float degMax = 200;

PVector[] pos;
int numPos = 10;


float count;
float inc = 0.1;

void setup() {
  size(300, 300);
  smooth();
  pos = new PVector[numPos];
  radsMin = new float[numPos];
  radsMax = new float[numPos];
  for (int i = 0; i < numPos; i ++) {
    pos[i] = new PVector(random(width), random(height));
    radsMin[i] = radians(random(degMin - 10, degMin + 10)); 
    radsMax[i] = radians(random(degMax - 10, degMax + 10));
  }
}

void draw() {

  background(255);


  count += inc;
  float value = (sin(count) + 1)/2;

  noStroke();
  fill(255, 0, 0);
  rect(width*value, 0, 2, 6);

  fill(255);
  stroke(0);

  for (int i = 0; i < numPos; i ++) {
    while (pos[i].x < 0) {
      pos[i].x+=width;
    }
    while (pos[i].x > width - 1) {
      pos[i].x-=width;
    }
    while (pos[i].y < 0) {
      pos[i].y+=height;
    }
    while (pos[i].y > height - 1) {
      pos[i].y-=height;
    }


    float angleNew = radsMin[i] + (radsMax[i] - radsMin[i])*value;

    pos[i].x += sin(angleNew);
    pos[i].y += cos(angleNew);

    ellipse( pos[i].x, pos[i].y, 10, 10);
  }
}

