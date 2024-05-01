import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
class EndState extends GameState {
  PImage backgroundImage, winImage, loseImage, finalImage, Continue;
  Button menuButton, cardsButton, shopButton, continueButton, settingButton;

  GameEngine engineRef;
  private Player passedPlayer;
  int winBonus = 2; //suppose the player will get 5 points after winning
  int sacrificeFine = 1; //suppose the player will lose 5 points after lose
  int sacrificeHp = 40; //suppose the player will get 10 hp after losing 5 points
  int actionPoints;
  int totalPoints;
  int bossCurrHP;
  int buttonWidth;
  int buttonHeight;
  String warningMessage = "Blocked! "; // Warning message content
  boolean checkWin;
  boolean agreeToSacrificeLife = true;
  boolean checkFinalWin;
  boolean clickable = true;
  MusicLoader BGMplayer = new MusicLoader();
  
  EndState(GameEngine engine, Player player, boolean check) {
    System.out.println("I am called.I am end");
    passedPlayer = player;
    engineRef = engine;
    checkWin = check;
    actionPoints = player.getActionPts();
    if (checkWin) {
      player.incrementActionPts(winBonus);
    } else {
    }
    totalPoints = player.getActionPts();
    MapState mapStateFake = new MapState(engineRef, passedPlayer);
    mapStateFake.updateNodeStatesOutside();
    mapStateFake.saveMapStateToFile("../assets/map/mapTemp.json");
    checkFinalWin = mapStateFake.checkFinalWin();
    setupState();
    if (checkWin && (!checkFinalWin)) {
      String gameWinBgmPath = sketchPath("../assets/music/StagedWin.wav");
      BGMplayer.musicLoad(gameWinBgmPath);
      BGMplayer.musicPlay();
    } else if(checkFinalWin && checkWin){
      String finalWinBGMPath = sketchPath("../assets/music/FinalWin.wav");
      BGMplayer.musicLoad(finalWinBGMPath);
      BGMplayer.musicPlay();
    }else {
      String gameOverBgmPath = sketchPath("../assets/music/GameOver.wav");
      BGMplayer.musicLoad(gameOverBgmPath);
      BGMplayer.musicPlay();
    }
  }

  EndState(GameEngine engine, Player player, boolean check, int bossHP) {
    System.out.println("I am called.I am end");
    passedPlayer = player;
    engineRef = engine;
    checkWin = check;
    bossCurrHP = bossHP;
    actionPoints = player.getActionPts();
    if (checkWin) {
      player.incrementActionPts(winBonus);
    } else {
    }
    totalPoints = player.getActionPts();
    MapState mapStateFake = new MapState(engineRef, passedPlayer);
    mapStateFake.updateNodeStatesOutside();
    mapStateFake.saveMapStateToFile("../assets/map/mapTemp.json");
    checkFinalWin = mapStateFake.checkFinalWin();
    setupState();
    if (checkWin && (!checkFinalWin)) {
      String gameWinBgmPath = sketchPath("../assets/music/StagedWin.wav");
      BGMplayer.musicLoad(gameWinBgmPath);
      BGMplayer.musicPlay();
    } else if(checkFinalWin && checkWin){
      String finalWinBGMPath = sketchPath("../assets/music/FinalWin.wav");
      BGMplayer.musicLoad(finalWinBGMPath);
      BGMplayer.musicPlay();
    }else {
      String gameOverBgmPath = sketchPath("../assets/music/GameOver.wav");
      BGMplayer.musicLoad(gameOverBgmPath);
      BGMplayer.musicPlay();
    }
  }

