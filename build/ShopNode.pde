class ShopNode extends Node { 
    boolean isMouseOver;
    private ArrayList<Card> shopCards;

    public ShopNode(int id, int[] connectedIds, boolean clickable, PVector position, int x, int y, String level) {
        super(id, connectedIds, clickable, position, x, y, level);
    }

    public void display(PImage shopIcon){
        // 减去图像宽高的一半，使图片中心与节点位置对齐
        float imageX = position.x - shopIcon.width / 2;
        float imageY = position.y - shopIcon.height / 2;
        
        image(shopIcon, imageX, imageY);
        // Set the configuration of indicator
        if (clickable) {
            fill(255, 255, 0, 100);  // Yellow transparent
        } else {
            fill(255, 0, 0, 100);    // Red transparent
        }

        //Draw the cover indicator of clickable visualization
        rect(imageX, imageY, combatIcon.width, combatIcon.height);
    }
    
    public void setCards(ArrayList<Card> cards) {
      shopCards = cards;
    }
}
