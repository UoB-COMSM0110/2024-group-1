class AttackMove extends Move {
    private int attackDmg;

    AttackMove(Entity attacker, Entity target, int dmg) {
        super(attacker, target);
        attackDmg = dmg;
    }

    public int getDmg() {
        return attackDmg;
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