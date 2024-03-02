PImage backgroundImage;
PImage winImage;
PImage loseImage;
PImage Score;
PImage Menu;
PImage Cards;
PImage Shop;
PImage Continue;

int actionPoints = 10; // 初始行动点数
boolean checkWin = true; // 游戏结果：true 为赢，false 为输
int winBonus = 5; // 赢得游戏所得行动点数
boolean agreeToSacrificeLife = false; // 是否同意用行动点数换取生命
boolean gameContinue = true;
boolean pageChange = false;

void setup() {
  size(800, 635);
  
  // 加载背景图像
  backgroundImage = loadImage("Background.png");
  Score = loadImage("scoreUI.png");
  winImage = loadImage("imageWin.png");
  loseImage = loadImage("imageLose.png");
  Menu = loadImage("buttonMenu.png");
  Cards = loadImage("buttonCards.png");
  Shop = loadImage("buttonShop.png");
  Continue = loadImage("buttonContinue.png");
}

void draw() {
  // 将背景图像显示在画布上
  if (!pageChange) {
    background(backgroundImage); 
    textSize(48);
    textAlign(CENTER, CENTER);
    if (checkWin) {
      drawWin();
    } else {
      drawLose();
    }
  } else {
    background(255);
    //Add codes to change stage
  }
}

void drawWin() {
  image(winImage, 255, -30);
  image(Score, 115, 125); 
  fill(255, 255, 255);
  textAlign(LEFT, CENTER);
  text("\nAction Points: ", width/2-190, height/2-30);
  text("\nWin Bonus: ", width/2-190, height/2+20);
  text("\nTotal: ", width/2-190, height/2+70);
  textAlign(RIGHT, CENTER);
  text("\n"+actionPoints, width/2+205, height/2-30);
  text("\n"+winBonus, width/2+205, height/2+20);
  text("\n"+(winBonus+actionPoints), width/2+205, height/2+70);
  image(Menu, 40, height-175);
  image(Cards, 215, height-175);
  image(Shop, 400, height-175);
  image(Continue, 575, height-175);
}

void drawLose() {
  image(loseImage, 255, -30);
  fill(255, 0, 0); // 红色表示失败
  text("\nRemaining Action Points: " + actionPoints, width/2, height/2 -40);
  if (actionPoints < 5) {
    text("\nNot enough Action Points", width/2, height/2);
    text("\nGame End", width/2, height/2+40);
    gameContinue = false;
    //Add codes to go back to start stage
  } else {
    if (!agreeToSacrificeLife && (key == 'y' || key == 'Y')) {
      actionPoints -= 5; // 使用5个行动点数兑换生命
      agreeToSacrificeLife = true; // 设置生命已经被牺牲
    } else {
      if (!agreeToSacrificeLife) {
        text("\nAgree to sacrifice life? (Y/N)", width/2, height/2);
      }
    }
  }
  image(Menu, 40, height-175);
  image(Cards, 215, height-175);
  image(Shop, 400, height-175);
  image(Continue, 575, height-175);
  //Add codes to go back to game
}

void cleanScreen() {
  background(255);
}

void mousePressed() {
  if (gameContinue && mouseY > height-175 && mouseY < height-175+Shop.height) {
    if (mouseX > 40 && mouseX < 40+Shop.width) {
      pageChange = true;
      //Add codes to go to start stage
    } else if (mouseX > 215 && mouseX < 215+Shop.width) {
      pageChange = true;
      //Add codes to go to cards stage
    } else if (mouseX > 400 && mouseX < 400+Shop.width) {
      pageChange = true;
      //Add codes to go to shop stage
    } else if (mouseX > 575 && mouseX < 575+Shop.width) {
      pageChange = true;
      //Add codes to back to game
    }
  }
}
