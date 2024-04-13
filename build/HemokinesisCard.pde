public class HemokinesisCard extends Card {

    public HemokinesisCard() {
        super("Hemokinesis", CardType.CARDTYPE_ATTACK, 1, int(random(215, 375)), true, false);
    }

    public void applyCard(Entity target) {
        target.takeDamage(15);
    }
}