abstract class Card {
    private String name;
    private CardType cardType;
    private int energyCost;

    Card(String name, CardType type, int cost) {
        this.name = name;
        cardType = type;
        energyCost = cost;
    }

    public int getCost() {
        return energyCost;
    }

    public int setCost(int cost) {
        energyCost += cost;
    }

    public String getName() {
        return name;
    }

    public CardType getType() {
        return cardType;
    }
}