public class StrikeCard extends Card {
    
    public StrikeCard() {
        super("Strike", CardType.CARDTYPE_ATTACK, 1, int(random(55, 100)), true, false);
    }

    public void applyCard(Entity target) {
        target.takeDamage(6);
    }
}