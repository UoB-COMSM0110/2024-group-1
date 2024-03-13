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
    backgroundImage = loadImage("Background.png");
    Score = loadImage("scoreUI.png");
    winImage = loadImage("imageWin.png");
    loseImage = loadImage("imageLose.png");
    Menu = loadImage("buttonMenu.png");
    Cards = loadImage("buttonCards.png");
    Shop = loadImage("buttonShop.png");
    Continue = loadImage("buttonContinue.png");
    Setting = loadImage("imageSetting.png");
    menuButton = new Button(40, height-175, Menu.width, Menu.height);
    cardsButton = new Button(215, height-175, Cards.width, Cards.height);
    shopButton = new Button(400, height-175, Shop.width, Shop.height);
    continueButton = new Button(575, height-175, Continue.width, Continue.height);
    settingButton = new Button(width-100, 0, Setting.width, Setting.height);
  }
  
  public void handleMouseInput() {
    menuButton.update();
    if (menuButton.overButton(40, height-175, Menu.width, Menu.height) && mousePressed) {
      pageChange = true;
      //Add codes to go to start stage
    }
    cardsButton.update();
    if (cardsButton.overButton(215, height-175, Cards.width, Cards.height) && mousePressed) {
      pageChange = true;
      //Add codes to go to cards stage
    }
    shopButton.update();
    if (shopButton.overButton(400, height-175, Shop.width, Shop.height) && mousePressed) {
      pageChange = true;
      //Add codes to go to shop stage
    }
    continueButton.update();
    if (continueButton.overButton(575, height-175, Continue.width, Continue.height) && mousePressed) {
      pageChange = true;
      //Add codes to back to game
    }
    settingButton.update();
    if (settingButton.overButton(width-100, 0, Setting.width, Setting.height) && mousePressed) {
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
      image(Setting, width-100, 0);
      image(Menu, 40, height-175);
      image(Cards, 215, height-175);
      image(Shop, 400, height-175);
      image(Continue, 575, height-175);
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
