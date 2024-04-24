import java.io.File;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Queue;
import java.util.LinkedList;
import java.util.Random;

class MapState extends GameState {
    Button backButton,tutorialButton,entranceButton;
    Node[] nodes; 
    MapLoader mapLoader;

    GameEngine engineRef;
    private Player passedPlayer;

    PImage desertImage,backImage,tutorialImage,entranceImage,combatIcon,shopIcon,tutorialDetail,APIcon,HPIcon,constantTutorial;//Used to generate a nice background image of map
    
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

    MapState(GameEngine engine, Player thePlayer, String hardmode){
        engineRef = engine;
        passedPlayer = thePlayer;
        setupState(hardmode);
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
        tutorialDetail.resize(985,0);
        APIcon = loadImage("../assets/map/apIcon.png");
        APIcon.resize(150,0);
        HPIcon = loadImage("../assets/map/hpIcon.png");
        HPIcon.resize(150,0);
        constantTutorial = loadImage("../assets/map/ConstantTutorial.png");
        constantTutorial.resize(320,0);
        

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
        currentNodeIndex = 11;  // Start at the bottom line
        if (nodes.length > 0) {
            cursorPosition = new PVector(nodes[currentNodeIndex].position.x, nodes[currentNodeIndex].position.y);
        }
    }

    public void setupState(String hardmode) {

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
        tutorialDetail.resize(985,0);
        APIcon = loadImage("../assets/map/apIcon.png");
        APIcon.resize(150,0);
        HPIcon = loadImage("../assets/map/hpIcon.png");
        HPIcon.resize(150,0);
        constantTutorial = loadImage("../assets/map/ConstantTutorial.png");
        constantTutorial.resize(320,0);

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
            System.out.println("Loading from mapChoiceHard.json");
            String[] jsonLines = loadStrings("../assets/map/mapChoiceHard.json");
            String jsonString = join(jsonLines, "");
            mapLoader.loadNodesFromJSON(jsonString); // Load Node from JSON string
        }
        nodes = mapLoader.loadNodes(); // set Node array

        // Initialize the marker of current node
        currentNodeIndex = 25;  // Start at the bottom line
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

