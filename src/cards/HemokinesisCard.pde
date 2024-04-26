public class HemokinesisCard extends Card {

    public HemokinesisCard() {
        super("Hemokinesis", CardType.CARDTYPE_ATTACK, 1, int(random(60, 110)), true, false);
    }

    public void applyCard(Entity target) {
        target.takeDamage(15);
    }
}