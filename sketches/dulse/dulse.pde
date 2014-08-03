import oscP5.*;
import netP5.*;

import java.awt.Rectangle;
import java.awt.GraphicsConfiguration;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;

import toxi.physics2d.*;
import toxi.physics2d.behaviors.*;
import toxi.geom.*;
import java.util.*;

VerletPhysics2D physics;
VerletParticle2D ctrl;
ShapeFactory sF;
BezierShape bS;

int res = 10;
boolean mouseDown = false;
OSCClient client;
ArrayList<VerletShape2D> shapes;

Rectangle monitor = new Rectangle();

void setup() {
  client = new OSCClient(this);
  // Get second screen details and save as Rectangle monitor
  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
  GraphicsDevice[] gs = ge.getScreenDevices();
  // gs[1] gets the *second* screen. gs[0] would get the primary screen
  GraphicsDevice gd = gs[1];
  GraphicsConfiguration[] gc = gd.getConfigurations();
  monitor = gc[0].getBounds();

  //println(monitor.x + " " + monitor.y + " " + monitor.width + " " + monitor.height);
  size(monitor.width, monitor.height);
  //size(displayWidth, displayHeight);
  smooth();

  physics = new VerletPhysics2D();
  physics.addBehavior(new GravityBehavior(new Vec2D(0, -0.01)));
  physics.setWorldBounds(new Rect(0, 0, width, height));

  sF = new ShapeFactory(physics, 0.005, 0.005);

  shapes = new ArrayList();

  bS = new BezierShape();
}

public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  super.init();
} 

/*boolean sketchFullScreen() {
 return true;
 }*/

void draw() {
  frame.setLocation(monitor.x, monitor.y);
  frame.setAlwaysOnTop(true); 

  background(240);//,240,240);
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

  client.send();
  println("add shape", shape.particles.size(), shape.springs.size());
  physics.addBehavior(new AttractionBehavior(shape.p, 100, -0.5f, 0.01f));

  for (VerletParticle2D particle : shape.particles)
    physics.addParticle(particle);

  for (VerletSpring2D spring : shape.springs)
    physics.addSpring(spring);

  if (shapes.size() > 10)
    shapes.remove(0);

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