        /* basic interactive function for different of node*/
        for (Node node : nodes) {
            if ((node.isMouseOver(mouseX, mouseY))&&(node instanceof CombatNode)&&(node.clickable)) {
                node.currentOrNot = true;
                updateNodeStates();
                saveMapStateToFile("../assets/map/mapTemp.json");
                goToCombat();
                break; // Assume that node could be clicked only once at a time
            }else if ((node.isMouseOver(mouseX, mouseY))&&(node instanceof ShopNode)&&(node.clickable)) {
                node.currentOrNot = true;
                updateNodeStates();
                saveMapStateToFile("../assets/map/mapTemp.json");
                goToShop();
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
            System.out.println("Tutorial button is clicked");
            showTutorial = ! showTutorial;
        }

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
                    if ((selectedNode.clickable) && (selectedNode instanceof CombatNode)) {
                        // Node is clickable, start combat
                        selectedNode.currentOrNot = true;
                        updateNodeStates();
                        saveMapStateToFile("../assets/map/mapTemp.json");
                        goToCombat();
                    } else if ((selectedNode.clickable) && (selectedNode instanceof ShopNode)) {
                        // Node is clickable, entershop
                        selectedNode.currentOrNot = true;
                        updateNodeStates();
                        saveMapStateToFile("../assets/map/mapTemp.json");
                        goToShop();
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
        background(255);//Clear the screen for connection lines
        image(desertImage,0,0,width,height);

        // Draw Button
            backButton.drawButton();
            tutorialButton.drawButton();
  
        // Draw Status Information
            drawStatusInfo();

        // Draw Constant picture tutorial
            image(constantTutorial,100,315);
        // Draw Map
            if(!showTutorial){
                drawConnection();
            }

            for (Node node : nodes) {
                if(node instanceof CombatNode){
                    ((CombatNode)node).display(combatIcon);
                }else if(node instanceof ShopNode){
                    ((ShopNode)node).display(shopIcon);
                }else{
                    node.display(); 
                }
            }
        // Draw cursor marker
            if(!keyPressed){
                updateCursorToClosestNode();
            }
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
        image(APIcon,1485,0);
        image(HPIcon,1485,65);

        // Draw Health Point
            fill(255, 0, 0);
            ellipse(1830, 50, 30, 30); // Red shape
            fill(255);
            textSize(64);
            textAlign(RIGHT, CENTER);
            int currHP = passedPlayer.getCurrHp();
            int maxHP = passedPlayer.getMaxHp();
            text(currHP+"/"+maxHP, 1800, 45); // HP value info
  
        // Draw Action Point
            fill(0, 255, 0);
            ellipse(1830, 110, 30, 30); // Green shape
            fill(255);
            int currAP = passedPlayer.getActionPts(); 
            text(currAP, 1800, 100); // MP value info
            //text("AP "+currAP, 1650, 90); // MP value info
    }

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
        int currEnemy = randomizeEnemy();
        System.out.println("Current enemy case is " + currEnemy);
        switch(currEnemy){
            //Spider
            case 0: 
                ArrayList<Enemy> enemies = new ArrayList<Enemy>();
                Spider spider = new Spider(passedPlayer);
                enemies.add(spider);
                CombatState combatState = new CombatState(engineRef, passedPlayer, enemies);
                engineRef.changeState(combatState);
                break;
            //Worm
            case 1:
                ArrayList<Enemy> enemiesDefault = new ArrayList<Enemy>();
                Worm worm = new Worm(passedPlayer);
                enemiesDefault.add(worm);
                CombatState combatStateDefault = new CombatState(engineRef, passedPlayer, enemiesDefault);
                engineRef.changeState(combatStateDefault);
                break;
            //Golem
            case 2:
                ArrayList<Enemy> enemiesGolem = new ArrayList<Enemy>();
                Golem golem = new Golem(passedPlayer);
                enemiesGolem.add(golem);
                CombatState combatStateGolem = new CombatState(engineRef, passedPlayer, enemiesGolem);
                engineRef.changeState(combatStateGolem);
            break;
        }
    }

    private int randomizeEnemy(){
        Random random = new Random();
        int randomEnemy = random.nextInt(3);
        return randomEnemy;
    }

