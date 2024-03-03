class EndButton {
  int buttonX, buttonY, buttonW, buttonH;
  
  EndButton(PImage img, int x, int y) {
    buttonX = x;
    buttonY = y;
    buttonW = img.width;
    buttonH = img.height;
  }
  
  boolean isClicked() {
    if (mouseX >= buttonX && mouseX <= buttonX+buttonW && mouseY >= buttonY && mouseY <= buttonY+buttonH) {
      return true;
    } else {
      return false;
    }
  }
}
