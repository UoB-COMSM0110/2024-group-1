//package shop.exceptions;

public class NotEnoughGoldException extends Exception {
    private static final String MESSAGE = "Not enough gold";

    public NotEnoughGoldException() {
        super(MESSAGE);
    }
}
