public class ShopState extends GameState {
  private PImage shopBackground;
  private PImage backImage;
  private Button backButton;

  //private static final String FILE_PATH = "shop.csv"; //file path of shop data file
  private final ArrayList<Card> items; //items available in the shop
  private final int gap, cardWidth, cardHeight, divX, divY;
  
  private final CardImgLoader imageLoader;
  
  GameEngine engineRef; 
  private Player passedPlayer;
    
  private boolean showAlert;
  private String alertMessage = "";
    
  public ShopState(GameEngine engine, Player thePlayer, ArrayList<Card> cards) {
      this.items = cards;
      
      imageLoader = new CardImgLoader();
      for (Card card : this.items) {
        card.setImg(imageLoader.getImg(card.getName()));
      }
        
      //add in game engine and player 
      engineRef = engine;
      passedPlayer = thePlayer;
      
      gap = 30;
      cardWidth = (width - (10 * gap)) / 5;
      cardHeight = (height - (80 + 6 * gap)) / 2;
      divX = (width / 2) - 5 * cardWidth / 2 - 2 * gap;
      divY = ((height - 80)/ 2) - cardHeight - gap;
      
      setupState();
      drawState();        
  }

  private ArrayList<Card> getItems() {
      return items; //access to items array list 
  }

  private boolean buyCard(int index) { //player purchase card from shop at specific index        
    if (index < 0 || index >= items.size()) {
      alertMessage = "Item not found";
      showAlert = true;
      return false;
    }
    
    Card item = items.get(index);
    
    if (passedPlayer.getGoldOnHand() < item.getShopCost()) {
      alertMessage = "Not enough gold";
      showAlert = true;
      return false;
    }

    if (passedPlayer.getDeck().isFull()) {
      alertMessage = "Player's deck is full";
      showAlert = true;
      return false;
    }

    passedPlayer.decrementGold(item.getShopCost()); //if passes decrement gold by item cost 

    items.remove(index); 

    //System.out.println(passedPlayer.getDeck().toString());
    return passedPlayer.getDeck().addCard(item);
  }
  
  public void setupState(){
    shopBackground = loadImage("../assets/shop/shop_bg.jpeg");
    backImage = loadImage("../assets/shop/backButton.png");
    
    backButton = new Button(50, height - 80, 230, 60, backImage);
  } 
  

  public void pauseState(){}
  public void resumeState(){}
  public void updateState(){}
  public void handleMouseWheel(MouseEvent e) {}
  
  public void drawState(){
    background(255);//Clear the screen to move lines
    image(shopBackground, 0, 0, width, height);
    image(backImage, 50, height - 80, 230, 60);  
    
    textSize(40);
    textAlign(CENTER);
    
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < Math.min(5, items.size() - (i * 5)); j++) {
        Card card = items.get(i * 5 + j);
        int posX = divX + (cardWidth + gap) * j;
        int posY = divY + (cardHeight + 2 * gap) * i;
        card.setPos(posX, posY);
        rect(posX, posY, cardWidth, cardHeight);
        image(card.getImg(), posX, posY, cardWidth, cardHeight);
        text(card.getShopCost() + "£", posX + cardWidth / 2, posY + cardHeight + 35);
      }
    }
    
    textSize(60);
    textAlign(RIGHT);
    text(passedPlayer.getGoldOnHand() + "£", width - 80, height - 40);
    
    if (showAlert) {
      rect(width / 2 - 250, height / 2 - 50, 500, 100);
      textSize(40);
      textAlign(CENTER);
      fill(#000000);
      text(alertMessage, width / 2, height / 2 + 5);
      fill(#FFFFFF);
    }
  } //editing the images 
  
  public void handleMouseInput() {  /* change game state to MAP_STATE */
    if (showAlert) {
      showAlert = false;
      return;
    }
    if (mousePressed && !showAlert) {
      // System.out.println("[DEBUG] Mouse clicked (" + mouseX + ", " + mouseY + ")");
      if (backButton.overButton()) {
        MapState mapState = new MapState(engineRef, passedPlayer);
        engineRef.changeState(mapState);
        return;
      }
      
      int index = mouseOverCard();
      if (index != -1) {
        if (buyCard(index)) {
          drawState();
        }/* else {
          System.out.println("[DEBUG] Couldn't buy card");
        }*/
      }
    }
  } //add in button for map state here //check 
  public void handleKeyInput(){}
  
  private int mouseOverCard() {
    for (int i = 0; i < items.size(); i++) {
      Card card = items.get(i);
      
      if (mouseX >= card.getPos().x &&
          mouseX <= card.getPos().x + cardWidth &&
          mouseY >= card.getPos().y &&
          mouseY <= card.getPos().y + cardHeight) {
        return i;
      }
    }
    
    return -1;
  }
}
