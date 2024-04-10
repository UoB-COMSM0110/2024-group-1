class DefenceMove extends Move {
    private int defenceAmt;

    DefenceMove(Entity defender, int amt) {
        super(defender, defender, MoveType.MOVETYPE_DEFENCE);
        defenceAmt = amt;
    }

    public void executeMove() {
        Defend toDo = new Defend(defenceAmt);
        target.appendStatusEffect(toDo);
    }
}