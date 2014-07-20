import penner.easing.*;



PImage[] frames;

PFont font;

PVector eyePos;

Eye[] eyes;
Eye eye;

void setup() {
  size(1000, 1000, P2D);

  font = createDefaultFont(10);
/*
  eyes = new Eye[1];

  for (int x = 0; x < 1; x ++) {
    for (int y = 0; y < 1; y ++) {
      Eye eye = new Eye();
      eye.pos = new PVector(x * width / 10, y * height/10);

      eyes[x + y * 1] = eye;
    }
  }
  */
  eye = new Eye(new PVector(100, 100));
}

void draw() {

  background(0);

  int elapsed = millis();
  eye.draw(elapsed);
 /* 
  for (int i = 0; i < eyes.length; i ++) {
    eyes[i].draw(elapsed);
  }
  */

  textFont(font);
  text(frameRate, 10, 10);
}
