class Player extends Entity {
    private Deck cardDeck;
    private int currActionPts;
    private int energyLim;
    private int currEnergy;
    private int currGold;

    Player(String name, int maxHp, int str, int dex, int actionPts, int energyLim) {
        super(name, maxHp, str, dex);
        cardDeck = new Deck();
        currActionPts = actionPts;
        this.energyLim = energyLim;
        currEnergy = energyLim;
        currGold = 0;
    }

    public Deck getDeck() {
        return cardDeck;
    }

    public int getCurrEnergy() {
        return currEnergy;
    }

    public int getEnergyLim() {
        return energyLim;
    }

    public void setEnergyLim(int newLim) {
        energyLim = newLim;
        if (currEnergy > newLim) {
            currEnergy = newLim;
        }
    }

    public int getGoldOnHand() {
        return currGold;
    }

    public void incrementGold(int amt) {
        currGold += amt;
    }

    public void decrementGold(int amt) {
        currGold -= amt;
    }

    public void decrementEnergy(int amt) {
        currEnergy -= amt;
    }

    public void incrementEnergy(int amt) {
        currEnergy = Math.min(currEnergy+amt, energyLim);
    }

    public int getActionPts() {
        return currActionPts;
    }

    public void incrementActionPts(int amt) {
        currActionPts += amt;
    }

    public void decrementActionPts(int amt) {
        currActionPts -= amt;
    }

    public void die() {
        // Placeholder
    }
}