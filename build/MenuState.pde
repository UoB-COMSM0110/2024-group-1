class MenuState extends GameState {
    PImage bg, startImage, combatImage, helpImage, shopImage, easyModeImage, hardModeImage, backImage, HelpContent, loadIcon, loadIconGrey;
    Button startButton, helpButton, easyButton, hardButton, backButton, loadButton, loadGreyButton;

    GameEngine engineRef;
    private Player passedPlayer;
    private Boolean modeChoiceVisibility = false;
    boolean showHelp = false; // Show Help or not
    boolean loadModeAvailable = false;

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
        loadIcon = loadImage("../assets/main/load.png");
        loadIconGrey = loadImage("../assets/main/loadGrey.png");
        easyModeImage = loadImage("../assets/main/easy.png");
        hardModeImage = loadImage("../assets/main/hard.png");
        backImage = loadImage("../assets/map/backButton.png");
        HelpContent = loadImage("../assets/main/HelpContent.png");
        HelpContent.resize(750,750);
  
        startButton = new Button(250, 400, 230, 60, startImage);
        helpButton = new Button(250, 600, 230, 60, helpImage);
        easyButton = new Button(850,400,230,60,easyModeImage);
        hardButton = new Button(850,500,230,60,hardModeImage);
        backButton = new Button(600,300,230,60,backImage);
        loadButton = new Button(250,500,230,60, loadIcon); 
        loadGreyButton = new Button(250,500,230,60, loadIconGrey);

        if(checkFileExists("../assets/map/mapTemp.json")){
            loadModeAvailable = true; 
            System.out.println("Loading mode available");
        }else{
            loadModeAvailable = false;
            System.out.println("Loading mode not available");
        }
    }

    public void handleMouseInput() {
        
        /* change game state to MAP_STATE */
        if (startButton.overButton() && mousePressed){
            modeChoiceVisibility = !modeChoiceVisibility; 
        }

        if (backButton.overButton() && mousePressed){
            modeChoiceVisibility = !modeChoiceVisibility; 
        }

        if (easyButton.overButton() && mousePressed){
            deleteMapOld();
            goToEasyMode();
        }else if(hardButton.overButton() && mousePressed){
            deleteMapOld();
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
        
        if(checkFileExists("../assets/map/mapTemp.json")){
            loadModeAvailable = true; 
        }else{
            loadModeAvailable = false;
        }

        if(modeChoiceVisibility){
            easyButton.drawButton();
            hardButton.drawButton();
            backButton.drawButton();
        }else{
            startButton.drawButton();    /* the same position as Button */
            if(loadModeAvailable){
                loadButton.drawButton();
            }else{
                loadGreyButton.drawButton();
            }
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

    private void deleteMapOld(){
        String filePath = "../assets/map/mapTemp.json";
            try {
                Path path = Paths.get(sketchPath(filePath));
                Files.deleteIfExists(path);
                println("Delete successfully: " + filePath);
            } catch (IOException e) {
                println("Delete failed: " + e.getMessage());
                e.printStackTrace();
            }
    }
}
