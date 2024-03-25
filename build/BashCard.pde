public class BashCard extends Card {
    private static final String bashPath = "../assets/cards/Attack_Bash.png";

    public BashCard() {
        super("Bash", CardType.CARDTYPE_ATTACK, 2, int(random(45, 60)), true);
    }

    public void applyCard(Entity target) {
        target.takeDamage(8);
        target.appendStatusEffect(new Vulnerable(2));
    }
}