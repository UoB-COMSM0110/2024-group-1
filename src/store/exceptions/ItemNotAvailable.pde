package store.exceptions;

public class ItemNotAvailable extends Exception {
    private static final String MESSAGE = "Item is not available";

    public ItemNotAvailable() {
        super(MESSAGE);
    }
}
