class NoiseField {
  float scale = 0.01;
  PVector direction = new PVector(0, 0, 0.1);
  PVector position = new PVector();

  NoiseField() {
  } 

  void update() {
    position.add(direction);
  }

  void draw() {
    for (int x = 0; x < width; x ++) {
      for (int y = 0; y < height; y ++) {
        float value = nF.getValue(x, y) * 255;//noise(noiseSeedX+x, noiseSeedY+y) * 255;// + noiseSeed, y + noiseSeed);

        stroke(value);
        point(x, y);
      }
    }
  }
  //returns value for absolute coords (between 0 and 1)
  float getValue(float x, float y) {
    return noise(position.x + x*scale, position.y + y*scale, position.z);
  }
}

