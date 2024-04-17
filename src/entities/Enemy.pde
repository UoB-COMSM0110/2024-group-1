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

    public void die() {
        // placeholder
    }
}
