public class PoisonCard extends Card {

    public PoisonCard() {
        super("Deadly Poison", CardType.CARDTYPE_STRATEGY, 1, int(random(45, 55)), true, false);
    }

    public void applyCard(Entity target) {
        target.appendStatusEffect(new Poison(5));
    }
}