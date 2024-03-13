package shop;

import cards.Card;
import cards.Deck;
import entities.Player;
import shop.exceptions.DeckFullException;
import shop.exceptions.ItemNotAvailable;
import shop.exceptions.NotEnoughGoldException;

public class Item {
    private final Card card;
    private final int cost; //might not need this if covered by card class? 
    private boolean available; //whether item is available

    Item(Card card, int cost, boolean available) {
        this.card = card; //initialising -> creating item object 
        this.cost = cost; //
        this.available = available;
    }

    public Card getCard() { //provide access to card cost and available
        return card;
    }
    
    
public int getCardShopCost() {
        return card.getShopCost();
    }

 //check this 

   
    /*public int getCost() {
        return cost;
    }
    */ don't need this ? 
    
     // Create an instance of Card
        card = new Card(3, 50);

        // Accessing energy cost and shop cost
        int energyCost = card.getEnergyCost();
        int shopCost = card.getShopCost();




    public boolean isAvailable() {
        return available;
    }

    public void setAvailable(boolean available) {
        this.available = available;
    }

    public Card buy(Player player) throws ItemNotAvailable, NotEnoughGoldException, DeckFullException {
        if (!available) { 
            throw new ItemNotAvailable(); //check if item available for purchase if not throws exception
        }
        

        if (player.getGoldOnHand() < cost) {
            throw new NotEnoughGoldException();
        }

        if (player.getDeck().isFull()) {
            throw new DeckFullException();
        }

        player.decrementGold(cost); //if passes decrement gold by item cost 

        return card; 
    }
    
    public String toCsv() {
      return  card.getPath() + ", " + card.getName() + ", " + card.getType().toString() + ", " +
              card.getEnergyCost() + ", " + card.getShopCost() + ", " + card.getTakesTarget() + ", " + available;
    } //csv item attributes to csv -> path etc 
    
    /*
          String path = row[0];
          String name = row[1];
          CardType cardType = CardType.factory(row[2]);
          int energyCost = Integer.parseInt(row[3]);
          int shopCost = Integer.parseInt(row[4]);
          boolean takesTarget = row[5].equals("true");
          boolean available = row[6].equals("true");
    */
    //void set up -> to see the visual 
}
