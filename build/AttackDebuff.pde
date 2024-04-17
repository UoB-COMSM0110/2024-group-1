public class AttackDebuff extends StatusEffect implements DoingDmgMod {
    private static final double ATTACK_MOD = 0.25;

    public AttackDebuff(int lifeCounter) {
        super("Attack Debuff", lifeCounter);
        setDecrementType(new DefaultDecrement(this));
    }

    public void stackEffect(StatusEffect toStack) {
        lifeCounter += toStack.lifeCounter;
    }

    public int modifyInputAmt(int input) {
        return (int) (input * (1-ATTACK_MOD));
    }
}