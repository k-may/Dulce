NoiseField nF;
color c1, c2;


void setup() {
  size(displayWidth, displayHeight);
  c1 = color(72,135,222);
  c2 = color(23, 46, 77);

  nF = new NoiseField();
}

boolean sketchFullScreen() {
  return true;
}

void draw() {
  noStroke();
  nF.update();
  //nF.drawField();
  for (int x = 0; x < width; x += 10) {
    for (int y = 0; y < height; y += 10) {
      float value = nF.getValue(x, y);
      color fillColor = lerpColor(c1, c2, value);
      fill(fillColor);
      rect(x, y, 10, 10);
    }
  }
}

