public abstract class SecretMove extends Move {

    public SecretMove(Entity attacker, Entity target) {
        super(attacker, target, MoveType.MOVETYPE_SECRET);
    }
}