public class PoisonCard extends Card {
    private static final String psnPath = "../assets/cards/Skill_Deadly Poison.png";

    public PoisonCard() {
        super("Deadly Poison", CardType.CARDTYPE_STRATEGY, 1, int(random(45, 55)), true);
    }

    public void applyCard(Entity target) {
        target.appendStatusEffect(new Poison(5));
    }
}