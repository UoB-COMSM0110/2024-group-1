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
        battlePlayer.triggerEffects(TurnStartTrigger.class, null);
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

        for (Enemy nme : currEnemies) {
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

    private void playCard(Card toPlay, Entity target) {
        toPlay.applyCard(target);
        if ((target instanceof Enemy) && (target.getCurrHp() <= 0)) {
            currEnemies.remove(target);
        }
        cardHand.remove(toPlay);
        discardPile.add(toPlay);
        battlePlayer.decrementEnergy(toPlay.getEnergyCost());
    }

    public void processMouseInput() {
        if ((mousePressed == true) && (isPlayerTurn == true)) {
            if (activeCard != null && (activeCard.getIfTakesTarget() == true)) {
                for (int n=0; n < currEnemies.size(); n++) {
                    Enemy currEnemy = currEnemies.get(n);
                    if (currEnemy.isMousedOver() == true) {
                        playCard(activeCard, currEnemy);
                    }
                }
            }

            for (int i=0; i < cardHand.size(); i++) {
                Card currCard = cardHand.get(i);
                if (currCard.isMousedOver() == true) {
                    if (currCard.getEnergyCost() <= battlePlayer.getCurrEnergy()) {
                        activeCard = currCard;
                    }
                }
            }
            if (activeCard != null && (activeCard.getIfTakesTarget() == false)) {
                playCard(activeCard, battlePlayer);
            }
        }
    }

    public OutcomeType checkWinLoss() {
        if (currEnemies.isEmpty() == true) {
            return OutcomeType.OUTCOME_WIN;
        } else if (battlePlayer.getCurrHp() <= 0) {
            return OutcomeType.OUTCOME_LOSS;
        } else return OutcomeType.OUTCOME_UNDECIDED;
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