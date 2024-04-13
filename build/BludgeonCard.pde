public class BludgeonCard extends Card {

    public BludgeonCard() {
        super("Bludgeon", CardType.CARDTYPE_ATTACK, 1, int(random(250, 450)), true, false);
    }

    public void applyCard(Entity target) {
        target.takeDamage(32);
    }
} 