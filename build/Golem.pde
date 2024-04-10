class Golem extends Enemy {
    private static final int GOLEM_HP = 65;
    private static final int GOLEM_STR = 40;
    private static final int GOLEM_DEX = 15;

    private static final double ATTACK_PROB = 0.55;
    private static final double DEFEND_PROB = 0.25;
    private static final double ATTACKBOOST_PROB = 0.20;

    private static final int GOLEM_ATTACK_VAL = 18;
    private static final int GOLEM_DEFENCE_VAL = 13;

    Golem(Player ref) {
        super("Golem", GOLEM_HP, GOLEM_STR, GOLEM_DEX, ref);
    }

    @Override
    public void readyMoves() {
        double[] moves = {ATTACK_PROB, DEFEND_PROB, ATTACKBOOST_PROB};

        int selectedIdx = CombatUtility.pickIndex(moves);

        switch (selectedIdx) {
            case 0:
                addMove(new AttackMove(this, playerRef, GOLEM_ATTACK_VAL));
                break;
            case 1:
                addMove(new DefenceMove(this, GOLEM_DEFENCE_VAL));
                break;
            case 2:
                List<StatusEffect> buffEffect = List.of(new AttackBoost(7));
                addMove(new StatusEffectMove(this, this, buffEffect));
            default:
                addMove(new AttackMove(this, playerRef, GOLEM_ATTACK_VAL));
        }
    }
}