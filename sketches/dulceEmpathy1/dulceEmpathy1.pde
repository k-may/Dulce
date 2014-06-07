PVector left = new PVector(0, 50);
PVector bC1 = new PVector(12, 60);
PVector bC2 = new PVector(43, 103);

PVector tC1 = new PVector(25, 5);
PVector tC2 = new PVector(83, -34);

PVector right = new PVector(115, 60);

PVector center = new PVector(61,37);

int iris = 67;
int cornea = 42;
int pupil = 16;

void setup(){
  size(116, 80);
  smooth();
}


void draw(){
  background(255);
  
  //outline
  stroke(0);
  noFill();
  bezier(left.x, left.y, bC1.x, bC1.y, bC2.x, bC2.y, right.x, right.y);
  bezier(left.x, left.y, tC1.x, tC1.y, tC2.x, tC2.y, right.x, right.y);
  
  //draw center
  noStroke();
  
  fill(0);
  ellipse(center.x, center.y, iris, iris);
  
  fill(213, 53, 38);
  ellipse(center.x, center.y, cornea, cornea);
  
  fill(0);
  ellipse(center.x, center.y, pupil, pupil);
  
}
