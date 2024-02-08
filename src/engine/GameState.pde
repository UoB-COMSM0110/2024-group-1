abstract class GameState {
  public abstract void setupState();
  public abstract void pauseState();
  public abstract void resumeState();
  public abstract void updateState();
  public abstract void drawState();
  public abstract void handleInput();

  public void changeState(GameEngine engine, GameState newState) {
    engine.changeState(newState);
  }
}
