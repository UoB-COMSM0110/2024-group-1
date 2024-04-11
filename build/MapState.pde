class MapState extends GameState {
    Button backButton,tutorialButton,entranceButton;
    Node[] nodes; 
    MapLoader mapLoader;

    GameEngine engineRef;
    private Player passedPlayer;

    private float scrollOffset = 0;//Scroll offset used to control map display part
    PImage desertImage,backImage,tutorialImage,entranceImage,combatIcon,shopIcon;//Used to generate a nice background image of map
    
    int currentNodeIndex = 0;  // Index of the currently highlighted node
    PVector cursorPosition;    // Position of the cursor or marker
    boolean showWarning = false; // 是否显示警告
    String warningMessage = "Blocked! "; // 警告消息内容

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

        // Initialize universal Button
        backButton = new Button(100, 50,230,60,backImage);
        tutorialButton = new Button(100, 150, 230, 60, tutorialImage);
        entranceButton = new Button(100, 250, 230, 60, entranceImage);

        // Initialize map from json map loader
        MapLoader mapLoader = new MapLoader(); // 假设这里不需要参数的构造函数或已经提供了一个空构造函数
        String[] jsonLines = loadStrings("../assets/map/mapChoiceEasy.json");
        String jsonString = join(jsonLines, "");
        mapLoader.loadNodesFromJSON(jsonString); // 从JSON字符串加载节点
        nodes = mapLoader.loadNodes(); // 创建Node数组

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
        /*    ArrayList<Enemy> enemies = new ArrayList<Enemy>();  // Initialize the enemy
            Worm worm = new Worm(passedPlayer);
            enemies.add(worm);
            CombatState combatState = new CombatState(engineRef, passedPlayer, enemies);
            engineRef.changeState(combatState);
            */
        }

        /* basic interactive function for combat node*/
        for (Node node : nodes) {
            if ((node.isMouseOver(mouseX, mouseY))&&(node instanceof CombatNode)&&(node.clickable)) {
                goToCombat();
                break; // 假设一次只能点击一个节点
            }
        }

        if (showWarning && mouseX > width / 2 + 135 && mouseX < width / 2 + 150 && mouseY > height / 2 - 50 && mouseY < height / 2 - 35) {
            showWarning = false; // Close warning message
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
                // Draw connections
                for (int connectedId : node.connectedIds) {
                    Node connectedNode = findNodeById(connectedId);
                    if (connectedNode != null) {
                        line(node.position.x, node.position.y, connectedNode.position.x, connectedNode.position.y);
                    }
                }
            }

        // Draw marker
        fill(0, 255, 0);  // Green color for cursor
        ellipse(cursorPosition.x, cursorPosition.y, 30, 30);  // Draw a larger ellipse for the cursor

        // Draw warning
        if (showWarning) {
            displayWarningMessage(); // 显示警告消息的函数

            // 检查是否点击了警告框的关闭区域
            if (mousePressed && mouseX > width / 2 + 135 && mouseX < width / 2 + 150 &&
                mouseY > height / 2 - 50 && mouseY < height / 2 - 35) {
                showWarning = false; // 关闭警告消息
                mousePressed = false; // 重置鼠标状态，避免重复触发
            }
    }


        // If Tutorial button clicked show text 
            //if (displayTextBox) {
            //    drawTextBox();
            //}
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
                text("AP     "+currAP, 1650, 90); // MP value info
            }else if(currAP >= 1000 && currAP <= 9999){
                text("AP       "+currAP, 1650, 90); // MP value info
            }else if(currAP >= 100 && currAP <= 999){
                text("AP         "+currAP, 1650, 90); // MP value info
            }else if(currAP >= 10 && currAP <= 99){
                text("AP           "+currAP, 1650, 90); // MP value info
            }else if(currAP >= 0 && currAP <= 9){
                text("AP             "+currAP, 1650, 90); // MP value info
            }
            //text("AP "+currAP, 1650, 90); // MP value info
    }

    private void drawTextBox() {
        fill(255);
        rect(325, 300, 300, 100); 
        textAlign(LEFT, TOP);
        fill(0);
        String textContent = "Scroll down or using ↑/↓ on keyboard to preview the route to top of Tower;\nClick to choose the start node or next node;\nUsing move point to move up;\nDouble click to close Tutorial.";
        text(textContent, 325, 300, 300, 100); 
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
        fill(255, 255, 0); // Yellow background
        rect(width / 2 - 150, height / 2 - 50, 300, 100);
        fill(0); // Black
        textAlign(CENTER, CENTER);
        text(warningMessage, width / 2, height / 2);

        // Draw close option
        fill(255);  // white "X"
        text("X", width / 2 + 135, height / 2 - 35);
    }

}