    private void goToShop(){
        int currShopItems = randomizeShopItems();
        System.out.println("Current random shop contains case " + currShopItems);
        switch(currShopItems){
            //Blizzard and Bludgeon
            case 0: 
                ArrayList<Card> cards = new ArrayList<Card>();
                BlizzardCard blizzardCard = new BlizzardCard();
                BludgeonCard bludgeonCard = new BludgeonCard();
                IronWaveCard ironWaveCard = new IronWaveCard();
                BashCard bashCard = new BashCard();
                ShrugItOffCard shrugItOffCard = new ShrugItOffCard();
                BodyslamCard bodySlamCard = new BodyslamCard();
                PoisonCard poisonCard = new PoisonCard();
                ThunderclapCard thunderclapCard = new ThunderclapCard();
                HeadbuttCard headbuttCard = new HeadbuttCard();
                CleaveCard cleaveCard = new CleaveCard();
                cards.add(blizzardCard);
                cards.add(bludgeonCard);
                cards.add(ironWaveCard);
                cards.add(bashCard);
                cards.add(shrugItOffCard);
                cards.add(bodySlamCard);
                cards.add(poisonCard);
                cards.add(thunderclapCard);
                cards.add(headbuttCard);
                cards.add(cleaveCard);


                ShopState shopState = new ShopState(engineRef,passedPlayer,cards);
                engineRef.changeState(shopState);
                break;
            //Blizzard and Anger 
            case 1:
                ArrayList<Card> shopDeckOne = new ArrayList<Card>();
                BlizzardCard blizzardCardOne = new BlizzardCard();
                AngerCard angerCard = new AngerCard();
                ThunderclapCard thunderClapCardOne = new ThunderclapCard();
                ShrugItOffCard shrugItOffCardOne = new ShrugItOffCard();
                BodyslamCard bodySlamCardOne = new BodyslamCard();
                PoisonCard poisonCardOne = new PoisonCard();
                AfterImageCard afterImageCard = new AfterImageCard();
                BashCard bashCardOne = new BashCard();
                CleaveCard cleaveCardOne = new CleaveCard();
                HemokinesisCard hemokinesisCard = new HemokinesisCard();
                shopDeckOne.add(blizzardCardOne);
                shopDeckOne.add(angerCard);
                shopDeckOne.add(thunderClapCardOne);
                shopDeckOne.add(shrugItOffCardOne);
                shopDeckOne.add(bodySlamCardOne);
                shopDeckOne.add(poisonCardOne);
                shopDeckOne.add(afterImageCard);
                shopDeckOne.add(bashCardOne);
                shopDeckOne.add(hemokinesisCard);
                shopDeckOne.add(cleaveCardOne);
                ShopState shopStateOne = new ShopState(engineRef,passedPlayer,shopDeckOne);
                engineRef.changeState(shopStateOne);
                break;
            //Default test
            case 2:
                ArrayList<Card> shopDeckDefault = new ArrayList<Card>();
                BlizzardCard blizzardCardTwo = new BlizzardCard();
                IronWaveCard ironWaveCardTwo = new IronWaveCard();
                ThunderclapCard thunderClapCardTwo = new ThunderclapCard();
                PoisonCard poisonCardTwo = new PoisonCard();
                BodyslamCard bodySlamCardTwo = new BodyslamCard();
                AfterImageCard afterImageCardTwo = new AfterImageCard();
                CleaveCard cleaveCardTwo = new CleaveCard();
                BludgeonCard bludgeonCardTwo = new BludgeonCard();
                AngerCard angerCardTwo = new AngerCard();
                HemokinesisCard hemokinesisCardTwo = new HemokinesisCard();

                shopDeckDefault.add(blizzardCardTwo);
                shopDeckDefault.add(ironWaveCardTwo);
                shopDeckDefault.add(thunderClapCardTwo);
                shopDeckDefault.add(poisonCardTwo);
                shopDeckDefault.add(bodySlamCardTwo);
                shopDeckDefault.add(afterImageCardTwo);
                shopDeckDefault.add(cleaveCardTwo);
                shopDeckDefault.add(bludgeonCardTwo);
                shopDeckDefault.add(angerCardTwo);
                shopDeckDefault.add(hemokinesisCardTwo);
                ShopState shopStateTwo = new ShopState(engineRef,passedPlayer,shopDeckDefault);
                engineRef.changeState(shopStateTwo);
                break;
        }
    }

