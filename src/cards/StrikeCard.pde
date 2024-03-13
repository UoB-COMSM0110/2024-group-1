public class StrikeCard extends Card {

    public StrikeCard() {
        super("Strike", CardType.CARDTYPE_ATTACK, 1, int(random(45, 55)), true);
    }

    public void applyCard(Entity target) {
        target.takeDamage(6);
    }
}