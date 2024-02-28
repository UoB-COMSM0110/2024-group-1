class CombatEncounter {
    private Player battlePlayer;
    private Deck drawDeck;
    private ArrayList<Enemy> currEnemies;
    private ArrayList<Card> cardHand;
    private ArrayList<Card> discardPile;
    private Card activeCard;
    private boolean isPlayerTurn;
    private int drawAmt;

    CombatEncounter(Player thePlayer, ArrayList<Enemy> enemies) {
        battlePlayer = thePlayer;
        currEnemies = enemies;
        activeCard = null;
        cardHand = new ArrayList<Card>();
        discardPile = new ArrayList<Card>();
        drawAmt = 5;
    }

    public void initEncounter() {
        drawDeck = battlePlayer.getDeck();
        drawDeck.shuffle();
        startTurn();
    }

    private void startTurn() {
        decayStatuses();
        battlePlayer.refillEnergy();
        for (Enemy nme : currEnemies) {
            nme.readyMoves();
        }
        isPlayerTurn = true;
        cardHand = drawDeck.drawNCards(drawAmt);
        if (cardHand.size() < drawAmt) {
            drawDeck.setDeck(discardPile);
            drawDeck.shuffle();
            discardPile.clear();
        }
    }

    private void endTurn() {
        isPlayerTurn = false;
        activeCard = null;

        for (int i=0; i < cardHand.size(); i++) {
            Card toDiscard = cardHand.get(i);
            cardHand.remove(i);
            discardPile.add(toDiscard);
        }

        For (Enemy nme : currEnemies) {
            nme.executeMoves();
        }
        startTurn();
    }

    private void decayStatuses() {
        for (int i=0; i < currEnemies.size(); i++) {
            currEnemies.get(i).prepDecrement();
        }
        battlePlayer.prepDecrement();
    }

    public void processInput() {
        
    }

    public void drawCombat() {
        
    }
}