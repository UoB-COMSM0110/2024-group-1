GameEngine engine;

void setup() {
  size(1000, 800, P3D);
  engine = new GameEngine();
}

void draw() {
  engine.handleInput();
  engine.updateGame();
  engine.drawScreen();
}

