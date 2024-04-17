class ShopNode extends Node { 
    boolean isMouseOver;
    private ArrayList<Card> shopCards;

    public ShopNode(int id, int[] connectedIds, boolean clickable,boolean currentOrNot, PVector position, int x, int y, String level) {
        super(id, connectedIds, clickable, currentOrNot, position, x, y, level);
    }

    public void display(PImage shopIcon){
        // Subtract half the width and height of the image so that the center of the image is aligned with the position of the node
        float imageX = position.x - shopIcon.width / 2;
        float imageY = position.y - shopIcon.height / 2;
        image(shopIcon, imageX, imageY);
        
        // Set the configuration of indicator
        if (clickable) {
            fill(153, 255, 153, 60);  // Yellow transparent
        } else {
            fill(255, 15, 15, 100);    // Red transparent
        }

        //Draw the cover indicator of clickable visualization
        rect(imageX, imageY, shopIcon.width, shopIcon.height);
    }
    
    public void setCards(ArrayList<Card> cards) {
        shopCards = cards;
    }
}
