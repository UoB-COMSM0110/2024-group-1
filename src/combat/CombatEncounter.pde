class CombatEncounter {
    private Player battlePlayer;
    private Deck drawDeck;
    private ArrayList<Enemy> currEnemies;
    private ArrayList<Card> cardHand;
    private ArrayList<Card> discardPile;
    private Card activeCard;
    private boolean isPlayerTurn;
    private int drawAmt;
    private final int ENEMY_BASE_X = (width/2);
    private final int ENEMY_BASE_Y = 600;
    private PImage background;
    private Button endTurnBtn;
    private EntityImgLoader entityImgs;

    CombatEncounter(Player thePlayer, ArrayList<Enemy> enemies) {
        battlePlayer = thePlayer;
        currEnemies = enemies;
        activeCard = null;
        cardHand = new ArrayList<Card>();
        discardPile = new ArrayList<Card>();
        entityImgs = new EntityImgLoader();
        drawAmt = 5;

        background = loadImage("../assets/combat/battle_background.png");
        endTurnBtn = new Button(width-300, height-400, 256, 256, loadImage("../assets/combat/turn_end_button.png"));
    }

    public void initEncounter() {
        for (Enemy nme : currEnemies) {
            nme.setImg(entityImgs.getImg(nme.getName()));
            nme.setPos(ENEMY_BASE_X, ENEMY_BASE_Y);
        }

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
            ArrayList<Card> extraCards = drawDeck.drawNCards(drawAmt-cardHand.size());
            cardHand.addAll(extraCards);
        }
    }

    private void endTurn() {
        isPlayerTurn = false;
        activeCard = null;

        discardPile.addAll(cardHand);
        cardHand.clear();

        for (Enemy nme : currEnemies) {
            nme.executeMoves();
        }
        startTurn();
    }

    private void decayStatuses() {
        for (int i=0; i < currEnemies.size(); i++) {
            currEnemies.get(i).decayEffects();
        }
        battlePlayer.decayEffects();
    }

    private void playCard(Card toPlay, Entity target) {
        toPlay.applyCard(target);
        if ((target instanceof Enemy) && (target.getCurrHp() <= 0)) {
            currEnemies.remove(target);
        }
        cardHand.remove(toPlay);
        discardPile.add(toPlay);
        battlePlayer.decrementEnergy(toPlay.getEnergyCost());
        activeCard = null;
    }

    public void processMouseInput() {
        if (mousePressed && isPlayerTurn) {
            if (endTurnBtn.overButton()) {
                endTurn();
            }
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
        image(background, 0, 0, width, height);
        drawHUDElements();

        //image(battlePlayer.getImg(), 50, 100);
        drawEnemies();

        for (int j=0; j < cardHand.size(); j++) {
            image(cardHand.get(j).getImg(), cardHand.get(j).getPos().x, cardHand.get(j).getPos().y, 512, 512);
        }
    }

    private void drawHUDElements() {
        String activeCardName = activeCard != null ? activeCard.getName() : "None";
        textSize(64);
        text("Active Card: " + activeCardName, 50, 90);
        text("HP: " + battlePlayer.getCurrHp() + "/" + battlePlayer.getMaxHp(), width-300, 90);
        text("Energy: " + battlePlayer.getCurrEnergy() + "/" + battlePlayer.getEnergyLim(), width-350, 150);
        endTurnBtn.drawButton();
    }

    private void drawEnemies() {
        textSize(32);

        for (int i=0; i < currEnemies.size(); i++) {
            image(currEnemies.get(i).getImg(), currEnemies.get(i).getPos().x, currEnemies.get(i).getPos().y);
            text(currEnemies.get(i).getCurrHp() + "/" + currEnemies.get(i).getMaxHp(), currEnemies.get(i).getPos().x-20, 650);
        }
    }
}