class Button {

  int buttonX, buttonY, buttonW, buttonH;
  PImage buttonIcon;
  
  // Constructor to create a button
  Button(int x, int y, int w, int h, PImage icon) {
    buttonX = x;
    buttonY = y;
    buttonW = w;
    buttonH = h;
    buttonIcon = icon;
  }

  /* assume all the button will be rectangle */
  boolean overButton() {
    if(mouseX >= buttonX && mouseX <= buttonX+buttonW &&
        mouseY >= buttonY && mouseY <= buttonY+buttonH) {
          return true;
        } else {
          return false;
        }
  }

  public void drawButton() {
    image(buttonIcon, buttonX, buttonY, buttonW, buttonH);
  }
}
