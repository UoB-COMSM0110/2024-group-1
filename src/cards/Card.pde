abstract class Card {
    private String name;
    private CardType cardType;
    private int energyCost;
    private int shopCost;
    private boolean takesTarget;
    private boolean isAoE;
    private PImage img;
    private PVector pos;

    Card(String name, CardType type, int energyCost, int shopCost, boolean needsTarget, boolean isAoE) {
        this.name = name;
        cardType = type;
        this.energyCost = energyCost;
        this.shopCost = shopCost;
        takesTarget = needsTarget;
        this.isAoE = isAoE;
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

    public boolean getIfIsAoE() {
        return isAoE;
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

    public boolean isMousedOver() {
        return mouseX >= pos.x && mouseX <= (pos.x+img.width) && mouseY >= pos.y && mouseY <= (pos.y+img.height); 
    }
}