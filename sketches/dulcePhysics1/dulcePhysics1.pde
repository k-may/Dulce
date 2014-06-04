
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import java.util.*;

VerletPhysics2D physics;
VerletParticle2D p1;
ArrayList<Segment> segments;
ArrayList<VerletParticle2D> outer;
int resolution = 4;

void setup() {
  size(640, 640);
  smooth();

  physics = new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.1)));
  physics.setWorldBounds(new Rect(0, 0, width, height));

  p1 = new VerletParticle2D(width/2, 50);
  physics.addParticle(p1);

  createOuterParticles();
  createSegments();
}

void createOuterParticles() {
  outer = new ArrayList();

  float x, y;
  float theta, angle, len = -1;
  int radius = 50;
  VerletParticle2D p = null;
  VerletSpring2D spring = null;
  for (int i = 0; i < resolution; i ++) {
    theta = (float)i / resolution;
    angle = 2*PI*theta;

    x = sin(angle)*radius + p1.x;
    y = cos(angle)*radius + p1.y;

    p = new VerletParticle2D(x, y); 
    physics.addParticle(p);

    spring = new VerletSpring2D(p1, p, radius, 0.01);
    physics.addSpring(spring);

    outer.add(p);
  }
}

void createSegments() {
  segments = new ArrayList();

  VerletParticle2D previous = outer.get(outer.size() - 1);
  VerletParticle2D start, dest, c1, c2 = null;

  VerletSpring2D spring;

  float a1, a2, len, controlLen;
  float inc = PI/resolution;
  Vec2D v;

  float controlStrength = 0.01;

  for (int i = 0; i < outer.size (); i ++) {
    start = outer.get(i);
    dest = outer.get((i + 1)%outer.size());

    a1 = atan2(dest.y - start.y, dest.x - start.x);
    a2 = atan2(start.y - dest.y, start.x - dest.x);

    len = dist(start.x, start.y, dest.x, dest.y);
    spring = new VerletSpring2D(start, dest, len, 0.01);
    physics.addSpring(spring);

    controlLen = len/PI;

    //create c1
    v  = Vec2D.fromTheta(a1 + inc).scale(controlLen);
    len = v.magnitude();
    v.addSelf(start);
    c1 = new VerletParticle2D(v);
    physics.addParticle(c1);

    spring = new VerletSpring2D(start, c1, len, 0.01);
    physics.addSpring(spring);

    spring = new VerletSpring2D(c1, p1, c1.distanceTo(p1), 0.01);
    physics.addSpring(spring);
    
    //attach previous control
    if (c2 != null) {
      spring = new VerletSpring2D(c2, c1, c1.distanceTo(c2), controlStrength);
      physics.addSpring(spring);
    }

    //create c2
    v = Vec2D.fromTheta(a2 - inc).scale(controlLen);
    len = v.magnitude();
    v.addSelf(dest);
    c2 = new VerletParticle2D(v);
    physics.addParticle(c2);

    spring = new VerletSpring2D(dest, c2, len, 0.01);
    physics.addSpring(spring);

    //spring between controls
    spring = new VerletSpring2D(c1, c2, c1.distanceTo(c2), controlStrength);
    physics.addSpring(spring);
    
    spring = new VerletSpring2D(c2, p1, c2.distanceTo(p1), 0.01);
    physics.addSpring(spring);

    //create segment
    Segment s = new Segment(start, c1, c2, dest);
    segments.add(s);

    previous = start;
  }

  //tie last control pair
  c1 = segments.get(0).c1;
  spring = new VerletSpring2D(c1, c2, c1.distanceTo(c2), controlStrength);
  physics.addSpring(spring);
  
}

void draw() {
  background(255);
  physics.update();

  beginShape();
  noStroke();

  fill(255, 20, 120);
  for (Segment s : segments) {
    s.draw();
  }
  endShape();

  for (Segment s : segments) {
    s.drawParticles();
  }
}

class Segment {

  VerletParticle2D c1, c2, p1, p2;

  Segment(VerletParticle2D p1, VerletParticle2D c1, VerletParticle2D c2, VerletParticle2D p2) {

    this.p1 = p1;
    this.p2 = p2;
    this.c1 = c1;
    this.c2 = c2;
  }

  void draw() {
    vertex(p1.x, p1.y);
    bezierVertex(c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
  }

  void drawParticles() {
    ellipse(c1.x, c1.y, 2, 2);

    ellipse(c2.x, c2.y, 2, 2);
  }
}

