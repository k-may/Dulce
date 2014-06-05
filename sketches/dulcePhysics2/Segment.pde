class Segment {

  VerletParticle2D c1, c2, p1, p2;

  Segment(VerletParticle2D p1, VerletParticle2D c1, VerletParticle2D c2, VerletParticle2D p2) {

    this.p1 = p1;
    this.p2 = p2;
    this.c1 = c1;
    this.c2 = c2;
  }

  void draw() {
    vertex(p1.x, p1.y);
    bezierVertex(c1.x, c1.y, c2.x, c2.y, p2.x, p2.y);
  }

  void drawParticles() {
    ellipse(c1.x, c1.y, 2, 2);
    ellipse(c2.x, c2.y, 2, 2);
  }
}
