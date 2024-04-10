class EndState extends GameState {
  PImage backgroundImage, winImage, loseImage, Score, Menu, Cards, Shop, Continue, Setting;
  Button menuButton, cardsButton, shopButton, continueButton, settingButton;

  int actionPoints;
  int winBonus = 5; //suppose the player will get 5 points after winning
  int totalPoints;
  boolean checkWin;
  boolean agreeToSacrificeLife = false;
  boolean gameContinue = true;
  boolean pageChange = false;
  
  EndState(Player player, boolean check) {
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
      //Add codes to back to game
    }
    if (settingButton.overButton() && mousePressed) {
      pageChange = true;
      //Add codes to go to setting stage
    }
  }
  
  public void handleKeyInput() {
    if (keyPressed) {
      if (key == 'y' || key == 'Y') {
        actionPoints -= 5;
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
      textSize(48);
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
    image(winImage, 245, -30);
    image(Score, 105, 125); 
    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    text("\nAction Points: ", width/2-190, height/2-30);
    text("\nWin Bonus: ", width/2-190, height/2+20);
    text("\nTotal: ", width/2-190, height/2+70);
    textAlign(RIGHT, CENTER);
    text("\n"+actionPoints, width/2+205, height/2-30);
    text("\n"+winBonus, width/2+205, height/2+20);
    text("\n"+totalPoints, width/2+205, height/2+70);
  }

  void drawLose() {
    image(loseImage, 245, -30);
    fill(255, 0, 0); // red means failure
    text("\nRemaining Action Points: " + actionPoints, width/2, height/2 -40);
    if (actionPoints < 5) {
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

  public void pauseState() {}
  public void resumeState() {}
  public void handleMouseWheel(MouseEvent e) {}
  public void updateState() {}
}
