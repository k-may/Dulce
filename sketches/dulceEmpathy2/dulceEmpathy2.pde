import penner.easing.*;
import java.awt.Rectangle;
import java.awt.GraphicsConfiguration;
import java.awt.GraphicsDevice;
import java.awt.GraphicsEnvironment;
Rectangle monitor = new Rectangle();

Boolean pressed = false;
PImage[] frames;

PFont font;

PVector eyePos;

Eye[] eyes;
Eye eye;

void setup() {
  // Get second screen details and save as Rectangle monitor
  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
  GraphicsDevice[] gs = ge.getScreenDevices();
  // gs[1] gets the *second* screen. gs[0] would get the primary screen
  GraphicsDevice gd = gs[1];
  GraphicsConfiguration[] gc = gd.getConfigurations();
  monitor = gc[0].getBounds();

  //println(monitor.x + " " + monitor.y + " " + monitor.width + " " + monitor.height);
  size(monitor.width, monitor.height, P2D);
  //size(displayWidth, displayHeight);
  font = createDefaultFont(10);
  /*
  eyes = new Eye[1];
   
   for (int x = 0; x < 1; x ++) {
   for (int y = 0; y < 1; y ++) {
   Eye eye = new Eye();
   eye.pos = new PVector(x * width / 10, y * height/10);
   
   eyes[x + y * 1] = eye;
   }
   }
   */
  eye = new Eye(new PVector(100, 100));
}

public void init() {
  frame.removeNotify();
  frame.setUndecorated(true);
  super.init();
} 

void draw() {

  background(0);

  if (pressed)
    eye.pos.lerp(new PVector(mouseX - eye.center.x, mouseY - eye.center.y), 0.01);

  int elapsed = millis();
  //eye.pos.x = mouseX - eye.center.x;
  //eye.pos.y = mouseY - eye.center.y;
  eye.draw(elapsed);
  /* 
   for (int i = 0; i < eyes.length; i ++) {
   eyes[i].draw(elapsed);
   }
   */

  textFont(font);
  text(frameRate, 10, 10);
}

void mousePressed(){
  pressed = true;
}

void mouseReleased(){
 pressed = false; 
}

