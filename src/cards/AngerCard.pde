public class AngerCard extends Card {
    private static final String angerPath = "../assets/cards/Attack_Anger.png";

    public AngerCard() {
        super("Anger", CardType.CARDTYPE_ATTACK, 0, int(random(45, 55)), true);
    }

    public void applyCard(Entity target) {
        target.takeDamage(6);
    }
}