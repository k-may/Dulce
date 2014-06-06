class ShapeFactory {

  VerletPhysics2D physics;

  float anchorStrength = 0.001;
  float controlStrength = 0.001;
  int alpha = 150;

  ShapeFactory(VerletPhysics2D physics, float anchorStrength, float controlStrength) {
    this.physics = physics;
    this.anchorStrength = anchorStrength;
    this.controlStrength = controlStrength;
  }

  VerletShape2D createShape(VerletParticle2D center) {
    color col = color(random(200, 240), random(200, 240), random(200, 240), alpha);
    int res = (int)random(3, 8);
    float radius = random(30, 50);
    Segment[] segments = createPolySegments(center, radius, res);
    return new VerletShape2D(center, segments, col, anchorStrength, controlStrength);
  }

  VerletShape2D createShape(BezierShape bS) {
    color col = color(random(200, 240), random(200, 240), random(200, 240), alpha);
    Segment[] segs = createBezierShapeSegments(bS.lines);
    VerletParticle2D center = new VerletParticle2D(getCenterPoint(segs));

    return new VerletShape2D(center, segs, col, anchorStrength, controlStrength);
  }

  Vec2D getCenterPoint(Segment[] segs) {
    int x = 0;
    int y = 0;

    int len = segs.length;

    for (int i = 0; i < len; i ++) {
      x += segs[i].p1.x;
      y += segs[i].p1.y;
    }
    x /= len;
    y /= len;

    return new Vec2D(x, y);
  }

  Segment[] createBezierShapeSegments(ArrayList<Line2D> lines) {
    int len = lines.size();
    Segment[] segs = new Segment[len];

    Vec2D p1, p2, c1, c2, qC;

    Line2D l;
    VerletParticle2D start = null;
    VerletParticle2D dest;

    for (int i = 0; i < len; i ++) {
      l = lines.get(i);
      p1 = l.a.interpolateTo(l.b, 0.5f);
      qC = l.b;
      l = lines.get((i + 1)%lines.size());
      p2 = l.a.interpolateTo(l.b, 0.5f);

      c1 = qC.sub(p1).scale(2.0f/3.0f);
      c1.addSelf(p1);
      c2 = qC.sub(p2).scale(2.0f/3.0f);
      c2.addSelf(p2);

      if (start == null)
        start = new VerletParticle2D(p1);

      if (i == len -1)
        dest = segs[0].p1;
      else
        dest = new VerletParticle2D(p2);

      segs[i] = new Segment(start, new VerletParticle2D(c1), new VerletParticle2D(c2), dest);

      start = dest;
    }

    return segs;
  }

  Segment[] createPolySegments(VerletParticle2D center, float radius, int res) {

    ArrayList<VerletParticle2D> outer =  createOuterParticles(center, radius, res);
    Segment[] segments = new Segment[res];

    VerletParticle2D start, dest, c1, c2;// = null;

    float a1, a2, len, controlLen;
    float inc = PI/res;

    ArrayList<VerletParticle2D> cPts = new ArrayList();

    for (int i = 0; i < outer.size (); i ++) {
      start = outer.get(i);
      dest = outer.get((i + 1)%outer.size());

      a1 = atan2(dest.y - start.y, dest.x - start.x);
      a2 = atan2(start.y - dest.y, start.x - dest.x);

      len = dist(start.x, start.y, dest.x, dest.y);
      controlLen = len/PI;

      //create c1
      c1 = createControl(start, a1 + inc, controlLen);
      c2 = createControl(dest, a2 - inc, controlLen);

      segments[i] = new Segment(start, c1, c2, dest);
    }

    return segments;
  }

  ArrayList<VerletParticle2D> createOuterParticles(VerletParticle2D center, float radius, int res) {

    ArrayList<VerletParticle2D> outer = new ArrayList();

    //create symmetrical shape
    float x, y;
    float theta, angle, len = -1;

    VerletParticle2D p = null;
    VerletSpring2D spring = null;
    for (int i = 0; i < res; i ++) {
      theta = (float)i / res;
      angle = 2*PI*theta;

      x = sin(angle)*radius + center.x;
      y = cos(angle)*radius + center.y;

      p = new VerletParticle2D(x, y); 

      outer.add(p);
    }

    return outer;
  }

  VerletParticle2D createControl(VerletParticle2D p, float angle, float len) {
    Vec2D v = Vec2D.fromTheta(angle).scale(len);
    float mag = v.magnitude();
    v.addSelf(p);
    return new VerletParticle2D(v);
  }
}

