import toxi.geom.*;
import toxi.processing.*;
import java.util.*;

boolean mouseDown;
int res = 100;

BezierShape shape;

void setup() {
  size(640, 440);
  mouseDown = false;

  shape = new BezierShape();
}


void draw() {
  background(255);
  noFill();

  Vec2D m = mouseDown ? new Vec2D(mouseX, mouseY) : null;
  shape.update(m);
  
  shape.display();
}

void mousePressed() {
  mouseDown = true;
}

void mouseReleased() {
  mouseDown = false;
}

void mouseExited() {
  mouseDown = false;
}

