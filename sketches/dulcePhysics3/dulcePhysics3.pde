
import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import java.util.*;

VerletPhysics2D physics;
VerletParticle2D ctrl;
ShapeFactory sF;
BezierShape bS;

int res = 100;
boolean mouseDown = false;

ArrayList<VerletShape2D> shapes;

void setup() {
  size(displayWidth, displayHeight);
  smooth();

  physics = new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, -0.01)));
  physics.setWorldBounds(new Rect(0, 0, width, height));

  sF = new ShapeFactory(physics, 0.001, 0.001);

  shapes = new ArrayList();

  bS = new BezierShape();
}

boolean sketchFullScreen() {
  return true;
}

void draw() {
  background(255);
  physics.update();

  beginShape();
  noStroke();

  Vec2D m = mouseDown ? new Vec2D(mouseX, mouseY) : null;

  if (bS.lineComplete) {
    VerletShape2D shape = sF.createShape(bS);
    addShape(shape);
    bS.reset();
  } else {
    bS.update(m);

  }
    bS.display();
  fill(255, 20, 120);
  for (VerletShape2D shape : shapes)
    shape.draw();

  // saveFrame("frames/####.png");
}

void addShape(VerletShape2D shape) {

  println("add shape", shape.particles.size(), shape.springs.size());
  physics.addBehavior(new AttractionBehavior(shape.p, 10, -0.5f, 0.01f));

  for (VerletParticle2D particle : shape.particles)
    physics.addParticle(particle);

  for (VerletSpring2D spring : shape.springs)
    physics.addSpring(spring);

  shapes.add(shape);
}

void removeShape(VerletShape2D shape) {
  boolean failed = false;
  for (VerletParticle2D particle : shape.particles)
    failed = failed || !physics.removeParticle(particle);

  for (VerletSpring2D spring : shape.springs)
    failed = failed || !physics.removeSpring(spring);

  if (failed)
    println("failed to remove!");
    
    shapes.remove(shape);
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
