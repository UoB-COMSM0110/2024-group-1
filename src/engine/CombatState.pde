class CombatState extends GameState {
    GameEngine engineRef;
    private Player passedPlayer;
    ArrayList<Enemy> encounterEnemies;
    private CombatEncounter currEncounter;

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

    public void handleInput() {
        currEncounter.processInput();
    }

    public void updateState() {}

    public void drawState() {
        currEncounter.drawCombat();
    }
}