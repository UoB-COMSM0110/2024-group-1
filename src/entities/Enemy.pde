import java.util.ArrayList;

abstract class Enemy extends Entity {
    ArrayList<Move> moves;

    Enemy(String name, int hp, int str, int dex) {
        super(name, hp, str, dex);
        moves = new ArrayList<Move>();
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
            move.execute();
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