import java.util.Stack;

class GameEngine {
    private static Stack<GameState> stateStack;
    private boolean isRunning;

    GameEngine() {
        stateStack = new Stack();
        isRunning = true;
        // Todo: push main menu state onto state stack here
    }

    public void handleInput() {
        GameState curr = stateStack.peek();
        curr.handleInput();
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