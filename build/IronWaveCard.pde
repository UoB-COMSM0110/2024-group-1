public class IronWaveCard extends Card {

    public IronWaveCard() {
        super("Iron Wave", CardType.CARDTYPE_ATTACK, 1, int(random(200, 250)), true, false);
    }

    public void applyCard(Entity target) {
        target.takeDamage(5);
    }
}