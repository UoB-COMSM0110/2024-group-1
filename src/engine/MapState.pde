class MapState extends GameState {
    GameEngine engineRef;
    private Player passedPlayer;
    private float scrollOffset = 0;//Scroll offset used to control map display part
    PGraphics nodeLayer;// Used to store static node visual element
    PImage desertImage;//Used to generate a nice background image of map
    ArrayList<ArrayList<combatNode>> nodesByRow = new ArrayList<ArrayList<combatNode>>(); //Store the position of each node
    MapButton[] buttons;
    private boolean displayTextBox = false;
    int embeddedCanvasWidth = 500;// The visible dimensions of the embedded canvas
    int embeddedCanvasHeight = 650;// The visible dimensions of the embedded canvas
    int contentHeight = 1200;// The content height of the embedded canvas is taller than its actual height, allowing for scrolling

    MapState(GameEngine engine, Player thePlayer) {
        engineRef = engine;
        passedPlayer = thePlayer;
        setupState();
        drawNode();
        drawState();
    }

    public void setupState() {
        background(0);
        // Initialize Button
            buttons = new MapButton[3];
            buttons[0] = new MapButton(50, 50, 100, 50, "Back");
            buttons[1] = new MapButton(50, 150, 100, 50, "Start Menu");
            buttons[2] = new MapButton(50, 250, 100, 50, "Tutorial");
  
        // Initialize Material
            //desertImage = loadImage("MapBackground.jpg"); 
        nodesByRow = new ArrayList<ArrayList<combatNode>>();
        nodeLayer = createGraphics(width, height);
        createNode();
        drawNodesOnce(); 
    }

    void createNode(){
        nodesByRow.clear();
        float minDistance = 30; 
        float diameter = 30;
        for (int i = 5; i > 0; i--) {
            ArrayList<combatNode> row = new ArrayList<combatNode>();
            int circlesInRow = (int)random(1, 5);
            float sectionWidth = (embeddedCanvasWidth - (circlesInRow + 1) * minDistance) / circlesInRow;
            for (int j = 0; j < circlesInRow; j++) {
                float xStart = minDistance + j * (sectionWidth + minDistance);
                float x = random(xStart, xStart + sectionWidth);
                float y = i * (contentHeight / 7.0) + (contentHeight / 7.0) / 2;
                combatNode node = new combatNode(x, y, diameter / 2);
                row.add(node);
            }
            nodesByRow.add(row);
        }
        // Top row
        ArrayList<combatNode> topRow = new ArrayList<combatNode>();
        float topX = embeddedCanvasWidth / 2.0;
        float topY = contentHeight / 14.0; 
        combatNode topNode = new combatNode(topX, topY, diameter / 2);
        topRow.add(topNode);
        nodesByRow.add(0, topRow); 
        // bottom row
        ArrayList<combatNode> bottomRow = new ArrayList<combatNode>();
        int circlesAtBottom = 3; // Three nodes in the bottom row 
        float bottomSectionWidth = embeddedCanvasWidth / (circlesAtBottom + 1);
        for (int i = 1; i <= circlesAtBottom; i++) {
            float x = i * bottomSectionWidth;
            float y = 6 * (contentHeight / 7.0) + (contentHeight / 7.0) / 2; // 使用相似的逻辑来定位底部节点
            combatNode bottomNode = new combatNode(x, y, diameter / 2);
            bottomRow.add(bottomNode);
        }
        nodesByRow.add(bottomRow); 

    }

    void drawNodesOnce() {
        nodeLayer.beginDraw();
        nodeLayer.clear(); 
        for (ArrayList<combatNode> row : nodesByRow) {
            for (combatNode node : row) {
                nodeLayer.fill(0, 47, 167); 
                nodeLayer.noStroke(); 
                nodeLayer.ellipse(node.position.x, node.position.y, node.radius*2, node.radius*2);
            }
        }
        nodeLayer.endDraw();
    }

    public void handleMouseInput() {
        //mouseClick on buttons
        for (int i = 0; i < buttons.length; i++) {
            if (buttons[i].isMouseOver()) {
                println("Button " + (i + 1) + " clicked: " + buttons[i].label);
                if (buttons[i].label.equals("Tutorial")) {
                    displayTextBox = !displayTextBox; // Change the state
                    break; // Don't check another operation
                }
            }
        }

        //mouseClick on nodes
        for (ArrayList<combatNode> row : nodesByRow) {
            for (combatNode node : row) {
                if (node.isMouseOver()) {
                    if(node instanceof combatNode){
                        Arraylist<Enemy> nextEnemy = node.getNextEnemy();
                        CombatState newCombat = new CombatState(engineRef,passedPlayer,nextEnemy);
                        engineRef.changeState(newCombat);
                    }
                    return; 
                }
            }
        }
    }

    public void handleMouseWheel(MouseEvent e){
        float event = e.getCount();
        scrollOffset += event*20; // Move 20 pixels each scrolling
        scrollOffset = constrain(scrollOffset, 0, contentHeight - embeddedCanvasHeight);
    }

    public void handleKeyInput() {
        if (key == CODED) {
            if (keyCode == UP) {
                scrollOffset -= 20;
            } else if (keyCode == DOWN) {
                scrollOffset += 20;
            }
            scrollOffset = constrain(scrollOffset, 0, contentHeight - embeddedCanvasHeight);
        }
    }

    public void updateState() {}

    public void pauseState() {}

    public void resumeState() {}

    public void drawState() {
        // Draw Button
            for (int i = 0; i < buttons.length; i++) {
                buttons[i].display();
            }
  
        // Draw Status Information
            drawStatusInfo();
 
        // Draw Map
            drawEmbeddedCanvas();
            image(nodeLayer, 0, 0); 
  
        // If Tutorial button clicked show text 
            if (displayTextBox) {
            drawTextBox();
        }
    }

    private void drawStatusInfo() {
        // Draw Health Point
            fill(255, 0, 0);
            ellipse(870, 50, 30, 30); // Red shape
            fill(255);
            textSize(12);
            textAlign(RIGHT, CENTER);
            int currHP = passedPlayer.getCurrHp();
            int maxHP = passedPlayer.getMaxHp();
            text("HP "+currHP+"/"+maxHP, 850, 50); // HP value info
  
        // Draw Action Point
            fill(0, 255, 0);
            ellipse(870, 90, 30, 30); // Green shape
            fill(255);
            int currAP = thePlayer.getActionPts;
            text("MP "+currAP, 850, 90); // MP value info
    }

    private void drawTextBox() {
        fill(255);
        rect(325, 300, 300, 100); 
        textAlign(LEFT, TOP);
        fill(0);
        String textContent = "Scroll down or using ↑/↓ on keyboard to preview the route to top of Tower;\nClick to choose the start node or next node;\nUsing move point to move up;\nDouble click to close Tutorial.";
        text(textContent, 325, 300, 300, 100); 
    }

    private void drawEmbeddedCanvas() {
        // Set the visible range of the embedded canvas based on the scroll offset
        int canvasX = width/2 - embeddedCanvasWidth/2;
        int canvasY = height/2 - embeddedCanvasHeight/2;
            
        // Save the current drawing state
        pushMatrix();
        pushStyle();
        
        // Set the clipping area to only display a portion of the embedded canvas's content
        clip(canvasX, canvasY, embeddedCanvasWidth, embeddedCanvasHeight);
        
        // Display the corresponding part of the image based on the scroll offset
        image(desertImage, canvasX, canvasY - scrollOffset, embeddedCanvasWidth, desertImage.height);
        // fix the visible nodeLayer' position according to the scrolling offset
        image(nodeLayer, canvasX, canvasY - scrollOffset);
        // Restore the previous drawing state
        popStyle();
        popMatrix();
    }
}