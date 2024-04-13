import java.util.List;

class Spider extends Enemy {
    private static final int SPIDER_HP = 15;
    private static final int SPIDER_STR = 10;
    private static final int SPIDER_DEX = 25;

    private static final double ATTACK_PROB = 0.70;
    private static final double POISON_PROB = 0.30;

    private static final int SPIDER_ATTACK_VAL = 8;

    Spider(Player ref) {
        super("Spider", SPIDER_HP, SPIDER_STR, SPIDER_DEX, ref);
    }

    @Override
    public void readyMoves() {
        double[] moves = {ATTACK_PROB, POISON_PROB};

        int selectedIdx = CombatUtility.pickIndex(moves);

        switch (selectedIdx) {
            case 0:
                addMove(new AttackMove(this, playerRef, SPIDER_ATTACK_VAL));
                break;
            case 1:
                List<StatusEffect> poisonEffect = List.of(new Poison(5));
                addMove(new StatusEffectMove(this, playerRef, poisonEffect));
                break;
            default:
                addMove(new AttackMove(this, playerRef, SPIDER_ATTACK_VAL));
        }
    }
}