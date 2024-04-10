abstract class Move {
    protected Entity attacker;
    protected Entity target;
    private MoveType moveType;

    Move(Entity attacker, Entity target, MoveType type) {
        this.attacker = attacker;
        this.target = target;
        moveType = type;
    }

    abstract public void executeMove();

    public MoveType getType() {
        return moveType;
    }
}