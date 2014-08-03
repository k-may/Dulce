import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);

  cam = new Capture(this, getCam("Dazzle"));
  cam.start();
}


void draw() {
  if (cam.available()) {
    //println("draw!");
    cam.read();
    image(cam.get(), 0, 0);
    saveFrame();
  }
}

String getCam(String name) {
  // Uses the default video input, see the reference if this causes an error
  String[] cameras = Capture.list();
  int i = 0;
  String camName;
  name = name.toLowerCase();
  for (; i < cameras.length; i ++) {
    println(cameras[i]); 
    camName = cameras[i].toLowerCase();
    if (camName.indexOf(name) != -1)
      break;
  } 
  return cameras[i];
}
