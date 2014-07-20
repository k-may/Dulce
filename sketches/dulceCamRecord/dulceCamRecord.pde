import processing.video.*;

Capture cam;

void setup() {
  size(640, 480);

  cam = new Capture(this, getCam());
}


void draw() {
  if (cam.available()) {
    image(cam.get(), 0, 0);
    saveFrame();
  }
}

String getCam() {
  // Uses the default video input, see the reference if this causes an error
  String[] cameras = Capture.list();
  int i = 0;
  for (; i < cameras.length; i ++) {
    println(cameras[i]); 
    if (cameras[i].indexOf("Dazzle") != -1)
      break;
  } 
  return cameras[i];
}
