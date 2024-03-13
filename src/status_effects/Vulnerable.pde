public class Vulnerable extends StatusEffect implements TakingDmgMod {
    private static final double DMG_MOD = 0.25;

    public Vulnerable(int lifeCounter) {
        super("Vulnerable", lifeCounter);
        setDecrementType(new DefaultDecrement(this));
    }

    public int modifyInputAmt(int input) {
        return (int) (input * (1+DMG_MOD));
    }
}