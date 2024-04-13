public class AfterImageCard extends Card {

    public AfterImageCard() {
        super("After Image", CardType.CARDTYPE_STRATEGY, 1, int(random(200, 400)), false, false);
    }

    public void applyCard(Entity target) {
        target.appendStatusEffect(new AfterImageEffect());
    }
}