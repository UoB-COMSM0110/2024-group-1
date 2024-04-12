import java.io.File;

class MapState extends GameState {
    Button backButton,tutorialButton,entranceButton;
    Node[] nodes; 
    MapLoader mapLoader;

    GameEngine engineRef;
    private Player passedPlayer;

    PImage desertImage,backImage,tutorialImage,entranceImage,combatIcon,shopIcon,tutorialDetail;//Used to generate a nice background image of map
    
    int currentNodeIndex = 0;  // Index of the currently highlighted node
    PVector cursorPosition;    // Position of the cursor or marker
    boolean showWarning = false; // Show warning or not
    String warningMessage = "Blocked! "; // Warning message content
    boolean showTutorial = false; // Show Tutorial or not


    MapState(GameEngine engine, Player thePlayer) {
        engineRef = engine;
        passedPlayer = thePlayer;
        setupState();
        drawState();
    }

    public void setupState() {

        // Initialize Material
        backImage = loadImage("../assets/map/backButton.png");
        tutorialImage = loadImage("../assets/map/tutorialButton.png");
        entranceImage = loadImage("../assets/map/enterButton.png");
        desertImage = loadImage("../assets/map/MapBackground.jpg"); 
        combatIcon = loadImage("../assets/map/combatIcon.png");
        combatIcon.resize(45,0);
        shopIcon = loadImage("../assets/map/shopIcon.png");
        shopIcon.resize(45,0);
        tutorialDetail = loadImage("../assets/map/tutorialDetail.png");
        tutorialDetail.resize(500,0);

        // Initialize universal Button
        backButton = new Button(100, 50,230,60,backImage);
        tutorialButton = new Button(100, 150, 230, 60, tutorialImage);
        entranceButton = new Button(100, 250, 230, 60, entranceImage);

        // Initialize map from json map loader
        MapLoader mapLoader = new MapLoader(); 
        // Check mapTemp exists or not 
        if(checkFileExists("../assets/map/mapTemp.json")){
            System.out.println("Loading from mapTemp.json");
            String[] jsonLines = loadStrings("../assets/map/mapTemp.json");
            String jsonString = join(jsonLines, "");
            mapLoader.loadNodesFromJSON(jsonString); // Load Node from JSON string
        }else{
            System.out.println("Loading from mapChoiceEasy.json");
            String[] jsonLines = loadStrings("../assets/map/mapChoiceEasy.json");
            String jsonString = join(jsonLines, "");
            mapLoader.loadNodesFromJSON(jsonString); // Load Node from JSON string
        }
        nodes = mapLoader.loadNodes(); // set Node array

        // Initialize the marker of current node
        currentNodeIndex = 0;  // Start at the first node
        if (nodes.length > 0) {
            cursorPosition = new PVector(nodes[currentNodeIndex].position.x, nodes[currentNodeIndex].position.y);
        }
    }

    public void handleMouseInput() {

        /* change game state to MENU_STATE */
        if (backButton.overButton() && mousePressed){
            background(240, 210, 200); /* for test */
            MenuState menuState = new MenuState(engineRef, passedPlayer);
            engineRef.changeState(menuState);
        }

        /* change game state to COMBAT_STATE */
        if (entranceButton.overButton() && mousePressed){
            Node selectedNode = nodes[currentNodeIndex];
            if (selectedNode.clickable) {
                // Node is clickable, start combat
                goToCombat();
            } else {
                // Node is not clickable, show warning
                showWarning("Blocked! ");
            }
        }

        /* basic interactive function for combat node*/
        for (Node node : nodes) {
            if ((node.isMouseOver(mouseX, mouseY))&&(node instanceof CombatNode)&&(node.clickable)) {
                node.currentOrNot = true;
                updateNodeStates();
                saveMapStateToFile("../assets/map/mapTemp.json");
                goToCombat();
                break; // Assume that node could be clicked only once at a time
            }
            if((node.isMouseOver(mouseX, mouseY))&&(!node.clickable)){
                // Node is not clickable, show warning
                showWarning("Blocked! ");
            }
        }

        /* Close the warning message */
        // define the close 'X' margin
        int clickMargin = 30; 
        // Recalculate the center position for the 'X'
        int rectWidth = 300; // The width of the warning box
        int rectX = width / 2 - rectWidth / 2 + 600; // Calculate the X position as in displayWarningMessage and adjust
        int rectY = height / 2 - 100 / 2 - 200; // Calculate the Y position as in displayWarningMessage and adjust
        int closeX = rectX + rectWidth - 15; // X position of 'X'
        int closeY = rectY + 15; // Y position of 'X'

        if (showWarning && mouseX > closeX - clickMargin && mouseX < closeX + clickMargin && mouseY > closeY - clickMargin && mouseY < closeY + clickMargin) {
            showWarning = false; // Close warning message
        }

        /* Open and Close the tutorial message */
        if (tutorialButton.overButton() && mousePressed){
            showTutorial = ! showTutorial;
        }

        /* change game state to COMBAT_STATE or SHOP_STATE*/
        /*test
               for(){
            if(node.isMouseOver(mouseX,mouseY)){
                if(node instanceof CombatNode){
                    ArrayList<Enemy> nextEnemy = node.getNextEnemy();
                    CombatState newCombat = new CombatState(engineRef,passedPlayer,nextEnemy);
                    engineRef.changeState(newCombat);
                }else if (node instanceof ShopNode) {
                    ShopState newShop = new ShopState(engineRef,passedPlayer);
                    engineRef.changeState(newShop);
                }
            }
        }
        test*/        
    }

