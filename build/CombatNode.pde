class CombatNode extends Node {
    ArrayList<Enemy> encounterEnemies ;

    public CombatNode(float x, float y, float radius, Player passedPlayer) {
        super(x, y, radius, passedPlayer);
        this.encounterEnemies = new ArrayList<Enemy>();
        Worm currWorm = new Worm(passedPlayer);
        encounterEnemies.add(currWorm);
    }

    public ArrayList<Enemy> getNextEnemy() {
        return encounterEnemies;
    }

}