  
class ShopState extends GameState {
 
  private GameEngine engineRef;
    private Player passedPlayer;
    private Shop shop;
   CombatState(GameEngine engine, Player thePlayer, ArrayList<Enemy> enemies) {
        engineRef = engine;
        passedPlayer = thePlayer;
        encounterEnemies = enemies;
        currEncounter = new CombatEncounter(passedPlayer, encounterEnemies);
        setupState();
    }

    public void setupState() {
        currEncounter.initEncounter();
    }

    public void handleMouseInput() {
        currEncounter.processMouseInput();
    }

    public void handleMouseWheel(MouseEvent e) {}

    public void handleKeyInput() {}

    public void updateState() {
        OutcomeType combatOutcome = currEncounter.checkWinLoss();
        EndState toChangeTo;

        switch (combatOutcome) {
            case OUTCOME_WIN:
                toChangeTo = new EndState(passedPlayer, true);
                changeState(engineRef, toChangeTo);
                break;
            case OUTCOME_LOSS:
                toChangeTo = new EndState(passedPlayer, false);
                changeState(engineRef, toChangeTo);
                break;
            default:
                break;
        }
    }

    public void pauseState() {}

    public void resumeState() {}

    public void drawState() {
        currEncounter.drawCombat();
    }
}
   