    public void handleMouseWheel(MouseEvent e){
        //float event = e.getCount();
        //scrollOffset += event*20; // Move 20 pixels each scrolling
        //scrollOffset = constrain(scrollOffset, 0, contentHeight - embeddedCanvasHeight);
    }

    public void handleKeyInput() {
        if (keyPressed) {
            switch (keyCode) {
                case UP:
                    moveCursorToDifferentLevel(-1); // Move up a level
                    break;
                case DOWN:
                    moveCursorToDifferentLevel(1); // Move down a level
                    break;
                case LEFT:
                    moveCursorWithinLevel(-1); // Move left within the same level
                    break;
                case RIGHT:
                    moveCursorWithinLevel(1); // Move right within the same level
                    break;
                case ENTER:
                case RETURN:  // Some keyboards might label it as RETURN
                    Node selectedNode = nodes[currentNodeIndex];
                    if (selectedNode.clickable) {
                        // Node is clickable, start combat
                        updateNodeStates();
                        saveMapStateToFile("../assets/map/mapTemp.json");
                        goToCombat();
                    } else {
                        // Node is not clickable, show warning
                        showWarning("Blocked!");
                    }
                    break;
            }
        }
    }

    public void updateState() {}

    public void pauseState() {}

    public void resumeState() {}

    public void drawState() {
        image(desertImage,0,0,width,height);

        // Draw Button
            backButton.drawButton();
            tutorialButton.drawButton();
            entranceButton.drawButton();
  
        // Draw Status Information
            drawStatusInfo();
 
        // Draw Map
            for (Node node : nodes) {
                if(node instanceof CombatNode){
                    ((CombatNode)node).display(combatIcon);
                }else{
                    node.display(); 
                }
            }
            drawConnection();
        // Draw marker
            fill(0, 255, 0);  // Green color for cursor
            ellipse(cursorPosition.x, cursorPosition.y, 30, 30);  // Draw a larger ellipse for the cursor

        // Draw warning
            if (showWarning) {
                displayWarningMessage(); // Method to show warning
            }

        // If Tutorial button clicked show text 
            displayTutorialImage();
    }

    private void drawStatusInfo() {
        // Draw Health Point
            fill(255, 0, 0);
            ellipse(1670, 50, 30, 30); // Red shape
            fill(255);
            textSize(64);
            textAlign(RIGHT, CENTER);
            int currHP = passedPlayer.getCurrHp();
            int maxHP = passedPlayer.getMaxHp();
            text("HP "+currHP+"/"+maxHP, 1650, 50); // HP value info
  
        // Draw Action Point
            fill(0, 255, 0);
            ellipse(1670, 90, 30, 30); // Green shape
            fill(255);
            int currAP = passedPlayer.getActionPts();
            /*Optimize visual effect*/
            if(currAP <= 99999 && currAP >=10000){
                text("AP  "+currAP, 1650, 90); // MP value info
            }else if(currAP >= 1000 && currAP <= 9999){
                text("AP    "+currAP, 1650, 90); // MP value info
            }else if(currAP >= 100 && currAP <= 999){
                text("AP     "+currAP, 1650, 90); // MP value info
            }else if(currAP >= 10 && currAP <= 99){
                text("AP        "+currAP, 1650, 90); // MP value info
            }else if(currAP >= 0 && currAP <= 9){
                text("AP           "+currAP, 1650, 90); // MP value info
            }
            //text("AP "+currAP, 1650, 90); // MP value info
    }


    private void drawMap(){}

    // Utility method to find a node by its ID
    private Node findNodeById(int id) {
        for (Node n : nodes) {
            if (n.id == id) {
                return n;
            }
        }
        return null;
    }

    private void goToCombat() {
        ArrayList<Enemy> enemies = new ArrayList<Enemy>();
        Worm worm = new Worm(passedPlayer);
        enemies.add(worm);
        CombatState combatState = new CombatState(engineRef, passedPlayer, enemies);
        engineRef.changeState(combatState);
    }

    private void moveCursorToDifferentLevel(int delta) {
        String currentLevel = nodes[currentNodeIndex].level;
        int newLevelIndex = Integer.parseInt(currentLevel.split("_")[1]) + delta; // Assumes level format is "level_X"
        String newLevel = "level_" + newLevelIndex;

        for (int i = 0; i < nodes.length; i++) {
            if (nodes[i].level.equals(newLevel)) {
                currentNodeIndex = i;
                updateCursorPosition();
                break;
            }
        }
    }

