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
    private PImage[] encounterImgs;
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

        encounterImgs = new PImage[4];
        encounterImgs[0] = loadImage("../assets/combat/battle_background.png");
        encounterImgs[1] = loadImage("../assets/combat/turn_end_button.png");
        encounterImgs[2] = loadImage("../assets/combat/attack_icon.png");
        encounterImgs[3] = loadImage("../assets/combat/shield_icon.png");
        endTurnBtn = new Button(width-300, height-400, 256, 256, encounterImgs[1]);
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
        image(encounterImgs[0], 0, 0, width, height);
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
            Enemy curr = currEnemies.get(i);
            image(curr.getImg(), curr.getPos().x, curr.getPos().y);
            text(curr.getCurrHp() + "/" + curr.getMaxHp(), curr.getPos().x-20, curr.getPos().y+300);

            ArrayList<Move> moves = curr.getMoves();
            for (int j=0; j < moves.size(); j++) {
                MoveType type = moves.get(j).getType();
                switch (type) {
                    case MOVETYPE_ATTACK:
                        image(encounterImgs[2], curr.getPos().x+50, curr.getPos().y-50, 85, 85);
                        break;
                    case MOVETYPE_DEFENCE:
                        image(encounterImgs[3], curr.getPos().x+50, curr.getPos().y-50, 85, 85);
                        break;
                }
            }
        }
    }
}