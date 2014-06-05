
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import java.util.*;

VerletPhysics2D physics;
VerletParticle2D p1;
ArrayList<Segment> segments;
ArrayList<VerletParticle2D> outer;
int resolution = 4;

float anchorStrength = 0.01;
float controlStrength = 0.01;

VerletParticle2D ctrl;

VerletShape shape;

void setup() {
  size(640, 640);
  smooth();

  physics = new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, 0.1)));
  physics.setWorldBounds(new Rect(0, 0, width, height));

  p1 = new VerletParticle2D(width/2, 50);
  //physics.addParticle(p1);

  createOuterParticles();
  createSegments();
  
  shape = new VerletShape(p1, segments.toArray(new Segment[segments.size()]));
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
    //physics.addParticle(p);

    //spring = new VerletSpring2D(p1, p, radius, 0.01);
   // physics.addSpring(spring);

    outer.add(p);
  }
}

void createSegments() {
  segments = new ArrayList();

  //VerletParticle2D previous = outer.get(outer.size() - 1);
  VerletParticle2D start, dest, c1, c2;// = null;

  //VerletSpring2D spring;

  float a1, a2, len, controlLen;
  float inc = PI/resolution;
  //Vec2D v;

  ArrayList<VerletParticle2D> cPts = new ArrayList();

  for (int i = 0; i < outer.size(); i ++) {
    start = outer.get(i);
    dest = outer.get((i + 1)%outer.size());

    a1 = atan2(dest.y - start.y, dest.x - start.x);
    a2 = atan2(start.y - dest.y, start.x - dest.x);

    len = dist(start.x, start.y, dest.x, dest.y);
    
    //spring = new VerletSpring2D(start, dest, len, 0.01);
    //physics.addSpring(spring);

    controlLen = len/PI;

    //create c1
    c1 = createControl(start, a1 + inc, controlLen);
    c2 = createControl(dest, a2 - inc, controlLen);

    //create segment
    Segment s = new Segment(start, c1, c2, dest);
    segments.add(s);

  }

  //tie last control pair
  /*c1 = segments.get(0).c1;
  spring = new VerletSpring2D(c1, c2, c1.distanceTo(c2), controlStrength);
  physics.addSpring(spring);*/
}

VerletParticle2D createControl(VerletParticle2D p, float angle, float len) {
  Vec2D v = Vec2D.fromTheta(angle).scale(len);
  float mag = v.magnitude();
  v.addSelf(p);

 // VerletParticle2D previous = (ctrl != null) ? ctrl : null;

  ctrl = new VerletParticle2D(v);
  //physics.addParticle(ctrl);

  //VerletSpring2D spring = new VerletSpring2D(p, ctrl, mag, 0.01);
  //physics.addSpring(spring);

  /*if (previous != null) {
    //link ctrl points
    spring = new VerletSpring2D(previous, ctrl, previous.distanceTo(ctrl), controlStrength);
    physics.addSpring(spring);
  }*/

  //link to center
  //spring = new VerletSpring2D(ctrl, p1, ctrl.distanceTo(p1), 0.01);
  //physics.addSpring(spring);

  return ctrl;
}

void draw() {
  background(255);
  physics.update();

  beginShape();
  noStroke();

  fill(255, 20, 120);
  shape.draw();

}

