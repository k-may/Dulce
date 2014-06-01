class NoiseField {
  float scale = 0.001;
  PVector direction = new PVector(-0.01, 0, 0.01);
  PVector position = new PVector();

  NoiseField() {
  } 

  void update() {
    position.add(direction);
  }

  void drawField() {
    noStroke();
    for (int x = 0; x < width; x += 10) {
      for (int y = 0; y < height; y += 10) {
        float value = nF.getValue(x, y) * 255;//noise(noiseSeedX+x, noiseSeedY+y) * 255;// + noiseSeed, y + noiseSeed);

        fill(value);
        rect(x, y, 10, 10);
      }
    }
  }
  //returns value for absolute coords (between 0 and 1)
  float getValue(float x, float y) {
    return noise(position.x + x*scale, position.y + y*scale, position.z);
  }
}

