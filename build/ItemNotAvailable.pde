//package shop.exceptions;

public class ItemNotAvailable extends Exception {
  
  //handles when item is not available
    private static final String MESSAGE = "Item is not available";

    public ItemNotAvailable() {
        super(MESSAGE);
    }
}
