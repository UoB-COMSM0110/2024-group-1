GameEngine engine;

void settings() {
  size(displayWidth, displayHeight-50, P3D);
}

void setup() {
  engine = new GameEngine();
}

void draw() {
  engine.updateGame();
  engine.drawScreen();
}

void keyPressed() {
  engine.handleKeyInput();
}

void mousePressed() {
  engine.handleMouseInput();
}

void mouseWheel(MouseEvent event) {
  engine.handleMouseWheel(event);
}