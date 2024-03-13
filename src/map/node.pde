class Node {
    PVector position; 
    float radius; 
    boolean isSelected; 
    Player passedPlayer;

    Node(float x, float y, float radius) {
        this.position = new PVector(x, y);
        this.radius = radius;
        this.isSelected = false;
    }

    void display() {
        fill(0, 47, 167); 
        noStroke(); 
        ellipse(position.x, position.y, radius*2, radius*2);
    }

    boolean isMouseOver() {
        float distance = dist(mouseX, mouseY + scrollOffset, position.x, position.y);
        return distance < radius;
    }

}

