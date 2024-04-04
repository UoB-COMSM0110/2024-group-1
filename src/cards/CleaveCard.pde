public class CleaveCard extends Card {

    public CleaveCard() {
        super("Cleave", CardType.CARDTYPE_ATTACK, 1, int(random(175, 350)), true, true);
    }

    public void applyCard(Entity target) {
        target.takeDamage(8);
    }
}