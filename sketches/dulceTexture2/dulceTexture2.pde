color[] colors = {
  color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)
};
float[] ratios = {
  0.0, 0.5, 1.0
};
color[] colorMap = new color[100];
int resolution = 5;

NoiseField nF;

void setup() {
      size(displayWidth, 600);

  nF = new NoiseField();

  noStroke();
  float ratio, theta;
  int index;

  for (int i = 0; i < 100; i ++) {
    theta = (float)i/100;
    index = 0;
    for (int j = 0; j < ratios.length - 1; j ++) {
      if (theta >= ratios[j])
        index = j;
    }
    ratio = (theta - ratios[index])/(ratios[index + 1] - ratios[index]);
    colorMap[i] = lerpColor(colors[index], colors[index + 1], ratio);
  }

  float barWidth = width/100.0;
  for (int x = 0; x < 100; x ++) {
    fill(colorMap[x]);
    rect(x*barWidth, 0, barWidth, 30);
  }
}

void draw() {
  nF.update();

  for (int x = 0; x < width; x += resolution) {
    for (int y = 30; y < height; y += resolution) {
      float value = nF.getValue(x, y);
      int index = (int)(value*100);
      color c = colorMap[index];
      fill(c);
      rect(x, y, resolution, resolution);
    }
  }
}

