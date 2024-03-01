PImage bg, startImage, combatImage, helpImage, shopImage;
int screenWidth = 1300, screenHeight = 800;

Button startButton, combatButton, helpButton, shopButton;


public void setup(){
  size(1300, 800);
  bg = loadImage("menu_bg.jpeg");
  startImage = loadImage("start.png");
  combatImage = loadImage("combat.png");
  helpImage = loadImage("help.png");
  shopImage = loadImage("shop.png");
  
  startButton = new Button(470, 240, 500, 400);
  combatButton = new Button(470, 320, 500, 400);
  helpButton = new Button(470, 400, 500, 400);
  shopButton = new Button(600, 550, 600, 600);
}

public void draw(){
  image(bg, 0, 0, screenWidth, screenHeight);
  image(startImage, 600, 300, 230, 60);  /* the same position as Button */
  image(combatImage, 600, 400, 230, 60);
  image(helpImage, 600, 500, 230, 60);
  image(shopImage, 900, 600, 100, 100);
  
  startButton.update();
  if (startButton.overButton(600, 300, 230, 60) && mousePressed){
    /* change game state to MAP_STATE */
    background(240, 210, 200); /* for test */
    
  }
  combatButton.update();
  if (combatButton.overButton(600, 400, 230, 60) && mousePressed){
    /* change game state to COMBAT_STATE */
    background(300, 300, 200);
  }
  
  helpButton.update();
  if (helpButton.overButton(600, 500, 230, 60) && mousePressed){
    /* change to tutorial interface */
    background(100, 100, 200);
  }
  
  shopButton.update();
  if (shopButton.overButton(900, 600, 100, 100) && mousePressed){
    /* change to shop interface */
    background(200, 300, 250);
  }
  
}
