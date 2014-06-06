class BezierShape {

  Vec2D lastPoint;
  boolean lineComplete;
  ArrayList<Line2D> lines;

  BezierShape() {
    lineComplete = false;
    reset();
  }

  void reset() {
    lastPoint = null;
    lines = new ArrayList();
  }

  void update(Vec2D m) {

    if (lineComplete)
      return;
    if (m == null) {
      reset();
    } else if (lastPoint == null)
      lastPoint = m;
    else if (lastPoint.distanceTo(m) > res)
      addLine(m);
  }


  void addLine(Vec2D m) {

    Line2D line = new Line2D(lastPoint, m);

    //test for intersetion
    Line2D.LineIntersection lInt;
    Line2D l;
    int i;

    for (i = 0; i < lines.size () - 3; i ++) {
      l = lines.get(i);
      lInt = l.intersectLine(line);
      if (lInt.getType() == Line2D.LineIntersection.Type.INTERSECTING) {
        m = lInt.getPos();
        //complete shape
        line = new Line2D(line.a, m);
        l.a = m;
        lineComplete = true;

        lines.removeAll(lines.subList(0, i));

        break;
      }
    }

    lastPoint = m;
    lines.add(line);
  }
  
  
  void display() {
    drawLine();

    if (lineComplete);
    drawCurve();
  }

  void drawCurve() {
    stroke(255, 0, 0);
    beginShape();

    int len = lineComplete ? lines.size() : lines.size() - 1;

    for (int i = 0; i < len; i ++) {
      Line2D l = lines.get(i);
      Vec2D p1 = l.a.interpolateTo(l.b, 0.5f);
      Vec2D qC = l.b;
      l = lines.get((i + 1)%lines.size());
      Vec2D p2 = l.a.interpolateTo(l.b, 0.5f);

      Vec2D c1 = qC.sub(p1).scale(2.0f/3.0f);
      c1.addSelf(p1);
      Vec2D c2 = qC.sub(p2).scale(2.0f/3.0f);
      c2.addSelf(p2);
      vertex(p1.x, p1.y);
      bezierVertex(c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
    }

    endShape();
  }

  void drawLine() {
    stroke(0);
    for (Line2D l : lines)
      line(l.a.x, l.a.y, l.b.x, l.b.y);
  }
}

