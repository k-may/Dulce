class Mesh {

  PVector downPos;
  Anchor tL, tR, bL, bR;
  Anchor[] anchors;
  int x, y;
  int width, height;
  int[] pos;
  PGraphics graphics;
  float displayScale = 0.6;

  public Mesh(PApplet parent, int width, int height, float displayScale) {
    x = 0; 
    y = 0;
    this.displayScale = displayScale;
    this.width = width;
    this.height = height;
    
    tL = new Anchor ((int)(18*displayScale), (int)(75*displayScale));
    tR = new Anchor ((int)(640*displayScale), (int)(99*displayScale));
    bR = new Anchor ((int)(643*displayScale), (int)(443*displayScale));
    bL = new Anchor ((int)(11*displayScale), (int)(429*displayScale));
    
    anchors = new Anchor[] {
      tL, tR, bR, bL
    };
    
    graphics = parent.createGraphics((int)(this.width*displayScale), (int)(this.height*displayScale));
  }

  void draw(int offsetX, int offsetY) {
    pos = new int[8];
    int c = 0;
    int xPos = offsetX + x;
    int yPos = offsetY + y;

    for (int i = 0; i < anchors.length; i ++) {
      anchors[i].draw(xPos, yPos);
      pos[c ++] = (int)(anchors[i].x/displayScale);
      pos[c ++] = (int)(anchors[i].y/displayScale);
    }

    graphics.beginDraw();
    graphics.background(0, 0);
    graphics.beginShape(TRIANGLES);
    graphics.noFill();
    graphics.stroke(255);
    graphics.vertex(pos[0]*displayScale, pos[1]*displayScale);
    graphics.vertex(pos[2]*displayScale, pos[3]*displayScale);
    graphics.vertex(pos[6]*displayScale, pos[7]*displayScale);
    graphics.vertex(pos[2]*displayScale, pos[3]*displayScale);
    graphics.vertex(pos[4]*displayScale, pos[5]*displayScale);
    graphics.vertex(pos[6]*displayScale, pos[7]*displayScale);
    graphics.endShape();
    graphics.endDraw();

    image(graphics, offsetX, offsetY);
  }

  void dragged(int x, int y) {
    for (int i = 0; i< anchors.length; i ++) {
      if (anchors[i].isActive) {
        anchors[i].x = (int)(x + downPos.x);
        anchors[i].y = (int)(y + downPos.y);

        println(anchors[i].x/displayScale, anchors[i].y/displayScale);
      }
    }
  }

  void down(int x, int y) {
    for (int i = 0; i < anchors.length; i ++) {
      anchors[i].isActive = anchors[i].isOver(x, y);

      if (anchors[i].isActive) {
        downPos = new PVector(anchors[i].x - x, anchors[i].y - y);
      }
    }
  }

  void up(int x, int y) {
    for (int i = 0; i < anchors.length; i ++) {
      anchors[i].isActive = false;
    }
  }
  
  int[] getPos(){
   return pos; 
  }
  
}
