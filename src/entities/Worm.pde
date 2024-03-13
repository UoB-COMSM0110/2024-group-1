class Worm extends Enemy {
    private static final int WORM_HP = 40;
    private static final int WORM_STR = 25;
    private static final int WORM_DEX = 20;

    private static final int ATTACK_PROB = 0.65;
    private static final int DEFEND_PROB = 0.35;

    private static final int WORM_ATTACK_VAL = 11;
    private static final int WORM_DEFENCE_VAL = 7;

    Worm(Player ref) {
        super("Worm", WORM_HP, WORM_STR, WORM_DEX, ref);
    }

    @Override
    public void readyMoves() {
        double[] moves = {ATTACK_PROB, DEFEND_PROB};

        int selectedIdx = CombatUtility.pickIndex(moves);

        switch (selectedIdx) {
            case 0:
                addMove(new AttackMove(this, playerRef, WORM_ATTACK_VAL));
                break;
            case 1:
                addMove(new DefenceMove(this, WORM_DEFENCE_VAL));
                break;
            default:
                addMove(new AttackMove(this, playerRef, WORM_ATTACK_VAL));
        }
    }
}