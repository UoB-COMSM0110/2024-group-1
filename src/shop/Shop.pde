package shop;


//array of cards
//could do multiple shops -> don't want to have the same cards each time
//pass the player into the shop 
//poison card 
//don't need to worry about cost -> card class will handle it 
//get price from card 


/*
import cards.Card;
import entities.Player;
import shop.exceptions.DeckFullException;
import shop.exceptions.ItemNotAvailable;
import shop.exceptions.NotEnoughGoldException;
*/
import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;
//might not need import statements whilst having build folder 

public class Shop extends GameState {
  PImage shopBackground,startImage;
  Button startButton;

    private static final String FILE_PATH = "shop.csv"; //file path of shop data filel
    private final ArrayList<Item> items; //items available in the shop
    
    
      GameEngine engineRef; //passing in game engine and player? 
    private Player passedPlayer;
    
    
    Shop(GameEngine engine, Player thePlayer) { //check this 
        this.items = new ArrayList<>(); //initialise items 
        readFile(); //read item data from csv 
        //add in game engine and player 
        engineRef = engine;
        passedPlayer = thePlayer;
        //pass in set up state? 
        
    }

    private ArrayList<Item> getItems() {
        return items; //access to items array list 
    }

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

    private Card buyCard(Player player, int index) { //player purchase card from shop at specific index
        try {
            Item item;

            try {
                item = items.get(index);
            } catch (IndexOutOfBoundsException e) {
                throw new IndexOutOfBoundsException("Item not found");
            }

            Card card = item.buy(player); //item available -> buy

            items.remove(index);

            return card;
        } catch (DeckFullException | ItemNotAvailable | NotEnoughGoldException | IndexOutOfBoundsException e) {
            System.out.println(e.getMessage());
            return null;
        }
    }
   
  public void setupState(){
  shopBackground = loadImage("../assets/main/shopBackground.png");
  startImage = loadImage("../assets/main/start.png");

  startButton = new Button(600, 300, 230, 60);

   } //loading in the images 
  

public void pauseState(){}
  public void resumeState(){}
  public void updateState(){}
  public void handleMouseWheel(MouseEvent e) {}
  
  public void drawState(){
  image(startImage, 600, 300, 230, 60);  
  image(shopBackground, 0, 0, width, height); 
  } //editing the images 
  
  
  public void handleMouseInput(){  /* change game state to MAP_STATE */
        startButton.update();
        if (startButton.overButton(600, 300, 230, 60) && mousePressed){
            background(240, 210, 200); /* for test */
            //MapState mapState = new MapState();
            //GameState.changeState(engineRef, mapState);
        }
} //add in button for map state here //check 
  public void handleKeyInput(){}
}
