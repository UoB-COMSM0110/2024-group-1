GameEngine engine;

void setup() {
  size(1000, 800, P3D);
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