public class ShrugItOffCard extends Card {

    public ShrugItOffCard() {
        super("Shrug It Off", CardType.CARDTYPE_STRATEGY, 1, int(random(65, 95)), false, false);
    }

    public void applyCard(Entity target) {
        target.appendStatusEffect(new Defend(8));
    }
}