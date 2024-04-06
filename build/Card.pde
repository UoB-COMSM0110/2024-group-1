abstract class Card {
    private String name;
    private CardType cardType;
    private int energyCost;
    private int shopCost;
    private boolean takesTarget;
    private PImage img;
    private PVector pos;

    Card(String name, CardType type, int energyCost, int shopCost, boolean needsTarget) {
        this.name = name;
        cardType = type;
        this.energyCost = energyCost;
        this.shopCost = shopCost;
        takesTarget = needsTarget;
        CardImgLoader cIL = new CardImgLoader();
        this.img = cIL.getImg(name);
    }

    abstract public void applyCard(Entity target);

    public int getEnergyCost() {
        return energyCost;
    }

    public void increaseEnergyCost(int energyAmt) {
        energyCost += energyAmt;
    }

    public void decreaseEnergyCost(int energyAmt) {
        // Minimum card energy cost of 1
        energyCost = Math.max(1, energyCost-energyAmt);
    } 

    public int getShopCost() {
        return shopCost;
    }

    public void increaseShopCost(int amt) {
        shopCost += amt;
    }

    public void decreaseShopCost(int amt) {
        // Minimum shop cost of 20
        shopCost = Math.max(20, shopCost-amt);
    }

    public String getName() {
        return name;
    }

    public CardType getType() {
        return cardType;
    }

    public boolean getIfTakesTarget() {
        return takesTarget;
    }

    public void setPos(int x, int y) {
        pos = new PVector(x, y);
    }

    public PVector getPos() {
        return pos;
    }

    public PImage getImg() {
        return img;
    }

    public boolean setImg(PImage toSet) {
        if (toSet == null) {
            return false;
        }

        img = toSet;
        return true;
    }
    
    
    public void buy(Player player) throws NotEnoughGoldException, DeckFullException {
        if (player.getGoldOnHand() < shopCost) {
            throw new NotEnoughGoldException();
        }

        if (player.getDeck().isFull()) {
            throw new DeckFullException();
        }

        player.decrementGold(shopCost); //if passes decrement gold by item cost 
    }

    public boolean isMousedOver() {
      return mouseX >= pos.x && mouseX <= (pos.x + img.width) && mouseY >= pos.y && mouseY <= (pos.y + img.height); 
    }
}
