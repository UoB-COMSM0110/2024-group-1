


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
    
    
  GameEngine engineRef; //passing in game engine and player? 
  private Player passedPlayer;
    
    
    Shop(GameEngine engine, Player thePlayer, ArrayList<Card> cards) { //check this 
        this.items = cards;
         
        //add in game engine and player 
        engineRef = engine;
        passedPlayer = thePlayer;
       
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
    private Card buyCard(Player player, int index) { //player purchase card from shop at specific index
        try {
            Card item;

            try {
                item = items.get(index);
            } catch (IndexOutOfBoundsException e) {
                throw new IndexOutOfBoundsException("Item not found");
            }

            item.buy(player); //item available -> buy

            items.remove(index); 

            return item;
        } catch (DeckFullException | NotEnoughGoldException | IndexOutOfBoundsException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }
   
  public void setupState(){
    shopBackground = loadImage("../assets/shop/shop_bg.jpeg");
    backImage = loadImage("../assets/shop/backButton.png");
    
    backButton = new Button(215, 720, 230, 60, backImage);
//    prevButton = new Button(320, 720, 230, 60, prevImage);
//    nextButton = new Button(880, 720, 230, 60, nextImage);
//    purchaseButton = new Button(600, 720, 230, 60, purchaseImage);

  } //loading in the images 
  

  public void pauseState(){}
  public void resumeState(){}
  public void updateState(){}
  public void handleMouseWheel(MouseEvent e) {}
  
  public void drawState(){
    image(shopBackground, 0, 0, width, height);
    image(backImage, 50, height - 80, 230, 60);  
    
    int gap = 30;
    int cardWidth = (width - (10 * gap)) / 5;
    int cardHeight = (height - (80 + 3 * gap)) / 2;
    int x = (width / 2) - 5 * cardWidth / 2 - 2 * gap;
    int y = ((height - 80)/ 2) - cardHeight - (gap / 2);
    
    textSize(40);
    textAlign(CENTER);
    
    for (int i = 0; i < 2; i++) {
      for (int j = 0; j < Math.min(5, items.size() - (i * 5)); j++) {
        Card card = items.get(i * 5 + j);
        int posX = x + (cardWidth + gap) * j;
        int posY = y + (cardHeight + gap) * i;
        image(card.getImg(), posX, posY, cardWidth, cardHeight);
        text(card.getShopCost() + "£", posX + cardWidth / 2, posY + cardHeight + gap / 5);
      }
    }
    
    textSize(60);
    textAlign(RIGHT);
     text(passedPlayer.getGoldInHand() + "£", width - 50, height - 80);
  } //editing the images 
  
  
  public void handleMouseInput() {  /* change game state to MAP_STATE */
    if (backButton.overButton() && mousePressed) {
      background(240, 210, 200); /* for test */
      MapState mapState = new MapState(engineRef, passedPlayer);
      engineRef.changeState(mapState);
    }
  } //add in button for map state here //check 
  public void handleKeyInput(){}
}
