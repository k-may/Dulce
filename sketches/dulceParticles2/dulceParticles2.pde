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
  background(255);
  //fill(255, 10);
  //rect(0, 0, width, height);

  fill(255);

  for (int i = 0; i < numParticles; i ++) {
    PVector velocity = new PVector(0, -1);
    for (int j = 0; j < numParticles; j ++) {
      if (j != i) {
        PVector diff = new PVector(particles[j].position.x - particles[i].position.x, 
        (particles[j].position.y - particles[i].position.y)%height);//PVector.sub(particles[j].position, particles[i].position);
        float mag = diff.mag();
        if (mag > particles[i].size) {
          diff.normalize();
          diff.mult(1/mag);
          //diff.mult(2);
          velocity.add(diff);
        } else {
          if (particles[i].size >= particles[j].size) {
            if (particles[i].size < 10)
              particles[i].size += particles[j].size;
            else 
              particles[i].reset();

              particles[j].reset();
          } else if (particles[j].size >= particles[i].size) {
            if (particles[j].size < 10)
              particles[j].size += particles[i].size;
            else 
              particles[j].reset();


            particles[i].reset();
          }
        }
      }
    }
    particles[i].move(velocity);
    particles[i].draw();
  }
}

