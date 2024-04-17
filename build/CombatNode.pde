class CombatNode extends Node {
    boolean isMouseOver;

    public CombatNode(int id, int[] connectedIds, boolean clickable, boolean currentOrNot, PVector position, int x, int y, String level) {
        super(id, connectedIds, clickable, currentOrNot, position, x, y, level);
    }

    public void display(PImage combatIcon){
        // Subtract half the width and height of the image so that the center of the image is aligned with the position of the node
        float imageX = position.x - combatIcon.width / 2;
        float imageY = position.y - combatIcon.height / 2;
        image(combatIcon, imageX, imageY);

        // Set the configuration of indicator
        if (clickable) {
            fill(153, 255, 153, 60);  // Yellow transparent
        } else {
            fill(255, 51, 51, 100);    // Red transparent
        }

        //Draw the cover indicator of clickable visualization
        rect(imageX, imageY, combatIcon.width, combatIcon.height);
    }
}
