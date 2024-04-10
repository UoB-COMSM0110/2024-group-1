class EndState extends GameState {
  PImage backgroundImage, winImage, loseImage, score, menu, cards, shop, continue, setting;
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
    scoreUIcore = loadImage("../assets/endscreen/scoreUI.png");
    winImage = loadImage("../assets/endscreen/imageWin.png");
    loseImage = loadImage("../assets/endscreen/imageLose.png");
    menu = loadImage("../assets/endscreen/buttonMenu.png");
    cards = loadImage("../assets/endscreen/buttonCards.png");
    shop = loadImage("../assets/endscreen/buttonShop.png");
    continue = loadImage("../assets/endscreen/buttonContinue.png");
    setting = loadImage("../assets/endscreen/imageSetting.png");
    backgroundImage.resize(displayWidth, displayHeight-50);
    menuButton = new Button(0, height-400, menu.width, menu.height, menu);
    cardsButton = new Button(width/2-600, height-400, cards.width, cards.height, cards);
    shopButton = new Button(width/2+100, height-400, shop.width, shop.height, shop);
    continueButton = new Button(width-500, height-400, continue.width, continue.height, continue);
    settingButton = new Button(width-300, 0, setting.width, setting.height, setting);
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
    image(score, width/2-350, height/2-250); 
    fill(255, 255, 255);
    textAlign(LEFT, CENTER);
    text("\nAction Points: ", width/2-200, height/2-30);
    text("\nWin Bonus: ", width/2-200, height/2+20);
    text("\nTotal: ", width/2-200, height/2+70);
    textAlign(RIGHT, CENTER);
    text("\n"+actionPoints, width/2+240, height/2-30);
    text("\n"+winBonus, width/2+240, height/2+20);
    text("\n"+totalPoints, width/2+240, height/2+70);
  }

  void drawLose() {
    image(loseImage, displayWidth/2-230, -50);
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
