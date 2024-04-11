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
    }
    
    public void setCards(ArrayList<Card> cards) {
      shopCards = cards;
    }
}
