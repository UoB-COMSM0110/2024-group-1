class Defend extends StatusEffect implements TakingDmgMod {

    Defend(int count) {
        super("Defend", count);
        setDecrementType(new FullDecrement(this));
    }

    public void stackEffect(StatusEffect toStack) {
        lifeCounter += toStack.lifeCounter;
    }

    @Override
    public int modifyInputAmt(int input) {
        int outAmt = input - getLifeCounter();
        if (outAmt < 0) outAmt = 0;

        decrementCounter(input);
        return outAmt;
    }
}