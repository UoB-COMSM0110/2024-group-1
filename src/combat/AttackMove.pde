class AttackMove extends Move {
    private int attackDmg;

    AttackMove(Entity attacker, Entity target, int dmg) {
        super(attacker, target, MoveType.MOVETYPE_ATTACK);
        attackDmg = dmg;
    }

    public int getDmg() {
        ArrayList<StatusEffect> attackerEffects = attacker.getActiveEffects();
        int dmgMod = 0;

        if (!attackerEffects.isEmpty()) {
            for (StatusEffect currEffect : attackerEffects) {
                if (currEffect instanceof AttackBoost) {
                    dmgMod += currEffect.getLifeCounter();
                }
            }
        }

        return attackDmg + dmgMod;
    }

    public boolean setDmg(int dmgAmt) {
        if (dmgAmt <= 0) {
            return false;
        }

        attackDmg = dmgAmt;
        return true;
    }

    public void executeMove() {
        attacker.dealDamage(attackDmg, target);
    }
}