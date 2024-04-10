public class AngerCard extends Card {

    public AngerCard() {
        super("Anger", CardType.CARDTYPE_ATTACK, 0, int(random(45, 55)), true, false);
    }

    public void applyCard(Entity target) {
        target.takeDamage(6);
    }
}