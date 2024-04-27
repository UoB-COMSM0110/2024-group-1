class CombatState extends GameState {
    private GameEngine engineRef;
    private Player passedPlayer;
    private ArrayList<Enemy> encounterEnemies;
    private CombatEncounter currEncounter;
    MusicLoader BGMplayer = new MusicLoader();

    CombatState(GameEngine engine, Player thePlayer, ArrayList<Enemy> enemies) {
        engineRef = engine;
        passedPlayer = thePlayer;
        encounterEnemies = enemies;
        currEncounter = new CombatEncounter(passedPlayer, encounterEnemies);
        setupState();
    }

    public void setupState() {
        currEncounter.initEncounter();
        String combatBgmPath = sketchPath("../assets/music/CombatBGM.wav");
        BGMplayer.musicLoad(combatBgmPath);
        BGMplayer.musicPlay();
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
                BGMplayer.musicStop();
                toChangeTo = new EndState(engineRef, passedPlayer, true);
                changeState(engineRef, toChangeTo);
                break;
            case OUTCOME_LOSS:
                BGMplayer.musicStop();
                int bossHP = 50;
                for (Enemy enemy : encounterEnemies) {
                    if(enemy instanceof Boss){
                        bossHP = enemy.getCurrHp();
                        break; 
                    }
                }
                toChangeTo = new EndState(engineRef, passedPlayer, false,bossHP);
                changeState(engineRef, toChangeTo);
                break;
            default:
                break;
        }
    }

    public void pauseState() {}

    public void resumeState() {}

    public void drawState() {
        background(255);
        currEncounter.drawCombat();
    }
}