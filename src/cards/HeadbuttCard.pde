public class HeadbuttCard extends Card {
    public HeadbuttCard() {
        super("Headbutt", CardType.CARDTYPE_ATTACK, 1, int(random(60, 90)), true, false);
    }

    public void applyCard(Entity target) {
        target.takeDamage(9);
    }
}