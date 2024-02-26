//Scroll offset used to control map display part
float scrollOffset = 0;

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  scrollOffset += e*20; // Move 20 pixels each scrolling
  scrollOffset = constrain(scrollOffset, 0, contentHeight - embeddedCanvasHeight);
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP) {
      scrollOffset -= 20;
    } else if (keyCode == DOWN) {
      scrollOffset += 20;
    }
    scrollOffset = constrain(scrollOffset, 0, contentHeight - embeddedCanvasHeight);
  }
}

void mousePressed() {
  for (int i = 0; i < buttons.length; i++) {
    if (buttons[i].isMouseOver()) {
      println("Button " + (i + 1) + " clicked: " + buttons[i].label);
      if (buttons[i].label.equals("Tutorial")) {
        displayTextBox = !displayTextBox; // Change the state
        break; // Don't check another operation
      }
    }
  }
}