    private void moveCursorWithinLevel(int delta) {
        String currentLevel = nodes[currentNodeIndex].level;
        int startIndex = currentNodeIndex;
        int endIndex = delta > 0 ? nodes.length : -1;
        int step = delta > 0 ? 1 : -1;

        for (int i = startIndex + step; i != endIndex; i += step) {
            if (nodes[i].level.equals(currentLevel)) {
                currentNodeIndex = i;
                updateCursorPosition();
                break;
            }
        }
    }

    private void updateCursorPosition() {
        cursorPosition.set(nodes[currentNodeIndex].position.x, nodes[currentNodeIndex].position.y);
    }

    private void showWarning(String message) {
        warningMessage = message;
        showWarning = true;
    }

    private void hideWarning() {
        showWarning = false;
    }

    private void displayWarningMessage() {
        // Original location
        int rectWidth = 300;
        int rectHeight = 100;
        int rectX = width / 2 - rectWidth / 2;
        int rectY = height / 2 - rectHeight / 2;

        // Change the location of warning message，right 600px, up 200px
        rectX += 600;
        rectY -= 200;

        // Draw yellow background
        fill(255, 255, 0);
        rect(rectX, rectY, rectWidth, rectHeight);

        // Draw warning content
        fill(0);
        textAlign(CENTER, CENTER);
        text(warningMessage, rectX + rectWidth / 2, rectY + rectHeight / 2);

        // Draw the closure option“X”
        text("x", rectX + rectWidth - 15, rectY + 15);
    }

    private void displayTutorialImage() {
        if (showTutorial) {
            image(tutorialDetail, (width - tutorialDetail.width) / 2 + 700, (height - tutorialDetail.height) / 2);
        }
    }

    private void drawConnection(){
        for (Node node : nodes) {
                // Draw connections
                for (int connectedId : node.connectedIds) {
                    Node connectedNode = findNodeById(connectedId);
                    if (connectedNode != null) {
                        line(node.position.x, node.position.y, connectedNode.position.x, connectedNode.position.y);
                    }
                }
        }
    }

    private boolean checkFileExists(String filePath){
        File file = new File(sketchPath(filePath));
        System.out.println(new File("../assets/map/mapTemp.json").getAbsolutePath());
        return file.exists();
    }

    public void updateNodeStates() {
        int currAP = passedPlayer.getActionPts();
        int minLevelWithCurrent = Integer.MAX_VALUE; // Find the smallest level where currentOrNot is true.
        ArrayList<Node> currentLevelNodes = new ArrayList<>();
        ArrayList<Node> nodesToActivate = new ArrayList<>(); // Store the nodes of the previous layer

        // Step 1: Find the smallest level where currentOrNot is true.
        for (Node node : nodes) {
            if (node.currentOrNot) {
                int level = getLevelAsInt(node.level);
                if (level < minLevelWithCurrent) {
                    minLevelWithCurrent = level;
                    currentLevelNodes.clear(); // Empty because the node with currentOrNot being true was found at a lower level
                    currentLevelNodes.add(node);
                } else if (level == minLevelWithCurrent) {
                    currentLevelNodes.add(node);
                }
            }
        }

        // Step 2: Update node status
        for (Node node : nodes) {
            int nodeLevel = getLevelAsInt(node.level);
            if (nodeLevel == minLevelWithCurrent - 1) {
                node.clickable = true;
                node.currentOrNot = true;
                nodesToActivate.add(node);
            } else if (nodeLevel >= minLevelWithCurrent) {
                node.clickable = false;
                node.currentOrNot = false;
            }
        }

        // Step 3: Update the clickable status according to the AP
        for (Node node : nodes) {
            int nodeLevel = getLevelAsInt(node.level);
            if (nodeLevel < minLevelWithCurrent) {
                for (Node currentNode : nodesToActivate) {
                    int currentLevel = getLevelAsInt(currentNode.level);
                    if (currentLevel - nodeLevel < passedPlayer.getActionPts()) {
                        node.clickable = true;
                    }
                }
            }
        }
    }

    public void saveMapStateToFile(String filename) {
        JSONArray jsonNodes = new JSONArray();
        for (Node node : nodes) {
            JSONObject jsonNode = new JSONObject();
            jsonNode.setInt("id", node.id);
            jsonNode.setString("type", node instanceof CombatNode ? "CombatNode" : "Node");
            jsonNode.setBoolean("clickable", node.clickable);
            jsonNode.setBoolean("currentOrNot", node.currentOrNot);
            jsonNode.setString("level", node.level);
            jsonNode.setInt("x", (int) node.position.x);
            jsonNode.setInt("y", (int) node.position.y);

            JSONArray connectedIds = new JSONArray();
            for (int id : node.connectedIds) {
                connectedIds.append(id);
            }
            jsonNode.setJSONArray("connected_ids", connectedIds);

            jsonNodes.append(jsonNode);
        }

        JSONObject mapData = new JSONObject();
        mapData.setJSONArray("nodes", jsonNodes);

        // Save JSON to file
        saveJSONObject(mapData, filename);
    }

    private int getLevelAsInt(String level) {
        // Assume the format "level_X"
        return Integer.parseInt(level.split("_")[1]);
    }
}