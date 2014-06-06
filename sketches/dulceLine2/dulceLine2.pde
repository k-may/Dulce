import toxi.geom.*;
import toxi.processing.*;
import java.util.*;

ArrayList<Vec2D> points;
ArrayList<Line2D> lines;
boolean mouseDown, lineComplete;
int res = 100;

void setup() {
  size(640, 440);
  mouseDown = false;
  lineComplete = false;
}


void draw() {
  background(255);
  noFill();

  if (mouseDown)
    updateLine();
  else {
    if (!lineComplete) {
      if (points != null)
        points = null;

      if (lines != null)
        lines = null;
    }
  }

  if (lines != null)
    drawLine();
}

void drawLine() {

  for (Line2D l : lines){
  // println(l.a, l.b);
    line(l.a.x, l.a.y, l.b.x, l.b.y);
    
  }
}

void updateLine() {

  Vec2D m = new Vec2D(mouseX, mouseY);

  if (points == null) {
    points = new ArrayList();
    points.add(m);
  } else {
    if (points.get(points.size() - 1).distanceTo(m) > res) {

      if (lines == null)
        lines = new ArrayList();

      Line2D line = new Line2D(points.get(points.size() - 1), m);
/*
      //test for intersetion
      Line2D.LineIntersection lInt;
      for (Line2D l : lines) {
        lInt = l.intersectLine(line);
        if (lInt.getType() == Line2D.LineIntersection.Type.INTERSECTING) {
          println("intersect! ->"  + l.a, l.b, m);
          m = lInt.getPos();
          line = new Line2D(line.a, m);
          break;
        }
      }
      */

     // println("add : "  + m, lines.size(), points.size());
      lines.add(line);
      points.add(m);
    }
  }
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

