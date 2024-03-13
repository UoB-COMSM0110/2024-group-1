abstract class Card {
  private String path; //equal to the path of the image ??
    private String name;
    private CardType cardType;
    private int energyCost;
    private int shopCost;
    private boolean takesTarget;

    Card(String path, String name, CardType type, int energyCost, int shopCost, boolean needsTarget) {
      this.path = path; //path pointing to image ?? 
        this.name = name;
        cardType = type;
        this.energyCost = energyCost;
        this.shopCost = shopCost; //already in item don't need this?? 
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
    
    public boolean getTakesTarget() {
      return takesTarget;
    }
}
