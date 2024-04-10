public class BlizzardCard extends Card {
    private int dmgAmt;

    public BlizzardCard() {
        super("Blizzard", CardType.CARDTYPE_ATTACK, 1, int(random(60, 110)), true, false);
        dmgAmt = 1;
    }

    public void setDmgAmt(int input) {
        dmgAmt = input;
    }

    public void applyCard(Entity target) {
        target.takeDamage(dmgAmt);
    }
}