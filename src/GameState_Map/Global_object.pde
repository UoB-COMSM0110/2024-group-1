PGraphics staticCircles; // Used to store static node visual element
PImage desertImage;//Used to generate a nice background image of map
ArrayList<ArrayList<PVector>> circlesByRow = new ArrayList<ArrayList<PVector>>(); //Store the position of each node
class Button {
  float x, y, w, h;
  String label;
  
  Button(float x, float y, float w, float h, String label) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.label = label;
  }
  
  void display() {
    stroke(255);
    fill(100);
    rect(x, y, w, h);
    textAlign(CENTER, CENTER);
    fill(255);
    text(label, x + w/2, y + h/2);
  }
  
  boolean isMouseOver() {
    return mouseX >= x && mouseX <= x + w && mouseY >= y && mouseY <= y + h;
  }
}