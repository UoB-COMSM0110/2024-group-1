Button[] buttons;
boolean displayTextBox = false;

void setup() {
  size(960, 820);
  background(0);
  
  // Initialize Button
  buttons = new Button[3];
  buttons[0] = new Button(50, 50, 100, 50, "Back");
  buttons[1] = new Button(50, 150, 100, 50, "Start Menu");
  buttons[2] = new Button(50, 250, 100, 50, "Tutorial");
  
  //Initialize Material
  desertImage = loadImage("MapBackground.jpg"); 
  
  //Initialize Map nodes visual elements  
  staticCircles = createGraphics(embeddedCanvasWidth, contentHeight);
  staticCircles.beginDraw();
  staticCircles.clear(); // Make the background transparent
  staticCircles.fill(0, 47, 167); // Set the color of node
  
  //Draw nodes on staticCircles
  float minDistance = 30; 
  float diameter = 30;
  for (int i = 5; i > 0; i--) { 
    ArrayList<PVector> row = new ArrayList<PVector>();
    int circlesInRow = int(random(1, 5)); 
    float sectionWidth = (embeddedCanvasWidth - (circlesInRow + 1) * minDistance) / circlesInRow;
    for (int j = 0; j < circlesInRow; j++) { 
      float xStart = minDistance + j * (sectionWidth + minDistance); // Start point of segments
      float x = random(xStart, xStart + sectionWidth); // chose Xpos in segments randomly
      float y = i * (contentHeight / 7.0) + (contentHeight / 7.0) / 2; // Calculate Ypos
      staticCircles.ellipse(x,y,diameter, diameter );
      row.add(new PVector(x, y)); // Add postion to current row
    }
    circlesByRow.add(row);//Add current row to a row list
  }

  // Fix the top and bottom
  staticCircles.ellipse(embeddedCanvasWidth/2.0, 0 * (contentHeight / 7.0) + (contentHeight / 7.0) / 2, diameter, diameter);
  ArrayList<PVector> topRow = new ArrayList<PVector>();
  topRow.add(new PVector(embeddedCanvasWidth/2.0, 0 * (contentHeight / 7.0) + (contentHeight / 7.0) / 2));
  circlesByRow.add(0, topRow); 

  int circlesAtBottom = 3; 
  ArrayList<PVector> bottomRow = new ArrayList<PVector>();
  float bottomSectionWidth = embeddedCanvasWidth / (circlesAtBottom + 1); // Divide into segments
  for (int i = 1; i <= circlesAtBottom; i++) {
    float x = i * bottomSectionWidth; // Calculate the Xpos_bottom
    staticCircles.ellipse(x, 6 * (contentHeight / 7.0) + (contentHeight / 7.0) / 2, diameter, diameter); 
    bottomRow.add(new PVector(x, 6 * (contentHeight / 7.0) + (contentHeight / 7.0) / 2));
  }
  circlesByRow.add(bottomRow);

  // 设置连接线的颜色
  staticCircles.stroke(255); // 使用白色绘制连接线

  // 由于是从第一排向下连接，我们从第二排开始遍历每一排
  for (int i = 1; i < circlesByRow.size(); i++) {
      ArrayList<PVector> currentRow = circlesByRow.get(i); // 当前排的圆
      ArrayList<PVector> previousRow = circlesByRow.get(i - 1); // 上一排的圆

      for (PVector circle : currentRow) {
          // 由于规则限制，每个圆只能与上一排的一个圆连接
          PVector closest = null; // 找到最近的圆
          float closestDist = Float.MAX_VALUE; // 初始化最近距离为最大值

          // 遍历上一排的每个圆，找到最近的圆
          for (PVector prevCircle : previousRow) {
              float dist = PVector.dist(circle, prevCircle);
              if (dist < closestDist) {
                  closestDist = dist;
                  closest = prevCircle;
              }
          }

          // 绘制连接线，从最近的上一排圆连接到当前圆
          if (closest != null) {
              staticCircles.line(closest.x, closest.y, circle.x, circle.y);
          }
      }
  }


  staticCircles.endDraw();
}

void draw() {
  //background(0); // Refresh Screen
  // Draw Button
  for (int i = 0; i < buttons.length; i++) {
    buttons[i].display();
  }
  
  // Draw Status Information
  drawStatusInfo();
 
  // Draw Map
  drawEmbeddedCanvas();
  
  // If Tutorial button clicked show text 
  if (displayTextBox) {
    drawTextBox();
  }
}

void drawStatusInfo() {
  // Draw Health Point
  fill(255, 0, 0);
  ellipse(870, 50, 30, 30); // Red shape
  fill(255);
  textSize(12);
  textAlign(RIGHT, CENTER);
  text("HP 70/70", 850, 50); // HP value info
  
  // Draw Move Point
  fill(0, 255, 0);
  ellipse(870, 90, 30, 30); // Green shape
  fill(255);
  text("MP 01/18", 850, 90); // MP value info
}

void drawTextBox() {
  fill(255);
  rect(325, 300, 300, 100); 
  textAlign(LEFT, TOP);
  fill(0);
  String textContent = "Scroll down or using ↑/↓ on keyboard to preview the route to top of Tower;\nClick to choose the start node or next node;\nUsing move point to move up;\nDouble click to close Tutorial.";
  text(textContent, 325, 300, 300, 100); 
}