    private int randomizeShopItems(){
        Random random = new Random();
        int randomEnemy = random.nextInt(3);
        return randomEnemy;
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
            System.out.println("The showing state of tutorial is changed");
            image(tutorialDetail, 500,30);
        }
    }

    private void drawConnection(){
        stroke(255, 255, 255); // 设置线条颜色为红色
        strokeWeight(4);   // 设置线条粗细为4像素
        for (Node node : nodes) {
                // Draw connections
                for (int connectedId : node.connectedIds) {
                    Node connectedNode = findNodeById(connectedId);
                    if (connectedNode != null) {
                        line(node.position.x, node.position.y, connectedNode.position.x, connectedNode.position.y);
                    }
                }
        }
        strokeWeight(1);
        stroke(0,0,0,0); // 默认颜色设置为黑色
    }

    private boolean checkFileExists(String filePath){
        File file = new File(sketchPath(filePath));
        System.out.println(new File("../assets/map/mapTemp.json").getAbsolutePath());
        return file.exists();
    }

    public void updateNodeStates() {
        System.out.println("map updated inside mapstate");
        int currAP = passedPlayer.getActionPts();
        int minLevelWithCurrent = Integer.MAX_VALUE; // Find the smallest level where currentOrNot is true.
        ArrayList<Node> currentLevelNodes = new ArrayList<>();
        ArrayList<Node> nodesToActivate = new ArrayList<>(); // Store the nodes of the previous layer
        Node currentNode = null; // Declare currentNode here to ensure scope visibility.

        // Step 1: Find the smallest level where currentOrNot is true.
        for (Node node : nodes) {
            if (node.currentOrNot) {
                int level = getLevelAsInt(node.level);
                if (level < minLevelWithCurrent) {
                    minLevelWithCurrent = level;
                    currentNode = node;
                }
            }
        }


        if (currentNode != null) {
            // Step 2: Update node status
            for (Node node : nodes) {
                int nodeLevel = getLevelAsInt(node.level);
                if ((nodeLevel == minLevelWithCurrent - 1)&&isConnected(node.id, currentNode.id)) {
                    node.clickable = true;
                    nodesToActivate.add(node);
                } else if (nodeLevel >= minLevelWithCurrent) {
                    node.clickable = false;
                }
            }
            // Keep clicked node's currentOrNot as "true"，set its clickable to "false"
            currentNode.clickable = false;

            // Step 3: Update the clickable status according to the AP
            for (Node node : nodes) {
                if (node.level.equals(currentNode.level)) continue; // Skip the nodes in same level
                int nodeLevel = getLevelAsInt(node.level);
                if (nodeLevel < minLevelWithCurrent && (minLevelWithCurrent - nodeLevel) < currAP && isConnected(node.id, currentNode.id)) {
                    node.clickable = true; // connected with currentNode directly or indirectly
                }else if (nodeLevel == 1 && (minLevelWithCurrent - nodeLevel) < currAP) {
                    node.clickable = true; // Destination special result
                }
            }
            
        }

    }

    public void updateNodeStatesOutside(){
        System.out.println("map updates outside the mapstate");
        int currAP = passedPlayer.getActionPts();
        int minLevelWithCurrent = Integer.MAX_VALUE; // Find the smallest level where currentOrNot is true.
        ArrayList<Node> currentLevelNodes = new ArrayList<>();
        ArrayList<Node> nodesToActivate = new ArrayList<>(); // Store the nodes of the previous layer
        Node currentNode = null; // Declare currentNode here to ensure scope visibility.

        // Step 1: Find the smallest level where currentOrNot is true.
        for (Node node : nodes) {
            if (node.currentOrNot) {
                int level = getLevelAsInt(node.level);
                if (level < minLevelWithCurrent) {
                    minLevelWithCurrent = level;
                    currentNode = node;
                }
            }
        }


        if (currentNode != null) {
            // Step 2: Update node status
            for (Node node : nodes) {
                int nodeLevel = getLevelAsInt(node.level);
                if ((nodeLevel == minLevelWithCurrent - 1)&&isConnected(node.id, currentNode.id)) {
                    node.clickable = true;
                    nodesToActivate.add(node);
                } else if (nodeLevel >= minLevelWithCurrent) {
                    node.clickable = false;
                    node.currentOrNot = false;
                }
            }
            // Keep clicked node's currentOrNot as "true" and clickable as "false"
            currentNode.currentOrNot = true;

            // Step 3: Update the clickable status according to the AP
            for (Node node : nodes) {
                if (node.level.equals(currentNode.level)) continue; // Skip the nodes in same level
                int nodeLevel = getLevelAsInt(node.level);
                if (nodeLevel < (minLevelWithCurrent-1) && (minLevelWithCurrent - nodeLevel) < currAP && isConnected(node.id, currentNode.id)) {
                    node.clickable = true; // connected with currentNode directly or indirectly
                }else if (nodeLevel == 1 && (minLevelWithCurrent - nodeLevel) < currAP) {
                    node.clickable = true; // Destination special result
                }
            }
        }
    }

    public void saveMapStateToFile(String filename) {
        JSONArray jsonNodes = new JSONArray();
        for (Node node : nodes) {
            JSONObject jsonNode = new JSONObject();
            jsonNode.setInt("id", node.id);
            if (node instanceof CombatNode) {
                jsonNode.setString("type", "CombatNode");
            } else if (node instanceof ShopNode) {
                jsonNode.setString("type", "ShopNode");
            } else {
                jsonNode.setString("type", "Node");
            }
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

    public int getLevelById(int nodeId) {
        for (Node node : nodes) {
            if (node.id == nodeId) {
                return getLevelAsInt(node.level);
            }
        }
        System.out.println("Get level by ID failure.");
        return 0;
    }

    public boolean isConnected(int nodeId1, int nodeId2) {
        if (nodeId1 == nodeId2) {
            return true;
        }

        // Connection by diagram struct
        HashMap<Integer, HashSet<Integer>> graph = new HashMap<>();
        HashMap<Integer, String> nodeLevels = new HashMap<>(); // Store level of each node
        for (Node node : nodes) {
            nodeLevels.put(node.id, node.level);
            if (!node.level.equals("level_1")) { // level1 node could not be the mid node in route
                graph.putIfAbsent(node.id, new HashSet<>());
                for (int connectedId : node.connectedIds) {
                    // Destination level 1 is an exception
                    if (!nodeLevels.getOrDefault(connectedId, "level_1").equals("level_1")) { 
                        graph.get(node.id).add(connectedId);
                        graph.putIfAbsent(connectedId, new HashSet<>());
                        graph.get(connectedId).add(node.id);
                    }
                }
            }
        }
        System.out.println("Graph generated");

        // When level gap is 1, do not use BFS
        if (((getLevelById(nodeId1) - getLevelById(nodeId2)) == 1)||((getLevelById(nodeId1) - getLevelById(nodeId2)) == -1)){
            System.out.println("Checking only level gap is one");
            return graph.getOrDefault(nodeId1, new HashSet<>()).contains(nodeId2);
        }

        // BFS serching nodeId2 to nodeId2
        Queue<Integer> queue = new LinkedList<>();
        HashSet<Integer> visited = new HashSet<>();
        queue.add(nodeId1);
        visited.add(nodeId1);

        while (!queue.isEmpty()) {
            int current = queue.poll();
            if (current == nodeId2) {
                return true;
            }
            for (int neighbor : graph.getOrDefault(current, new HashSet<>())) {
                // Destination level 1 is an exception
                if (!visited.contains(neighbor) && !nodeLevels.get(neighbor).equals("level_1")) { 
                    visited.add(neighbor);
                    queue.add(neighbor);
                }
            }
        }

        return false;
    }

    public boolean checkFinalWin(){
        System.out.println("Checking final win");
        int minLevel = Integer.MAX_VALUE;
        boolean winOrNot = false;
        for (Node node : nodes) {
            if (node.currentOrNot) {
                int level = getLevelAsInt(node.level); 
                if (level < minLevel) {
                    minLevel = level;
                }
            }
        }
        //if the minimum clickable and current node is destination
        if(minLevel == 1){
            winOrNot = true;
        }

        return winOrNot;
    }

    private void updateCursorToClosestNode() {
        float minDist = Float.MAX_VALUE;
        int closestNodeIndex = -1;

        for (int i = 0; i < nodes.length; i++) {
            float distance = dist(mouseX, mouseY, nodes[i].position.x, nodes[i].position.y);
            if (distance < minDist) {
                minDist = distance;
                closestNodeIndex = i;
            }
        }

        if (closestNodeIndex != -1) {
            currentNodeIndex = closestNodeIndex;
            updateCursorPosition();
        }
    }
}
