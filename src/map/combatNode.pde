class combatNode extends Node{
    Arraylist<Enemy> encounterEnemies ;

    public combatNode(){
        this.encounterEnemies = new Arraylist<Enemy>;
        Worm currworm = new Worm(passedPlayer);
        encounterEnemies.add(currWorm);
    }

    public Arraylist<Enemy> getNextEnemy() {
        return encounterEnemies;
    }

}