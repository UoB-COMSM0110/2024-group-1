class FullDecrement extends DecrementType {
    FullDecrement(StatusEffect parent) {
        super(parent);
    }

    public void processDecrement() {
        effect.decrementCounter(effect.getLifeCounter());
    }
}
