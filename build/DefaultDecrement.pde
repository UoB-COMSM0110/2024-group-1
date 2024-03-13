class DefaultDecrement extends DecrementType {
    DefaultDecrement(StatusEffect parent) {
        super(parent);
    }

    public void processDecrement() {
        effect.decrementCounter(1);
    }
}