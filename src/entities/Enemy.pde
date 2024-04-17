import java.util.ArrayList;

abstract class Enemy extends Entity {
    private ArrayList<Move> moves;
    protected Player playerRef;
    private int goldValue;

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

    public void clearMoves() {
        moves.clear();
    }

    public void executeMoves() {
        for (Move move : moves) {
            move.executeMove();
        }
        moves.clear();
    }

    public int getGoldValue() {
        return goldValue;
    }

    public void setGoldValue(int enemyGoldVal) {
        goldValue = enemyGoldVal;
    }

    public void die() {
        // placeholder
    }
}