class Boss extends Enemy {
    private static final int BOSS_HP = 250;
    private static final int BOSS_STR = 50;
    private static final int BOSS_DEX = 35;
    private static final int STANCE_THRESHOLD_INCREMENT = 10;

    private static final int HEAVY_ATTACK_DMG = 30;
    private static final int LIGHT_ATTACK_DMG = 15;
    private static final int FLURRY_DMG = 4;
    private static final int PUMMEL_DMG = 6;
    private static final int PAIN_AURA_DMG = 3;

    int currMoveIdx;
    int stanceChangeThreshold;
    int stanceChangeCount;
    boolean inDefensiveStance;

    Boss(Player ref) {
        super("Boss", BOSS_HP, BOSS_STR, BOSS_DEX, ref);
        stanceChangeThreshold = 5;
        stanceChangeCount = stanceChangeThreshold;
        takeOffensiveStance();
    }

    @Override
    public void readyMoves() {
        if (inDefensiveStance) {
            switch (currMoveIdx) {
                case 0:
                    List<StatusEffect> damageEffect = List.of(new PainAura(this, PAIN_AURA_DMG));
                    addMove(new StatusEffectMove(this, this, damageEffect));
                    break;
                case 1:
                    addMove(new AttackMove(this, playerRef, LIGHT_ATTACK_DMG));
                    break;
                case 2:
                    int attackCount = ThreadLocalRandom.current().nextInt(1, 3);
                    addMove(new AttackMove(this, playerRef, FLURRY_DMG*attackCount));
                    addMove(new SecretMove(this, this) {
                        @Override
                        public void executeMove() {
                            takeOffensiveStance();
                        }
                    });
                    break;
            }
        } else {
            switch (currMoveIdx) {
                case 0:
                    List<StatusEffect> buffEffect = List.of(new AttackBoost(10));
                    addMove(new StatusEffectMove(this, this, buffEffect));
                    break;
                case 1:
                    addMove(new AttackMove(this, playerRef, HEAVY_ATTACK_DMG));
                    break;
                case 2:
                    List<StatusEffect> debuffsList = List.of(new AttackDebuff(2), new Vulnerable(2));
                    addMove(new StatusEffectMove(this, playerRef, debuffsList));
                    break;
                case 3:
                    int pummelCount = ThreadLocalRandom.current().nextInt(1, 4);
                    addMove(new AttackMove(this, playerRef, PUMMEL_DMG*pummelCount));
                    currMoveIdx = -1;
                    break;
            }
        }
        currMoveIdx++;
    }

    public void takeOffensiveStance() {
        appendStatusEffect(new OffensiveStance(this));
        currMoveIdx = 0;
        stanceChangeThreshold += STANCE_THRESHOLD_INCREMENT;
        stanceChangeCount = stanceChangeThreshold;
        inDefensiveStance = false;
    }

    public void takeDefensiveStance() {
        currMoveIdx = 0;
        inDefensiveStance = true;
        this.clearMoves();
        readyMoves();
    }

    class OffensiveStance extends StatusEffect implements OnDamageTrigger {
        Boss subject;

        public OffensiveStance(Boss theBoss) {
            super("Offensive Stance", 1);
            subject = theBoss;
        }

        public void stackEffect(StatusEffect toStack) {}

        @Override
        public void trigger(Object source) {
            int damageReceived = (int)((Object[])source)[1];
            subject.stanceChangeCount -= damageReceived;

            if (subject.stanceChangeCount <= damageReceived) {
                decrementCounter(getLifeCounter());
                subject.takeDefensiveStance();
            }
        }
    }

    class PainAura extends StatusEffect implements OnDamageTrigger {
        private Boss subject;

        public PainAura(Boss theBoss, int count) {
            super("Pain Aura", count);
            subject = theBoss;
            setDecrementType(new DecrementType(this) {
                @Override
                public void processDecrement() {
                    if (!((PainAura)effect).subject.inDefensiveStance) {
                        effect.decrementCounter(effect.getLifeCounter());
                    }
                }
            });
        }

        public void stackEffect(StatusEffect toStack) {}

        @Override
        public void trigger(Object source) {
            Entity attacker = (Entity)((Object[])source)[1];
            attacker.takeDamage(this.getLifeCounter());
        }
    }
}