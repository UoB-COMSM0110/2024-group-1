public class BashCard extends Card {

    public BashCard() {
        super("Bash", CardType.CARDTYPE_ATTACK, 2, int(random(45, 60)), true, false);
    }

    public void applyCard(Entity target) {
        target.takeDamage(8);
        target.appendStatusEffect(new Vulnerable(2));
    }
}