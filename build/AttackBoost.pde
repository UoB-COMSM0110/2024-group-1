public class AttackBoost extends StatusEffect implements DoingDmgMod {

    public AttackBoost(int lifeCounter) {
        super("Attack Boost", lifeCounter);
    }

    public void stackEffect(StatusEffect toStack) {
        lifeCounter += toStack.lifeCounter;
    }

    public int modifyInputAmt(int input) {
        return input + getLifeCounter();
    }
}