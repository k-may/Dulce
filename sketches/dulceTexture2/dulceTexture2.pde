color[] colors = {
  color(255, 0, 0), color(0, 255, 0), color(0, 0, 255)
};
float[] ratios = {
  0.0, 0.3, 1.0
};
color[] colorMap = new color[100];

void setup() {
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
    rect(x, 0, x*((float)width/100), 30);
  }
}

void draw(){
  
}

