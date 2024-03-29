public class AfterImageEffect extends StatusEffect implements CardPlayTrigger {

    public AfterImageEffect() {
        super("After Image", 1);
    }

    public void stackEffect(StatusEffect toStack) {
        lifeCounter += toStack.lifeCounter;
    }

    @Override
    public void trigger(Object source) {
        getTarget().appendStatusEffect(new Defend(1));
    }
}