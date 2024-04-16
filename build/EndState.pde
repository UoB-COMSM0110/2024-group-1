import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
class EndState extends GameState {
  PImage backgroundImage, winImage, loseImage, Score, Menu, Cards, Shop, Continue, Setting;
  Button menuButton, cardsButton, shopButton, continueButton, settingButton;

  GameEngine engineRef;
  private Player passedPlayer;
  int winBonus = 15; //suppose the player will get 5 points after winning
  int sacrificeFine = 5; //suppose the player will lose 5 points after lose
  int sacrificeHp = 10; //suppose the player will get 10 hp after losing 5 points
  int actionPoints;
  int totalPoints;
  String warningMessage = "Blocked! "; // Warning message content
  boolean checkWin;
  boolean agreeToSacrificeLife = true;
  boolean checkFinalWin;
  
  EndState(GameEngine engine, Player player, boolean check) {
    passedPlayer = player;
    engineRef = engine;
    checkWin = check;
    actionPoints = player.getActionPts();
    if (checkWin) {
      player.incrementActionPts(winBonus);
    } else {
      player.decrementActionPts(sacrificeFine);
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
      //Add codes to go to start stage
      MenuState menuState = new MenuState(engineRef, passedPlayer);
      engineRef.changeState(menuState);
    }
    if (cardsButton.overButton() && mousePressed) {
      if (checkWin || (!checkWin && totalPoints >= sacrificeFine)) {
        //Add codes to go to cards stage
      } else {
        displayWarningMessage();
      }
    }
    if (shopButton.overButton() && mousePressed) {
      if (checkWin || (!checkWin && totalPoints >= sacrificeFine)) {
        //Add codes to go to shop stage
      } else {
        displayWarningMessage();
      }
    }
    if (continueButton.overButton() && mousePressed) {
      if (checkWin || (!checkWin && (totalPoints >= sacrificeFine) && (passedPlayer.getCurrHp() > 0))) {
        MapState mapStateFake = new MapState(engineRef, passedPlayer);
        mapStateFake.updateNodeStatesOutside();
        mapStateFake.saveMapStateToFile("../assets/map/mapTemp.json");
        checkFinalWin = mapStateFake.checkFinalWin();
        if(checkFinalWin){
          System.out.println("WinWinWin!!!");
          String filePath = "../assets/map/mapTemp.json";
          try {
            Path path = Paths.get(sketchPath(filePath));
            Files.deleteIfExists(path);
            println("Delete successfully: " + filePath);
          } catch (IOException e) {
            println("Delete failed: " + e.getMessage());
            e.printStackTrace();
          }
          MenuState menuState = new MenuState(engineRef, passedPlayer);
          engineRef.changeState(menuState);
        }else{
          MapState mapStateTrue = new MapState(engineRef, passedPlayer);
          engineRef.changeState(mapStateTrue);
        }
      } else {
        MenuState menuState = new MenuState(engineRef, passedPlayer);
        engineRef.changeState(menuState);
      }
    }
    if (settingButton.overButton() && mousePressed) {
      //Add codes to go to setting stage
    }
  }
  
  public void handleKeyInput() {
    if (keyPressed && agreeToSacrificeLife) {
      if (key == 'y' || key == 'Y' || key == 'n' || key == 'N') {
        if (key == 'y' || key == 'Y') {
          //actionPoints -= 5;
          //Fix: Permanently decrease it and save it 
          passedPlayer.decrementActionPts(sacrificeFine);
          passedPlayer.incrementHp(sacrificeHp);
          totalPoints = passedPlayer.getActionPts();
        }
        agreeToSacrificeLife = false;
      }
    }
  }
  
  public void drawState() {
      cleanScreen();
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
  }
  
  void cleanScreen() {
    background(255);
  }
  
  void drawWin() {
    agreeToSacrificeLife = false;
    image(winImage, displayWidth/2-230, -50);
    image(Score, width/2-350, height/2-250); 
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
    text("\nRemaining Action Points: " + passedPlayer.getActionPts(), width/2, height/2 -60);
    text("\nRemaining HP: " + passedPlayer.getCurrHp(), width/2, height/2);
    if (totalPoints < sacrificeFine) {
      agreeToSacrificeLife = false;
      text("\nNot enough Action Points, Game End!!!", width/2, height/2+60);
      String filePath = "../assets/map/mapTemp.json";
      try {
      Path path = Paths.get(sketchPath(filePath));
      Files.deleteIfExists(path);
      println("Delete successfully: " + filePath);
      } catch (IOException e) {
        println("Delete failed: " + e.getMessage());
        e.printStackTrace();
      }
    } else {
      if (agreeToSacrificeLife) {
        text("\nAgree to sacrifice life? (Y/N)", width/2, height/2+60);
      }
    }
  }
  
  private boolean checkFileExists(String filePath){
        File file = new File(sketchPath(filePath));
        System.out.println(new File("../assets/map/mapTemp.json").getAbsolutePath());
        return file.exists();
    }
    
  private void displayWarningMessage() {
        // Original location
        int rectWidth = 300;
        int rectHeight = 100;
        int rectX = width / 2 - rectWidth / 2;
        int rectY = height / 2 - rectHeight / 2;

        // Change the location of warning message，right 600px, up 200px
        rectX += 600;
        rectY -= 200;

        // Draw yellow background
        fill(255, 255, 0);
        rect(rectX, rectY, rectWidth, rectHeight);

        // Draw warning content
        fill(0);
        textAlign(CENTER, CENTER);
        text(warningMessage, rectX + rectWidth / 2, rectY + rectHeight / 2);

        // Draw the closure option "X"
        text("x", rectX + rectWidth - 15, rectY + 15);
    }

  public void pauseState() {}
  public void resumeState() {}
  public void handleMouseWheel(MouseEvent e) {}
  public void updateState() {}
}