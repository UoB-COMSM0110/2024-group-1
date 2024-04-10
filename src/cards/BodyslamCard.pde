public class BodyslamCard extends Card {
    private int dmgAmt;

    public BodyslamCard() {
        super("Bodyslam", CardType.CARDTYPE_ATTACK, 1, int(random(250, 325)), true, false);
        dmgAmt = 0;
    }

    public void setDmgAmt(int input) {
        dmgAmt = input;
    }

    public void applyCard(Entity target) {
        target.takeDamage(dmgAmt);
    }
}