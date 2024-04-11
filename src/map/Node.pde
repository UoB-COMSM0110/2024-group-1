abstract class Node {
    int id;
    int[] connectedIds;
    boolean clickable;
    PVector position; 
    String level;

    public Node(int id, int[] connectedIds, boolean clickable, PVector position, int x, int y, String level) {
        this.id = id;
        this.connectedIds = connectedIds;
        this.clickable = clickable;
        this.position = new PVector(x,y);
        this.level = level;
    }

    public void display() {
        // Default display for unknown type node
        fill(255); // White
        ellipse(position.x, position.y, 20, 20); 
    }
    

    public boolean isMouseOver(float mouseX, float mouseY) {
        float distance = PVector.dist(new PVector(mouseX, mouseY), this.position);
        return distance < 20; 
    }
}
