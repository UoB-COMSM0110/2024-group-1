class MenuState extends GameState {
    PImage bg, startImage, combatImage, helpImage, shopImage, easyModeImage, hardModeImage, backImage, HelpContent;
    Button startButton, helpButton, easyButton, hardButton, backButton;

    GameEngine engineRef;
    private Player passedPlayer;
    private Boolean modeChoiceVisibility = false;
    boolean showHelp = false; // Show Help or not

    MenuState(GameEngine engine, Player thePlayer) {
        engineRef = engine;
        passedPlayer = thePlayer;
        setupState();
    }

    public void setupState() {
        
        passedPlayer = new Player("Initial", 40, 5, 5, 5, 6, 20); //Initialize the player
        

        bg = loadImage("../assets/main/menu_bg.jpeg");
        startImage = loadImage("../assets/main/start.png");
        helpImage = loadImage("../assets/main/help.png");
        easyModeImage = loadImage("../assets/main/easy.png");
        hardModeImage = loadImage("../assets/main/hard.png");
        backImage = loadImage("../assets/map/backButton.png");
        HelpContent = loadImage("../assets/main/HelpContent.png");
        HelpContent.resize(750,750);
  
        startButton = new Button(250, 400, 230, 60, startImage);
        helpButton = new Button(250, 500, 230, 60, helpImage);
        easyButton = new Button(850,400,230,60,easyModeImage);
        hardButton = new Button(850,500,230,60,hardModeImage);
        backButton = new Button(600,300,230,60,backImage);
    }

    public void handleMouseInput() {
        
        /* change game state to MAP_STATE */
        if (startButton.overButton() && mousePressed){
            if(checkFileExists("../assets/map/mapTemp.json")){
                System.out.println("Loading from last game");
                goToEasyMode();
            }else{
                modeChoiceVisibility = !modeChoiceVisibility; 
                System.out.println("Start a new game with mode choice option");
            }
            //background(240, 210, 200); /* for test */
            //MapState mapState = new MapState(engineRef, passedPlayer);
            //engineRef.changeState(mapState);
        }

        if (backButton.overButton() && mousePressed){
            modeChoiceVisibility = !modeChoiceVisibility; 
        }

        if (easyButton.overButton() && mousePressed){
            goToEasyMode();
        }else if(hardButton.overButton() && mousePressed){
            goToHardMode();
        }
  
        /* change to tutorial interface */
        if (helpButton.overButton() && mousePressed){
            System.out.println("Help button is clicked");
            showHelp = !showHelp;
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
            helpButton.drawButton();
        }
        
        displayHelpImage();
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
    
    private void displayHelpImage() {
        if (showHelp) {
            System.out.println("The showing state of Help is changed");
            image(HelpContent, 500,30);
        }
    }

}
