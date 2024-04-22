class MenuState extends GameState {
    PImage bg, startImage, combatImage, helpImage, shopImage, easyModeImage, hardModeImage, backImage;
    Button startButton, combatButton, helpButton, shopButton, easyButton, hardButton, backButton;
    MusicLoader BGMplayer = new MusicLoader();

    GameEngine engineRef;
    private Player passedPlayer;
    private Boolean modeChoiceVisibility = false;

    MenuState(GameEngine engine, Player thePlayer) {
        engineRef = engine;
        passedPlayer = thePlayer;
        setupState();
        String bgmPath = sketchPath("../assets/music/RegularFlowBGM.wav");
        BGMplayer.musicLoad(bgmPath);
        BGMplayer.musicPlay();
    }

    public void setupState() {
        
        passedPlayer = new Player("Initial", 40, 5, 5, 5, 6, 20); //Initialize the player
        

        bg = loadImage("../assets/main/menu_bg.jpeg");
        startImage = loadImage("../assets/main/start.png");
        combatImage = loadImage("../assets/main/combat.png");
        helpImage = loadImage("../assets/main/help.png");
        shopImage = loadImage("../assets/main/shop.png");
        easyModeImage = loadImage("../assets/main/easy.png");
        hardModeImage = loadImage("../assets/main/hard.png");
        backImage = loadImage("../assets/map/backButton.png");
  
        startButton = new Button(600, 300, 230, 60, startImage);
        combatButton = new Button(600, 400, 230, 60, combatImage);
        helpButton = new Button(600, 500, 230, 60, helpImage);
        shopButton = new Button(900, 600, 100, 100, shopImage);
        easyButton = new Button(850,400,230,60,easyModeImage);
        hardButton = new Button(850,500,230,60,hardModeImage);
        backButton = new Button(600,300,230,60,backImage);
    }

    public void handleMouseInput() {
        
        /* change game state to MAP_STATE */
        if (startButton.overButton() && mousePressed){
            if(checkFileExists("../assets/map/mapTemp.json")){
                System.out.println("Loading from last game");
                BGMplayer.musicStop();
                goToEasyMode();
            }else{
                modeChoiceVisibility = !modeChoiceVisibility; 
                System.out.println("Start a new game with mode choice option");
            }
            //background(240, 210, 200); /* for test */
            //MapState mapState = new MapState(engineRef, passedPlayer);
            //engineRef.changeState(mapState);
        }

        if (easyButton.overButton() && mousePressed){
            BGMplayer.musicStop();
            goToEasyMode();
        }else if(hardButton.overButton() && mousePressed){
            BGMplayer.musicStop();
            goToHardMode();
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
          ArrayList<Card> cards = new ArrayList<>();
          cards.add(new AngerCard());
          cards.add(new PoisonCard());
          cards.add(new StrikeCard());
          cards.add(new AngerCard());
          cards.add(new BashCard());
          cards.add(new StrikeCard());
          cards.add(new StrikeCard());
          cards.add(new AngerCard());
          cards.add(new BashCard());
          cards.add(new StrikeCard());
          engineRef.changeState(new ShopState(engineRef, passedPlayer, cards));
        }
    }

    public void handleKeyInput() {}

    public void drawState() {
        background(255);
        image(bg, 0, 0, width, height);
        
        if(modeChoiceVisibility){
            easyButton.drawButton();
            hardButton.drawButton();
            backButton.drawButton();
        }else{
            startButton.drawButton();    /* the same position as Button */
            combatButton.drawButton();
            helpButton.drawButton();
            shopButton.drawButton();
        }
    }

    public void updateState() {}
    public void pauseState() {}
    public void resumeState() {}
    public void handleMouseWheel(MouseEvent e) {}

    private void goToEasyMode(){
        background(240, 210, 200); /* for test */
        MapState mapState = new MapState(engineRef, passedPlayer);
        engineRef.changeState(mapState);
    }

    private void goToHardMode(){
        background(240, 210, 200); /* for test */
        String hardmode = "Yes";
        MapState mapState = new MapState(engineRef, passedPlayer,hardmode);
        engineRef.changeState(mapState);
    }

    private boolean checkFileExists(String filePath){
        File file = new File(sketchPath(filePath));
        System.out.println(new File("../assets/map/mapTemp.json").getAbsolutePath());
        return file.exists();
    }

}
