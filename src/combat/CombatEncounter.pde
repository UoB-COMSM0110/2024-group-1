class CombatEncounter {
    private Player battlePlayer;
    private Deck drawDeck;
    private ArrayList<Enemy> currEnemies;
    private ArrayList<Card> cardHand;
    private ArrayList<Card> discardPile;
    private Card activeCard;
    private boolean isPlayerTurn, showCombatInfo;
    private int drawAmt;
    private final int ENEMY_BASE_X = (int)(width*0.43);
    private final int ENEMY_BASE_Y = (int)(height*0.25);
    private PImage[] encounterImgs;
    private Button endTurnBtn, combatInfoBtn;
    private int combatGoldReward;
    private EntityImgLoader entityImgs;

    CombatEncounter(Player thePlayer, ArrayList<Enemy> enemies) {
        battlePlayer = thePlayer;
        currEnemies = enemies;
        activeCard = null;
        cardHand = new ArrayList<Card>();
        discardPile = new ArrayList<Card>();
        entityImgs = new EntityImgLoader();
        drawAmt = 5;
        combatGoldReward = 0;
        showCombatInfo = false;

        encounterImgs = new PImage[11];
        encounterImgs[0] = loadImage("../assets/combat/battle_background.png");
        encounterImgs[1] = loadImage("../assets/combat/turn_end_button.png");
        encounterImgs[2] = loadImage("../assets/combat/attack_icon.png");
        encounterImgs[3] = loadImage("../assets/combat/shield_icon.png");
        encounterImgs[4] = loadImage("../assets/combat/poison_icon.png");
        encounterImgs[5] = loadImage("../assets/combat/attack_buff_icon.png");
        encounterImgs[6] = loadImage("../assets/combat/combat_help_icon.png");
        encounterImgs[7] = loadImage("../assets/combat/combat_info_popup.png");
        encounterImgs[8] = loadImage("../assets/combat/attack_debuff_icon.png");
        encounterImgs[9] = loadImage("../assets/combat/vulnerable_icon.png");
        encounterImgs[10] = loadImage("../assets/combat/click_to_use_icon.png");
        endTurnBtn = new Button((int)(width*0.80), (int)(height*0.75), 345, 126, encounterImgs[1]);
        combatInfoBtn = new Button((int)(width*0.01), (int)(height*0.07), 128, 128, encounterImgs[6]);
    }

    public void initEncounter() {
        calculateCombatReward();
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
            } else if (combatInfoBtn.overButton()) {
                showCombatInfo = !showCombatInfo;
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
            battlePlayer.incrementGold(combatGoldReward);
            return OutcomeType.OUTCOME_WIN;
        } else if (battlePlayer.getCurrHp() <= 0) {
            processBattleEnd();
            return OutcomeType.OUTCOME_LOSS;
        } else return OutcomeType.OUTCOME_UNDECIDED;
    }

    public void drawCombat() {
        image(encounterImgs[0], 0, 0, width, height);
        drawHUDElements();

        drawEnemies();

        for (int j=0; j < cardHand.size(); j++) {
            image(cardHand.get(j).getImg(), cardHand.get(j).getPos().x, cardHand.get(j).getPos().y, width*0.20, height*0.40);
        }

        if (showCombatInfo) {
            image(encounterImgs[7], (int)(width*0.10), (int)(height*0.10));
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
        combatInfoBtn.drawButton();
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

            if (activeCard != null) {
                image(encounterImgs[10], curr.getPos().x+50, curr.getPos().y+220, 250, 50);
            }

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
                case MOVETYPE_STRATEGY:
                    List<StatusEffect> effects = ((StatusEffectMove) moves.get(j)).getEffects();
                    drawStrategyIntentions(curr, effects);
                    break;
                default:
                    return;
            }
        }
    }

    private void drawStrategyIntentions(Enemy currEnemy, List<StatusEffect> fxList) {
        for (int n=0; n < fxList.size(); n++) {
            StatusEffect currEffect = fxList.get(n);

            if (currEffect instanceof Poison) {
                image(encounterImgs[4], currEnemy.getPos().x+90, currEnemy.getPos().y-50, 85, 85);
            } else if (currEffect instanceof AttackBoost) {
                image(encounterImgs[5], currEnemy.getPos().x+90, currEnemy.getPos().y-50, 85, 85);
            } else if (currEffect instanceof AttackDebuff) {
                image(encounterImgs[8], currEnemy.getPos().x+90, currEnemy.getPos().y-50, 85, 85);
            } else if (currEffect instanceof Vulnerable) {
                image(encounterImgs[9], currEnemy.getPos().x+90, currEnemy.getPos().y-50, 85, 85);
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
            case "Bodyslam":
                ArrayList<StatusEffect> activeFx = battlePlayer.getActiveEffects();
                int defendAmt = 0;
                for (StatusEffect effect : activeFx) {
                    if (effect instanceof Defend) {
                        defendAmt = effect.getLifeCounter();
                    }
                }
                ((BodyslamCard) played).setDmgAmt(defendAmt);
                break;
            case "Hemokinesis":
                battlePlayer.takeDamage(2);
                break;
            case "Iron Wave":
                battlePlayer.appendStatusEffect(new Defend(5));
                break;
            case "Shrug It Off":
                Card drawn = drawDeck.drawSingleCard();
                if (drawn == null) {
                    drawDeck.getDeck().addAll(discardPile);
                    discardPile.clear();
                    drawn = drawDeck.drawSingleCard();
                }
                cardHand.add(drawn);
                break;
            case "Headbutt":
                int randIdx = CombatUtility.pickRandomIdxFromDiscard(discardPile);
                if (randIdx == -1) return;
                Card randDrawn = discardPile.get(randIdx);
                discardPile.remove(randIdx);
                drawDeck.getDeck().add(0, randDrawn);
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

    private void calculateCombatReward() {
        for (Enemy nme : currEnemies) {
            int currNmeGold = nme.getGoldValue();
            combatGoldReward += currNmeGold;
        }
    }
}