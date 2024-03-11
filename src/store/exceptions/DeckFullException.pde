package store.exceptions;

public class DeckFullException extends Exception {
    private static final String MESSAGE = "Deck is full";

    public DeckFullException() {
        super(MESSAGE);
    }
}
