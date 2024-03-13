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
        

        bg = loadImage("menu_bg.jpeg");
        startImage = loadImage("start.png");
        combatImage = loadImage("combat.png");
        helpImage = loadImage("help.png");
        shopImage = loadImage("shop.png");
  
        startButton = new Button(600, 300, 230, 60);
        combatButton = new Button(600, 400, 230, 60);
        helpButton = new Button(600, 500, 230, 60);
        shopButton = new Button(900, 600, 100, 100);
    }

    public void handleMouseInput() {
        
        /* change game state to MAP_STATE */
        startButton.update();
        if (startButton.overButton(600, 300, 230, 60) && mousePressed){
            background(240, 210, 200); /* for test */
            // MapState mapState = new MapState();
            // GameState.changeState(engineRef, mapState);
        }

        /* change game state to COMBAT_STATE */
        combatButton.update();
        if (combatButton.overButton(600, 400, 230, 60) && mousePressed){

            ArrayList<Enemy> enemies = new ArrayList<Enemy>();  // Initialize the enemy
            Worm worm = new Worm(passedPlayer);
            enemies.add(worm);
            CombatState combatState = new CombatState(engineRef, passedPlayer, enemies);
            engineRef.changeState(combatState);
        }
  
        /* change to tutorial interface */
        helpButton.update();
        if (helpButton.overButton(600, 500, 230, 60) && mousePressed){
            background(100, 100, 200); // for test
        }
  
        /* change to shop interface */
        shopButton.update();
        if (shopButton.overButton(900, 600, 100, 100) && mousePressed){
            background(200, 300, 250);  // for test
        }
    }

    public void handleKeyInput() {}

    public void drawState() {
        image(bg, 0, 0, width, height);
        image(startImage, 600, 300, 230, 60);    /* the same position as Button */
        image(combatImage, 600, 400, 230, 60);
        image(helpImage, 600, 500, 230, 60);
        image(shopImage, 900, 600, 100, 100);
    }

    public void updateState() {}
    public void pauseState() {}
    public void resumeState() {}
    public void handleMouseWheel(MouseEvent e) {}
}