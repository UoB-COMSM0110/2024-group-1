class EndState extends GameState {
  PImage backgroundImage, winImage, loseImage, Score, Menu, Cards, Shop, Continue, Setting;
  Button menuButton, cardsButton, shopButton, continueButton, settingButton;

  GameEngine engineRef;
  private Player passedPlayer;
  int actionPoints;
  int winBonus = 5; //suppose the player will get 5 points after winning
  int sacrificeFine = 5; //suppose the player will lose 8 points after lose
  int totalPoints;
  boolean checkWin;
  boolean agreeToSacrificeLife = false;
  boolean gameContinue = true;
  boolean pageChange = false;
  
  EndState(GameEngine engine, Player player, boolean check) {
    passedPlayer = player;
    engineRef = engine;
    actionPoints = player.getActionPts();
    checkWin = check;
    if (checkWin) {
      player.incrementActionPts(winBonus);
    }
    totalPoints = player.getActionPts();
    setupState();
  }

  public void setupState() {
    backgroundImage = loadImage("../assets/endscreen/Background.png");
    Score = loadImage("../assets/endscreen/scoreUI.png");
    winImage = loadImage("../assets/endscreen/imageWin.png");
    loseImage = loadImage("../assets/endscreen/imageLose.png");
    Menu = loadImage("../assets/endscreen/buttonMenu.png");
    Cards = loadImage("../assets/endscreen/buttonCards.png");
    Shop = loadImage("../assets/endscreen/buttonShop.png");
    Continue = loadImage("../assets/endscreen/buttonContinue.png");
    Setting = loadImage("../assets/endscreen/imageSetting.png");
    backgroundImage.resize(displayWidth, displayHeight-50);
    menuButton = new Button(0, height-400, Menu.width, Menu.height, Menu);
    cardsButton = new Button(width/2-600, height-400, Cards.width, Cards.height, Cards);
    shopButton = new Button(width/2+100, height-400, Shop.width, Shop.height, Shop);
    continueButton = new Button(width-500, height-400, Continue.width, Continue.height, Continue);
    settingButton = new Button(width-300, 0, Setting.width, Setting.height, Setting);
  }
  
  public void handleMouseInput() {
    if (menuButton.overButton() && mousePressed) {
      pageChange = true;
      //Add codes to go to start stage
      MenuState menuState = new MenuState(engineRef, passedPlayer);
      engineRef.changeState(menuState);
    }
    if (cardsButton.overButton() && mousePressed) {
      pageChange = true;
      //Add codes to go to cards stage
    }
    if (shopButton.overButton() && mousePressed) {
      pageChange = true;
      //Add codes to go to shop stage
    }
    if (continueButton.overButton() && mousePressed) {
      pageChange = true;
      MapState mapStateFake = new MapState(engineRef, passedPlayer);
      mapStateFake.updateNodeStatesOutside();
      mapStateFake.saveMapStateToFile("../assets/map/mapTemp.json");
      MapState mapStateTrue = new MapState(engineRef, passedPlayer);
      engineRef.changeState(mapStateTrue);
    }
    if (settingButton.overButton() && mousePressed) {
      pageChange = true;
      //Add codes to go to setting stage
    }
  }
  
  public void handleKeyInput() {
    if (keyPressed) {
      if (key == 'y' || key == 'Y') {
        //actionPoints -= 5;
        //Fix: Permanently decrease it and save it 
        passedPlayer.decrementActionPts(sacrificeFine);
        agreeToSacrificeLife = true;
      }
    }
  }
  
  public void drawState() {
    if (!pageChange) {
      background(backgroundImage);
      settingButton.drawButton();
      menuButton.drawButton();
      cardsButton.drawButton();
      shopButton.drawButton();
      continueButton.drawButton();
      textSize(64);
      textAlign(CENTER, CENTER);
      if (checkWin) {
        drawWin();
      } else {
        drawLose();
      }
    } else {
      cleanScreen();
      //Add codes to change stage
    }
  }
  
  void cleanScreen() {
    background(255);
  }
  
  void drawWin() {
    image(winImage, displayWidth/2-230, -50);
    image(Score, width/2-350, height/2-250); 
    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    text("\nAction Points: ", width/2-200, height/2-30);
    text("\nWin Bonus: ", width/2-200, height/2+20);
    text("\nTotal: ", width/2-200, height/2+70);
    textAlign(RIGHT, CENTER);
    text("\n"+passedPlayer.getActionPts(), width/2+240, height/2-30);
    text("\n"+winBonus, width/2+240, height/2+20);
    text("\n"+totalPoints, width/2+240, height/2+70);
  }

  void drawLose() {
    image(loseImage, displayWidth/2-230, -50);
    fill(255, 0, 0); // red means failure
    text("\nRemaining Action Points: " + passedPlayer.getActionPts(), width/2, height/2 -40);
    if ((passedPlayer.getActionPts() < sacrificeFine) || (passedPlayer.getActionPts() < 0)) {
      text("\nNot enough Action Points", width/2, height/2);
      text("\nGame End", width/2, height/2+40);
      gameContinue = false;
      //Add codes to go back to start stage
    } else {
      if (!agreeToSacrificeLife) {
        text("\nAgree to sacrifice life? (Y/N)", width/2, height/2);
        handleKeyInput();
      }
    }
    //Add codes to go back to game
  }
  
  private boolean checkFileExists(String filePath){
        File file = new File(sketchPath(filePath));
        System.out.println(new File("../assets/map/mapTemp.json").getAbsolutePath());
        return file.exists();
    }

  public void pauseState() {}
  public void resumeState() {}
  public void handleMouseWheel(MouseEvent e) {}
  public void updateState() {}
}
