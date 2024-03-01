import java.util.ArrayList;

abstract class Entity {

    private int maxHp;
    private int currHp;
    private int strength;
    private int dexterity;
    private String name;
    private ArrayList<StatusEffect> activeEffects;

    Entity(String name, int maxHp, int str, int dex) {
        this.maxHp = maxHp;
        currHp = maxHp;
        this.name = name;
        strength = str;
        dexterity = dex;
        activeEffects = new ArrayList<StatusEffect>();
    }

    public int getCurrHp() {
        return currHp;
    }

    public int getMaxHp() {
        return maxHp;
    }

    private void incrementHp(int amt) {
        currHp += amt;
        if (currHp > maxHp) {
            currHp = maxHp;
        }
    }

    public void gainHealth(int initialAmt) {
        int finalAmt = applyModifiers(BuffHealMod.class, initialAmt);
        incrementHp(finalAmt);
    }

    public boolean takeDamage(int initialAmt) {
        int finalAmt = applyModifiers(EnemyDmgMod.class, initialAmt);
        if (finalAmt < 0) {
            return false;
        }
        decrementHp(finalAmt);
        if (getCurrHp() <= 0) {
            die();
            return false;
        }

        return true;
    } 

    private void decrementHp(int amt) {
        currHp -= amt;
    }

    public String getName() {
        return name;
    }

    public int getStr() {
        return strength;
    }

    private void incrementStr(int amt) {
        strength += amt;
    }

    private void decrementStr(int amt) {
        strength -= amt;
    }

    public int getDex() {
        return dexterity;
    }

    private void incrementDex(int amt) {
        dexterity += amt;
    }

    private void decrementDex(int amt) {
        dexterity -= amt;
    }

    public <T extends ModifierStatus> int applyModifiers(Class<T> modifierType, int amt) {
        for (int i=0; i < activeEffects.size(); i++) {
            StatusEffect curr = activeEffects.get(i);

            if (modifierType.isAssignableFrom(curr.getClass())) {
                amt = ((T) curr).modifyInputAmt(amt);
            }
        }

        return amt;
    }

    public void appendStatusEffect(StatusEffect newStatus) {
        StatusEffect existingEffect = null;

        for (StatusEffect curr: activeEffects) {
            if (curr.getName().equals(newStatus.getName())) {
                existingEffect = curr;
            }
        }

        if (existingEffect == null) {
            newStatus.setAffected(this);
            activeEffects.add(newStatus);
        } else {
            existingEffect.stackEffect(newStatus);
        }
    }

    public void removeStatusEffect(StatusEffect effect) {
        activeEffects.remove(effect);
    }

    public ArrayList<StatusEffect> getActiveEffects() {
        return activeEffects;
    }

    abstract void die();
}