  public void setupState() {
    backgroundImage = loadImage("../assets/endscreen/Background.png");
    winImage = loadImage("../assets/endscreen/imageWin.png");
    loseImage = loadImage("../assets/endscreen/imageLose.png");
    finalImage = loadImage("../assets/endscreen/finalWin.png");
    Continue = loadImage("../assets/endscreen/buttonContinue.png");
    backgroundImage.resize(displayWidth, displayHeight-50);
    finalImage.resize(displayWidth, displayHeight-50);
    winImage.resize(displayWidth/5, displayHeight/4);
    loseImage.resize(displayWidth/5, displayHeight/4);
    buttonWidth = displayWidth/5;
    buttonHeight = buttonWidth * Continue.height / Continue.width;
    Continue.resize(buttonWidth, buttonHeight);
    continueButton = new Button(width/2-buttonWidth/2, height-2*buttonHeight, Continue.width, Continue.height, Continue);
  }
  
  public void handleMouseInput() {
    if (continueButton.overButton() && mousePressed && clickable) {
      BGMplayer.musicStop();
      if (checkWin || (!checkWin && (totalPoints >= sacrificeFine) && (passedPlayer.getCurrHp() > 0))) {
        MapState mapStateFake = new MapState(engineRef, passedPlayer);
        mapStateFake.updateNodeStatesOutside();
        mapStateFake.saveMapStateToFile("../assets/map/mapTemp.json");
        checkFinalWin = mapStateFake.checkFinalWin();
        if(checkFinalWin&&checkWin){
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
        }else if(checkFinalWin && (!checkWin) && (totalPoints >= 0)){
          MapState bossState = new MapState(engineRef, passedPlayer,bossCurrHP);
          bossState.fightBossAgain();
          bossState.saveMapStateToFile("../assets/map/mapTemp.json");
          engineRef.changeState(bossState);
        }else{
          MapState mapStateTrue = new MapState(engineRef, passedPlayer);
          engineRef.changeState(mapStateTrue);
        }
      } else {
        MenuState menuState = new MenuState(engineRef, passedPlayer);
        engineRef.changeState(menuState);
      }
    }
  }
  
  public void handleKeyInput() {
    if (keyPressed && agreeToSacrificeLife) {
      if (key == 'y' || key == 'Y' || key == 'n' || key == 'N') {
        if (key == 'y' || key == 'Y') {
          //actionPoints -= 5;
          //Fix: Permanently decrease it and save it 
          clickable = true;
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
      textSize(128);
      textAlign(CENTER, CENTER);
      if (checkFinalWin && checkWin) {
        background(finalImage);
        continueButton.drawButton();
        fill(0, 255, 0);
        drawFinalWin();
      } else {
        background(backgroundImage);
        continueButton.drawButton();
        if (checkWin) {
          fill(0, 255, 0);
          drawWin();
        } else {
          fill(255, 0, 0);
          drawLose();
        }
      }
  }
  
  void cleanScreen() {
    background(255);
  }
  
  void drawWin() {
    agreeToSacrificeLife = false;
    image(winImage, displayWidth/2-winImage.width/2, 0);
    text("\nYou Win!!!", displayWidth/2, winImage.height);
    textAlign(CENTER, CENTER);
    textSize(64);
    text("Action Points: "+actionPoints, displayWidth/2, displayHeight/2-50);
    text("\nWin Bonus: "+winBonus, displayWidth/2, displayHeight/2+25);
    text("\n\nTotal: "+totalPoints, displayWidth/2, displayHeight/2+100);
  }

  void drawLose() {
    image(loseImage, displayWidth/2-loseImage.width/2, 0);
    text("\nYou Lose!!!", width/2, loseImage.height);
    textSize(64);
    text("Remaining Action Points: " + passedPlayer.getActionPts(), width/2, height/2 -50);
    text("\nRemaining HP: " + passedPlayer.getCurrHp(), width/2, height/2+25);
    if (totalPoints < sacrificeFine) {
      agreeToSacrificeLife = false;
      text("\n\nNot enough Action Points, Game End!!!", width/2, height/2+100);
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
        text("\n\nAgree to sacrifice life? (Y/N)", width/2, height/2+100);
        clickable = false;
      }
    }
  }
  
  public void drawFinalWin() {
    agreeToSacrificeLife = false;
    text("\nCongratulations!!!", width/2, winImage.height-50);
    text("\nYou got "+totalPoints+" points in total!!!", width/2, height/2+25);
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
