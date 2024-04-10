public class DefenceCard extends Card {
    private static final int DEFEND_AMT = 5;

    public DefenceCard() {
        super("Defence", CardType.CARDTYPE_DEFENCE, 1, int(random(55, 100)), false, false);
    }

    public void applyCard(Entity target) {
        target.appendStatusEffect(new Defend(5));
    }
}