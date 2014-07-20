class VideoCapture {

  Capture video;
  PImage image;
  int x, y;
  Mesh mesh;
  PGraphics output;
  PShader shader;
  int width;
  int height;
  int imgWidth;
  int imgHeight;
  float scale = 0.6;
  int newWidth;
  int newHeight;
  int[] uv_coords;

  public VideoCapture(PApplet parent, int videoWidth, int videoHeight) {

    this.width = videoWidth;
    this.height = videoHeight;
    newWidth = (int)(this.width*scale);
    newHeight = (int)(this.height*scale);

    x = 0; 
    y = 0;

    video = new Capture(parent, getCam());
    video.start();

    output = parent.createGraphics(videoWidth, videoHeight, P2D);
    mesh = new Mesh(parent, videoWidth, videoHeight, scale);
  }

  void draw() {
    if (video.available()) {
      video.read();
      image = video.get();
    }


    image(image, x, y, newWidth, newHeight);
    mesh.draw(x, y);
  } 

  PImage croppedImage(int[] coords) {

    int[] pos = mesh.getPos();

    output.beginDraw();
    output.beginShape(TRIANGLES );
    output.texture(image);

    output.vertex(coords[0], coords[1], pos[0], pos[1]);
    output.vertex(coords[2], coords[3], pos[2], pos[3]);
    output.vertex(coords[6], coords[7], pos[6], pos[7]);

    output.vertex(coords[2], coords[3], pos[2], pos[3]);
    output.vertex(coords[4], coords[5], pos[4], pos[5]);
    output.vertex(coords[6], coords[7], pos[6], pos[7]);

    output.endShape();
    output.endDraw();
    output.loadPixels();
    return output.get();
  }

  String getCam() {
    // Uses the default video input, see the reference if this causes an error
    String[] cameras = Capture.list();
    int i = 0;
    for (; i < cameras.length; i ++) {
      //println(cameras[i]); 
      if (cameras[i].indexOf("Dazzle") != -1)
        break;
    } 
    return cameras[i];
  }

  boolean available() {
    return video.available();
  }

  void down(int x, int y) {
    mesh.down(x, y);
  }

  void up(int x, int y) {
    mesh.up(x, y);
  }

  void dragged(int x, int y) {
    mesh.dragged(x, y);
  }
}
