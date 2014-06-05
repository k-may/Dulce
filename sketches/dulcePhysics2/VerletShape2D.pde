class VerletShape2D {
  Segment[] segs;
  VerletParticle2D p;
  ArrayList<VerletSpring2D> springs;
  color col;

  boolean drawFrame = false;
  boolean drawControls = false;

  VerletShape2D(VerletParticle2D center, Segment[] segs, float radius, color col) {
    this.segs = segs;
    this.p = center;
    this.col = col;
    physics.addBehavior(new AttractionBehavior(p, radius, -0.5f, 0.01f));

    springs = new ArrayList();

    physics.addParticle(p);

    VerletSpring2D spring;
    VerletParticle2D p1, p2, c1, c2, prevCtrl = null;
    for (int i = 0; i < segs.length; i ++) {

      p1 = segs[i].p1;
      p2 = segs[i].p2;
      c1 = segs[i].c1;
      c2 = segs[i].c2;

      physics.addParticle(p1);
      physics.addParticle(p2);
      physics.addParticle(c1);
      physics.addParticle(c2);

      //tie anchor to center (one for each segment)
      spring = new VerletSpring2D(p, p1, p.distanceTo(p1), anchorStrength);
      addSpring(spring);

      //tie anchors
      spring = new VerletSpring2D(p1, p2, p1.distanceTo(p2), anchorStrength);
      addSpring(spring);

      //tie anchors to controls
      spring = new VerletSpring2D(p1, c1, p1.distanceTo(c1), anchorStrength);
      addSpring(spring);

      spring = new VerletSpring2D(p2, c2, p2.distanceTo(c2), anchorStrength);
      addSpring(spring);


      //tie controls
      spring = new VerletSpring2D(c1, c2, c1.distanceTo(c2), controlStrength);
      addSpring(spring);

      //tie controls to previous
      if (prevCtrl != null) {
        spring = new VerletSpring2D(prevCtrl, c1, prevCtrl.distanceTo(c1), anchorStrength);
        addSpring(spring);
      }
      prevCtrl = c2;

      spring = new VerletSpring2D(p, c1, p.distanceTo(c1), controlStrength);
      addSpring(spring);

      spring = new VerletSpring2D(p, c2, p.distanceTo(c2), controlStrength);
      addSpring(spring);
    }

    spring = new VerletSpring2D(prevCtrl, segs[0].c1, prevCtrl.distanceTo(segs[0].c1), anchorStrength);
    addSpring(spring);

    println("num springs : " + springs.size());
  }

  void addSpring(VerletSpring2D spring) {
    springs.add(spring);
    physics.addSpring(spring);
  }

  void draw() {
    noStroke();
    fill(col);
    beginShape();
    for (int i = 0; i < segs.length; i ++) {
      segs[i].draw();
    }
    endShape();

    if (drawControls) {
      noFill();
      stroke(100);
      for (int i = 0; i < segs.length; i ++) {
        segs[i].drawParticles();
      }
    }

    if (drawFrame) {
      stroke(200);
      for (VerletSpring2D s : springs) {
        line(s.a.x, s.a.y, s.b.x, s.b.y);
      }
    }
  }
}

