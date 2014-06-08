import penner.easing.*;


PVector _bC1 = new PVector(12, 60);
PVector _bC2 = new PVector(43, 103);

PVector _tC1 = new PVector(25, 5);
PVector _tC2 = new PVector(83, -34);

PVector right = new PVector(115, 60);
PVector left = new PVector(0, 50);
PVector center = new PVector(61, 37);

float openVal = 1.0f;

int iris = 67;
int cornea = 42;
int pupil = 16;
int w = 116;
int h = 80;
int pressTime;
int closeTime = 200;
int openTime = 300;

boolean closing = false;
boolean opening = false;

PImage[] frames;
PGraphics orig;
PGraphics m;
PFont font;

PVector eyePos;

void setup() {
  size(300, 300, P2D);

  frames = new PImage[100];

  orig = createGraphics(w, h, P2D);//getEye();
  m = createGraphics(w, h, P2D);
  font = createDefaultFont(10);

  eyePos = center.get();
}

void draw() {

  background(0);

  PImage e = getEye().get();
  e.mask(getMask());
  image(e, (width - w)/2, (height - h)/2);

  textFont(font);
  text(frameRate, 10, 10);
}

PGraphics getEye() {
  //PGraphics e = createGraphics(w, h, P2D);

  PVector dir = PVector.sub(new PVector(mouseX, mouseY), new PVector(width/2, height/2));
  dir.normalize();
  dir.mult(7);
  dir.add(center);

  eyePos = PVector.lerp(eyePos, dir, 0.05f);

  orig.beginDraw();
  orig.background(255, 255, 255, 255);
  orig.smooth();
  orig.noFill();

  orig.fill(0);
  orig.ellipse(eyePos.x, eyePos.y, iris, iris);

  orig.fill(255, 0, 0);
  orig.ellipse(eyePos.x, eyePos.y, cornea, cornea);

  orig.fill(0);
  orig.ellipse(eyePos.x, eyePos.y, pupil, pupil);

  orig.endDraw();

  // e.mask(getMask());
  return orig;
}

PGraphics getMask() {

  if (closing) {
    openVal = getRatio();
    if (openVal >= 1.0f) {
      closing = false;
      openVal = 1;
    }

  }

  PVector tC1 = PVector.lerp(_tC1, _bC1, 1 - openVal);
  PVector tC2 = PVector.lerp(_tC2, _bC2, 1 - openVal);

  PShape eye = createShape();
  eye.beginShape();
  eye.fill(0);
  eye.vertex(0, 0);
  eye.vertex(w, 0);
  eye.vertex(w, h);
  eye.vertex(0, h);
  eye.vertex(0, 0);
  eye.beginContour();
  eye.vertex(left.x, left.y);
  eye.bezierVertex(_bC1.x, _bC1.y, _bC2.x, _bC2.y, right.x, right.y);
  eye.vertex(right.x, right.y);
  eye.bezierVertex(tC2.x, tC2.y, tC1.x, tC1.y, left.x, left.y);
  eye.endContour();
  eye.endShape();

  m.beginDraw();
  m.background(255);
  m.shape(eye);
  m.endDraw();

  return m;
}

float getRatio() {
  int time = millis();
  int elapsed = time - pressTime;

  float r;
  println(openVal, elapsed, closeTime);
  if (elapsed < closeTime) {
    r = penner.easing.Quad.easeIn(elapsed, 1, -1, closeTime);
  } else {
    elapsed -= closeTime;
    r = penner.easing.Quad.easeIn(elapsed, 0, 1, openTime);  
  }
  
  return r;
}

void mousePressed() {
  closing = true;
  pressTime = millis();
}

