


//array of cards
//could do multiple shops -> don't want to have the same cards each time
//pass the player into the shop 
//poison card 
//don't need to worry about cost -> card class will handle it 
//get price from card 





public class Shop extends GameState {
  private PImage shopBackground;
  private PImage backImage;
  private Button backButton;

  //private static final String FILE_PATH = "shop.csv"; //file path of shop data file
  private final ArrayList<Card> items; //items available in the shop
  private final int gap, cardWidth, cardHeight, divX, divY;
    
  GameEngine engineRef; //passing in game engine and player? 
  private Player passedPlayer;
    
  private boolean showAlert;
  private String alertMessage = "";
    
    Shop(GameEngine engine, Player thePlayer, ArrayList<Card> cards) { //check this 
        this.items = cards;
         
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

/*
    private void readFile() throws IOException { //read item data from csv + fills arraylist 
        File file = new File(FILE_PATH); //create file object 
        Scanner scanner = new Scanner(file); //read from file
        String[] row; //shop values from csv 
        
        while (scanner.hasNext()) { // check if another line available -> read from file 
          row = scanner.nextLine().split(", "); //split into strings -separate values
          //file
          String path = row[0]; //first value from row and assign to path 
          String name = row[1]; //second value from array -> name of card etc
          CardType cardType = CardType.factory(row[2]); 
          int energyCost = Integer.parseInt(row[3]);
          int shopCost = Integer.parseInt(row[4]);
          boolean takesTarget = row[5].equals("true");
          boolean available = row[6].equals("true");
          
          Card card = new Card(path, name, cardType, energyCost, shopCost, needsTarget);
          items.add(new Item(card, shopCost, available)); //add new item to items list 
        }
        
        //in map could have url -> for file 
        //in map -> initialise shop node -> list of items -> display the itesm
        
        
        scanner.close();
    }
    
    public void writeFile() throws IOException { //writes item data to csv file 
        File file = new File(FILE_PATH);
        FileWriter writer = new FileWriter(file);
        
        for (Item item : items) { //iterate over each item in items list  and converts item data to csv string
            writer.write(item.toCsv() + "\n");
        }
        
        writer.close();
    }
*/
    private boolean buyCard(int index) { //player purchase card from shop at specific index
        try {
            Card item;
            
            try {
                item = items.get(index);
            } catch (IndexOutOfBoundsException e) {
                throw new IndexOutOfBoundsException("Item not found");
            }

            item.buy(passedPlayer); //item available -> buy

            items.remove(index); 

            //System.out.println(passedPlayer.getDeck().toString());
            return passedPlayer.getDeck().addCard(item);
        } catch (DeckFullException | NotEnoughGoldException | IndexOutOfBoundsException e) {
          alertMessage = e.getMessage();
          showAlert = true;
          
          return false;
        }
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

  /*
  public void mouseClicked() {
      System.out.println("[DEBUG] Mouse clicked");
      if (backButton.overButton()) {
        background(240, 210, 200);
        MapState mapState = new MapState(engineRef, passedPlayer);
        engineRef.changeState(mapState);
      }
      
      for (int i = 0; i < items.size(); i++) {
        if (items.get(i).isMousedOver()) {
          if (buyCard(i)) {
            drawState();
          }
        }
      }
    }
    */
  
  public void handleMouseInput() {  /* change game state to MAP_STATE */
    if (showAlert) {
      showAlert = false;
      return;
    }
    if (mousePressed && !showAlert) {
      System.out.println("[DEBUG] Mouse clicked (" + mouseX + ", " + mouseY + ")");
      if (backButton.overButton()) {
        MapState mapState = new MapState(engineRef, passedPlayer);
        engineRef.changeState(mapState);
        return;
      }
      
      int index = mouseOverCard();
      if (index != -1) {
        if (buyCard(index)) {
          drawState();
        } else {
          System.out.println("[DEBUG] Couldn't buy card");
        }
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
