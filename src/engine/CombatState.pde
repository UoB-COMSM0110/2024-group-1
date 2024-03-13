class CombatState extends GameState {
    private GameEngine engineRef;
    private Player passedPlayer;
    private ArrayList<Enemy> encounterEnemies;
    private CombatEncounter currEncounter;

    CombatState(GameEngine engine, Player thePlayer, ArrayList<Enemy> enemies) {
        engineRef = engine;
        passedPlayer = thePlayer;
        encounterEnemies = enemies;
        currEncounter = new CombatEncounter(engineRef, passedPlayer, encounterEnemies);
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

        switch (combatOutcome) {
            case OutcomeType.OUTCOME_WIN:
                EndState toChangeTo = new EndState(passedPlayer, true)
                changeState(engineRef, toChangeTo);
                break;
            case OutcomeType.OUTCOME_LOSS:
                EndState toChangeTo = new EndState(passedPlayer, false)
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