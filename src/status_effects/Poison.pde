public class Poison extends StatusEffect implements TurnStartTrigger {

    public Poison(int lifeCounter) {
        super("Poison", lifeCounter);
    }

    @Override
    public void trigger(Object source) {
        getTarget().takeDamage(getLifeCounter());
        decrementCounter(1);
    }
}