class CombatEncounter {
    private Player battlePlayer;
    private Deck drawDeck;
    private ArrayList<Enemy> currEnemies;
    private ArrayList<Card> cardHand;
    private ArrayList<Card> discardPile;
    private Card activeCard;
    private boolean isPlayerTurn;
    private int drawAmt;
    private final int ENEMY_BASE_X = 200;
    private final int CARDS_BASE_X = 50;

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

    public void processMouseInput() {
        if (mousePressed == true) {
            if (activeCard != null) {
            // TODO: cycle through enemies to see which to target
            }

            for (int i=0; i < cardHand.size(); i++) {
                if (cardHand.get(i).isMousedOver()) {
                    activeCard = cardHand.get(i);
                    if (activeCard.getIfTakesTarget() == false) {
                        // TODO: Play card function
                    }
                }
            }
        }
    }

    public void drawCombat() {
        int enemyXPos = ENEMY_BASE_X;
        int cardsXPos = CARDS_BASE_X;
        image(battlePlayer.getImg(), 50, 100);

        for (int i=0; i < currEnemies.size(); i++) {
            image(currEnemies.get(i).getImg(), enemyXPos, 100);
            enemyXPos += 50;
        }

        for (int j=0; j < cardHand.size(); j++) {
            image(cardHand.get(j).getImg(), cardsXPos, 300);
            cardsXPos += 50;
        }
    }
}