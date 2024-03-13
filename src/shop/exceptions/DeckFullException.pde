//package shop.exceptions;



   class DeckFullException extends Exception {
    private static final String MESSAGE = "Deck is full";
    public DeckFullException() {
        super(MESSAGE);
    }
}
