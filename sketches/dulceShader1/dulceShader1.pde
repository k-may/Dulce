PShader randTexture;

void setup() {
  size(600, 600, P2D);
  randTexture = loadShader("webgl.glsl");
}

void draw() {
  shader(randTexture);
  rect(0, 0, width, height);
}

