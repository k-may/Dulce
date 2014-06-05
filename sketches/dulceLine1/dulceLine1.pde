import controlP5.*;

import toxi.geom.*;
import java.util.*;

boolean mouseDown = false;
int res = 100;

ControlP5 control;

ArrayList<Vec2D> points;

void setup() {
  size(640, 420);
  smooth();
  
  control = new ControlP5(this);
  control.setColorCaptionLabel(0);
  control.setBroadcast(false);
  control.setAutoSpacing();
  control.addSlider("resolution").setPosition(10, 10).setMax(200).setMin(10).setValue(res);
  control.setBroadcast(true);
}

public void resolution(int value){
  res = value;
}


void draw() {
  background(255);
  if (mouseDown)
    updateLine();
  else if (points != null)
    points = null;

  if (points != null)
    drawLine();
}

void drawLine() {
  stroke(100);
  beginShape();
  for (Vec2D p : points) {
    vertex(p.x, p.y);
  } 
  endShape();

  stroke(0, 255, 0);
  beginShape();
  vertex(points.get(0).x, points.get(0).y);
  for (int i = 2; i < points.size (); i ++) {
    Vec2D p1 = i == 2 ? points.get(i - 2) : points.get(i - 2).interpolateTo(points.get(i - 1), 0.5f);
    Vec2D qC = points.get(i - 1);
    Vec2D p2 = points.get(i - 1).interpolateTo(points.get(i), 0.5f);

    Vec2D c1 = qC.sub(p1).scale(2.0f/3.0f);
    c1.addSelf(p1);
    Vec2D c2 = qC.sub(p2).scale(2.0f/3.0f);
    c2.addSelf(p2);
    vertex(p1.x, p1.y);
    bezierVertex(c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
  }
  endShape();
}


void updateLine() {

  Vec2D m = new Vec2D(mouseX, mouseY);

  if (points == null) {
    points = new ArrayList();
    points.add(m);
  } else {

    if (points.get(points.size() - 1).distanceTo(m) > res)
      addPoint(m);
  }
}

void addPoint(Vec2D p) {
  if (points.size() > 20) {
    //shift
    for (int i = 0; i < 19; i ++)
      points.get(i).set(points.get(i+1));

    points.removeAll(points.subList(19, points.size()));
  }

  points.add(p);
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

