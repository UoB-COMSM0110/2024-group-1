abstract class Move {
    protected Entity attacker;
    protected Entity target;

    Move(Entity attacker, Entity target) {
        this.attacker = attacker;
        this.target = target;
    }

    abstract public void executeMove();
}