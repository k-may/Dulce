float angleMin, angleMax;//
float x, y;
float count;
float inc = 0.1;

void setup() {
  size(300, 300);
  smooth();

  x = random(width);
  y = random(height);
  angleMin = 160 * PI/180;//random(360) * PI/180;
  angleMax = 200 * PI/180;//random(360) * PI/180;
}

void draw() {

  //background(255);

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

  count += inc;
  float value = (sin(count) + 1)/2;
  
  noStroke();
  fill(255, 0, 0);
  rect(width*value, 0, 2, 6);
  
  float angleNew = angleMin + (angleMax - angleMin)*value;

  fill(255);
  stroke(0);
  x += sin(angleNew);
  y += cos(angleNew);

  ellipse(x, y, 10, 10);
}

