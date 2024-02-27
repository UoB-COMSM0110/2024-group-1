abstract class Card {
    private String name;
    private CardType cardType;
    private int energyCost;
    private int shopCost;
    private boolean takesTarget;

    Card(String name, CardType type, int energyCost, int shopCost, boolean needsTarget) {
        this.name = name;
        cardType = type;
        this.energyCost = energyCost;
        this.shopCost = shopCost;
        takesTarget = needsTarget;
    }

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
}