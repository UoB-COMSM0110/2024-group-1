public class ThunderclapCard extends Card {

    public ThunderclapCard() {
        super("Thunderclap", CardType.CARDTYPE_ATTACK, 1, int(random(180, 220)), true, true);
    }

    public void applyCard(Entity target) {
        target.takeDamage(4);
        target.appendStatusEffect(new Vulnerable(1));
    }
}