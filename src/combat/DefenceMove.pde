class DefenceMove extends Move {
    private int defenceAmt;

    DefenceMove(Entity defender, int amt) {
        super(defender, defender);
        defenceAmt = amt;
    }

    public void executeMove() {
        Defend toDo = new Defend(defenceAmt);
        target.appendStatusEffect(toDo);
    }
}