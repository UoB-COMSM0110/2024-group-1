class CombatEncounter {
    private Player battlePlayer;
    private Deck drawDeck;
    private ArrayList<Enemy> currEnemies;
    private ArrayList<Card> cardHand;
    private ArrayList<Card> discardPile;
    private Card activeCard;
    private boolean isPlayerTurn;

    CombatEncounter(Player thePlayer, ArrayList<Enemy> enemies) {
        battlePlayer = thePlayer;
        currEnemies = enemies;
        activeCard = null;
        cardHand = new ArrayList<Card>();
        discardPile = new ArrayList<Card>();
    }

    public void initEncounter() {
        drawDeck = battlePlayer.getDeck();
        drawDeck.shuffle();
        isPlayerTurn = true;
        startTurn();
    }

    private void startTurn() {

    }

    public void processInput() {
        
    }

    public void drawCombat() {
        
    }
}