class Eye {

  int currentMillis;

  PVector _bC1 = new PVector(12, 60);
  PVector _bC2 = new PVector(43, 103);

  PVector _tC1 = new PVector(25, 5);
  PVector _tC2 = new PVector(83, -34);

  PVector right = new PVector(115, 60);
  PVector left = new PVector(0, 50);
  PVector center = new PVector(61, 37);
  PVector pos;

  float openVal = 1.0f;

  PImage eyeImage;
  PGraphics m;
  PGraphics g;

  int iris = 67;
  int cornea = 42;
  int pupil = 16;

  int w = 116;
  int h = 80;

  int startTime;
  int closeTime = 200;
  int openTime = 300;
  int nextTime = 0;

  boolean closing = false;
  boolean opening = false;

  PShape eyeLid;
  Boolean invalidated;

  public Eye() {
    this(new PVector());
  }

  public Eye(PVector pos) {
    this.pos = pos;

    g = createGraphics(w, h, P2D);
    m = createGraphics(w, h, P2D);
    eyeImage = createEye();

    eyePos = new PVector();
    invalidated = true;
    drawMask();

    closing = true;
    //nextTime = (int)random(millis(), 2000);
    startTime = millis();
  }

  void draw(int millis) {
    currentMillis = millis;

    if (!closing && currentMillis >= nextTime) {
      closing = true;
      startTime = currentMillis - 1;
    }

    updateEyePos();
    drawMask();

    g.beginDraw();
    g.image(eyeImage, eyePos.x, eyePos.y);
    g.endDraw();
    g.mask(m);

    image(g, pos.x, pos.y);
  }


  void updateEyePos() {
    PVector dir = PVector.sub(new PVector(mouseX, mouseY), pos);
    dir.normalize();
    dir.mult(7);
    eyePos =  PVector.lerp(eyePos, dir, 0.05f);
  }

  void drawMask() {

    if (closing) {
      openVal = getRatio();
      if (openVal >= 1.0f) {
        closing = false;
        openVal = 1;
        nextTime = (int)random(currentMillis + 1000, currentMillis + 5000);
      }
      invalidated = true;
    }

    if (invalidated) {
      invalidated = false;
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
    }
  }

  float getRatio() {
    int elapsed = currentMillis - startTime;
    float r;
    if (elapsed < closeTime) {
      r = penner.easing.Quad.easeIn(elapsed, 1, -1, closeTime);
    } else {
      elapsed -= closeTime;
      r = penner.easing.Quad.easeIn(elapsed, 0, 1, openTime);
    }
    return r;
  }


  PImage createEye() {
    PGraphics eyeBall = createGraphics(w, h, P2D);
    eyeBall.beginDraw();
    eyeBall.background(255, 255, 255, 255);
    eyeBall.smooth();
    eyeBall.noFill();

    eyeBall.fill(0);
    eyeBall.ellipse(center.x, center.y, iris, iris);

    eyeBall.fill(255, 0, 0);
    eyeBall.ellipse(center.x, center.y, cornea, cornea);

    eyeBall.fill(0);
    eyeBall.ellipse(center.x, center.y, pupil, pupil);

    eyeBall.endDraw(); 
    return eyeBall.get();
  }
}
