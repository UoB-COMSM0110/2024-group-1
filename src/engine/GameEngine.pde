import java.util.Stack;

class GameEngine {
    private static Stack<GameState> stateStack;
    private Player thePlayer;
    private boolean isRunning;

    GameEngine() {
        stateStack = new Stack();
        isRunning = true;
        thePlayer = null;
        // Todo: push main menu state onto state stack here
    }

    public void handleMouseInput() {
        GameState curr = stateStack.peek();
        curr.handleMouseInput();
    }

    public void handleMouseWheel(MouseEvent e) {
        GameState curr = stateStack.peek();
        curr.handleMouseWheel(e);
    }

    public void handleKeyInput() {
        GameState curr = stateStack.peek();
        curr.handleKeyInput();
    }

    public void updateGame() {
        GameState curr = stateStack.peek();
        curr.updateState();
    }

    public void drawScreen() {
        GameState curr = stateStack.peek();
        curr.drawState();
    }

    public void changeState(GameState state) {
        if (!stateStack.empty()) {
            stateStack.pop();
        }

        stateStack.push(state);
    }

    public void endEngine() {
        while (!stateStack.empty()) {
            stateStack.pop();
        }

        isRunning = false;
    }

    public boolean isRunning() {
        return isRunning;
    }
}