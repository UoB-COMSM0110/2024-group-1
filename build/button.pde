class Button {

  int buttonX, buttonY, buttonW, buttonH;
  Boolean buttonOver = false;
  
  // Constructor to create a button
  Button(int x, int y, int w, int h) {
    buttonX = x;
    buttonY = y;
    buttonW = w;
    buttonH = h;
  }
  
  void update() {
    if ( overButton(buttonX, buttonY, buttonW, buttonH)){
      buttonOver = true;
    }
    else{
      buttonOver = false;
    }
  }
    
    /* assume all the button will be rectangle */
    boolean overButton(int x, int y, int w, int h) {
      if(mouseX >= x && mouseX <= x+w &&
         mouseY >= y && mouseY <= y+h) {
           return true;
         } else {
           return false;
         }
    }
}
