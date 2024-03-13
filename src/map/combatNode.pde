class combatNode extends Node{
    Arraylist<Enemy> encounterEnemies ;
    
    Worm currworm = new Worm(passedPlayer);

    public combatNode(){
        encounterEnemies.add(currWorm);
    }
    public Arraylist<Enemy> getNextEnemy() {
        return encounterEnemies;
    }

}