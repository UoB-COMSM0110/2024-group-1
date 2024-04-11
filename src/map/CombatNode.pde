class CombatNode extends Node {
    boolean isMouseOver;

    public CombatNode(int id, int[] connectedIds, boolean clickable, PVector position, int x, int y, String level) {
        super(id, connectedIds, clickable, position, x, y, level);
    }

    public void display(PImage combatIcon){
        // 减去图像宽高的一半，使图片中心与节点位置对齐
        float imageX = position.x - combatIcon.width / 2;
        float imageY = position.y - combatIcon.height / 2;
        image(combatIcon, imageX, imageY);
    }   
}
