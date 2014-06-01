Particle[] particles;
int numParticles = 100;

void setup() {
  size(600, 600);
  smooth();

  particles = new Particle[numParticles];
  for (int i = 0; i < numParticles; i++) {
    particles[i] = new Particle();
  }
}

void draw() {
   
fill(255, 10);
rect(0,0,width, height);

fill(0);

  for (int i = 0; i < numParticles; i ++) {
    PVector velocity = new PVector(0, -1);
    for (int j = 0; j < numParticles; j ++) {
      if (j != i) {
         PVector diff = PVector.sub(particles[j].position, particles[i].position);
         
        if (diff.mag() != 0) {
          diff.normalize();
          diff.mult(0.01);
          //diff.mult(2);
          velocity.add(diff);
        }
      }
    }
    particles[i].move(velocity);
    particles[i].draw();
  }
}

