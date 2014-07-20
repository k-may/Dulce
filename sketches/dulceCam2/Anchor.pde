class Anchor {
  int overColor = color(255, 0, 0);
  int outColor = color(0, 255, 0);
  boolean isActive = false;

  int x, y;
  int size = 10;
  int col;

  public Anchor(int x, int y) {
    this.x = x;
    this.y = y;
    
  } 

  void draw(int offsetX, int offsetY) {
    fill(isActive ? overColor : outColor);
    ellipse(offsetX + x, offsetY + y, 10, 10);
  } 

  boolean isOver(int mX, int mY) {
    return (mX > x - size && mX < x + size && mY > y - size && mY < y + size);
  }
}
