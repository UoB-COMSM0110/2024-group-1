class MenuState extends GameState {
    PImage bg, startImage, combatImage, helpImage, shopImage;
    Button startButton, combatButton, helpButton, shopButton;

    GameEngine engineRef;
    private Player passedPlayer;

    MenuState(GameEngine engine, Player thePlayer) {
        engineRef = engine;
        passedPlayer = thePlayer;
        setupState();
    }

    public void setupState() {
        
        passedPlayer = new Player("Initial", 40, 5, 5, 5, 6, 20); //Initialize the player
        

        bg = loadImage("../assets/main/menu_bg.jpeg");
        startImage = loadImage("../assets/main/start.png");
        combatImage = loadImage("../assets/main/combat.png");
        helpImage = loadImage("../assets/main/help.png");
        shopImage = loadImage("../assets/main/shop.png");
  
        startButton = new Button(600, 300, 230, 60, startImage);
        combatButton = new Button(600, 400, 230, 60, combatImage);
        helpButton = new Button(600, 500, 230, 60, helpImage);
        shopButton = new Button(900, 600, 100, 100, shopImage);
    }

    public void handleMouseInput() {
        
        /* change game state to MAP_STATE */
        if (startButton.overButton() && mousePressed){
            background(240, 210, 200); /* for test */
            MapState mapState = new MapState(engineRef, passedPlayer);
            engineRef.changeState(mapState);
        }

        /* change game state to COMBAT_STATE */
        if (combatButton.overButton() && mousePressed){
            ArrayList<Enemy> enemies = new ArrayList<Enemy>();  // Initialize the enemy
            Worm worm = new Worm(passedPlayer);
            enemies.add(worm);
            CombatState combatState = new CombatState(engineRef, passedPlayer, enemies);
            engineRef.changeState(combatState);
        }
  
        /* change to tutorial interface */
        if (helpButton.overButton() && mousePressed){
            background(100, 100, 200); // for test
        }
  
        /* change to shop interface */
        if (shopButton.overButton() && mousePressed){
            background(200, 300, 250);  // for test
        }
    }

    public void handleKeyInput() {}

    public void drawState() {
        image(bg, 0, 0, width, height);
        startButton.drawButton();    /* the same position as Button */
        combatButton.drawButton();
        helpButton.drawButton();
        shopButton.drawButton();
    }

    public void updateState() {}
    public void pauseState() {}
    public void resumeState() {}
    public void handleMouseWheel(MouseEvent e) {}
}