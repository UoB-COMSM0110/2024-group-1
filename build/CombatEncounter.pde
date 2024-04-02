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

        encounterImgs = new PImage[5];
        encounterImgs[0] = loadImage("../assets/combat/battle_background.png");
        encounterImgs[1] = loadImage("../assets/combat/turn_end_button.png");
        encounterImgs[2] = loadImage("../assets/combat/attack_icon.png");
        encounterImgs[3] = loadImage("../assets/combat/shield_icon.png");
        encounterImgs[4] = loadImage("../assets/combat/poison_icon.png");
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
        handleCardDraw(drawAmt);
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
        battlePlayer.triggerEffects(CardPlayTrigger.class, null);
        handleSpecialCardEffects(toPlay);

        if (!toPlay.getIfIsAoE()) {
            toPlay.applyCard(target);
        } else {
            for (Enemy nme : currEnemies) {
                toPlay.applyCard(nme);
            }
        }

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
                activeCard = null;
            } else if (activeCard != null && (activeCard.getIfTakesTarget() == true)) {
                for (int n=0; n < currEnemies.size(); n++) {
                    Enemy currEnemy = currEnemies.get(n);
                    if (currEnemy.isMousedOver() == true) {
                        playCard(activeCard, currEnemy);
                    }
                }
            } else {
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
    }

    public OutcomeType checkWinLoss() {
        if (currEnemies.isEmpty() == true) {
            processBattleEnd();
            return OutcomeType.OUTCOME_WIN;
        } else if (battlePlayer.getCurrHp() <= 0) {
            processBattleEnd();
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
        fill(255);
        String activeCardName = activeCard != null ? activeCard.getName() : "None";
        textAlign(LEFT, BASELINE);
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
            image(curr.getImg(), curr.getPos().x, curr.getPos().y, 360, 360);
            text(curr.getCurrHp() + "/" + curr.getMaxHp(), curr.getPos().x+80, curr.getPos().y+300);
            fill(250, 172, 15);
            rect(curr.getPos().x+80, curr.getPos().y+350, 200, 20, 30);
            fill(161, 18, 18);
            rect(curr.getPos().x+80, curr.getPos().y+350, 200*((float)curr.getCurrHp()/(float)curr.getMaxHp()), 20, 30);

            drawMoveIntentions(curr);
        }
    }

    private void drawMoveIntentions(Enemy curr) {
        ArrayList<Move> moves = curr.getMoves();
        fill(255);
        for (int j=0; j < moves.size(); j++) {
            MoveType type = moves.get(j).getType();
            switch (type) {
                case MOVETYPE_ATTACK:
                    image(encounterImgs[2], curr.getPos().x+90, curr.getPos().y-50, 85, 85);

                    AttackMove casted = (AttackMove)moves.get(j);
                    int dmg = casted.getDmg();
                    text(dmg, curr.getPos().x+85, curr.getPos().y+40);
                    break;
                case MOVETYPE_DEFENCE:
                    image(encounterImgs[3], curr.getPos().x+90, curr.getPos().y-50, 85, 85);
                    break;
                case MOVETYPE_POISON:
                    image(encounterImgs[4], curr.getPos().x+90, curr.getPos().y-50, 85, 85);
                    break;
                default:
                    return;
            }
        }
    }

    private void handleCardDraw(int numCards) {
        cardHand = drawDeck.drawNCards(numCards);
        if (cardHand.size() < numCards) {
            drawDeck.setDeck(discardPile);
            drawDeck.shuffle();
            discardPile.clear();
            ArrayList<Card> extraCards = drawDeck.drawNCards(numCards-cardHand.size());
            cardHand.addAll(extraCards);
        }
    }

    private void handleSpecialCardEffects(Card played) {
        String cardName = played.getName();

        switch (cardName) {
            case "Anger":
                discardPile.add(new AngerCard());
                break;
            case "Blizzard":
                ((BlizzardCard) played).setDmgAmt(currEnemies.size()*2);
                break;
            default:
                return;
        }
    }

    private void processBattleEnd() {
        discardPile.addAll(cardHand);
        cardHand.clear();
        drawDeck.getDeck().addAll(discardPile);
        battlePlayer.setDeck(drawDeck);
        battlePlayer.clearAllEffects();
    }
}