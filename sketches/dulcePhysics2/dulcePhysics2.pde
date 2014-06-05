
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import java.util.*;

VerletPhysics2D physics;
VerletParticle2D p1;

float anchorStrength = 0.001;
float controlStrength = 0.001;

VerletParticle2D ctrl;

ArrayList<VerletShape2D> shapes;

void setup() {
  size(640, 640);
  smooth();

  physics = new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, -0.01)));
  physics.setWorldBounds(new Rect(0, -50, width, height + 50));


  shapes = new ArrayList();

  VerletParticle2D center = new VerletParticle2D(width/2, 50);
  shapes.add(createShape(center));
  
}

VerletShape2D createShape(VerletParticle2D center) {
  color col = color(random(200, 240),random(200, 240),random(200, 240));
  int res = (int)random(3,8);
  float radius = random(30, 50);
  Segment[] segments = createSegments(center, radius, res);
  return new VerletShape2D(center, segments, radius, col);
}

Segment[] createSegments(VerletParticle2D center, float radius, int res) {

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

ArrayList<VerletParticle2D> createOuterParticles(VerletParticle2D center,float radius, int res) {

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

void draw() {
  background(255);
  physics.update();

  beginShape();
  noStroke();

  fill(255, 20, 120);
  for (VerletShape2D shape : shapes)
    shape.draw();
}

void mousePressed(){
  
  VerletParticle2D left = new VerletParticle2D(mouseX,mouseY);
  shapes.add(createShape(left));
}
