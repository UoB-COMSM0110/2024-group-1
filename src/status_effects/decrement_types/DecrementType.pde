abstract class DecrementType {
    protected StatusEffect effect;
    DecrementType(StatusEffect parent) {
        effect = parent;
    }

    abstract public void processDecrement();
}