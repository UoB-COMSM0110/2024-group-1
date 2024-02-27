abstract class StatusEffect {
    private String name;
    private int lifeCounter;
    private Entity affected;
    private DecrementType decrementType;

    StatusEffect(String name, int counter) {
        this.name = name;
        lifeCounter = counter;
        decrementType = new NoDecrement(this);
    }

    public void setAffected(Entity target) {
        affected = target;
    }

    public Entity getTarget() {
        return affected;
    }

    public void setDecrementType(DecrementType type) {
        decrementType = type;
    }

    public String getName() {
        return name;
    }

    public int getLifeCounter() {
        return lifeCounter;
    }

    abstract void stackEffect(StatusEffect toStack);

    public void prepDecrement() {
        decrementType.processDecrement();
    }

    public void decrementCounter(int amt) {
        lifeCounter -= amt;
        if (lifeCounter <= 0) {
            affected.removeStatusEffect(this);
        }
    }
}