import java.util.ArrayList;

abstract class Enemy extends Entity {
    private ArrayList<Move> moves;
    protected Player playerRef;

    Enemy(String name, int hp, int str, int dex, Player ref) {
        super(name, hp, str, dex);
        moves = new ArrayList<Move>();
        playerRef = ref;
    }

    public ArrayList<Move> getMoves() {
        return moves;
    }

    abstract void readyMoves();

    public void addMove(Move incomingMove) {
        moves.add(incomingMove);
    }

    public void executeMoves() {
        for (Move move : moves) {
            move.executeMove();
        }
        moves.clear();
    }

    public boolean dealDamage(int dmgAmt, Entity target) {
        int modifiedAmt = super.applyModifiers(EnemyDmgMod.class, dmgAmt);

        return target.takeDamage(modifiedAmt);
    }

    public void die() {
        // placeholder
    }
}