// void calculateCirclePositions() {
//   int[] circlesPerRow = {1, 3, 4, 4, 5}; // 每排的圆数配置
//   float ySpacing = height / (rows + 1); // 计算y坐标的间距
  
//   for (int i = 0; i < rows; i++) {
//     yPositions[i] = (i + 1) * ySpacing;
//     float xSpacing = width / (circlesPerRow[i] + 1); // 计算x坐标的间距
//     ArrayList<PVector> thisRow = new ArrayList<PVector>();
    
//     for (int j = 0; j < circlesPerRow[i]; j++) {
//       float x = xSpacing * (j + 1);
//       thisRow.add(new PVector(x, yPositions[i]));
//     }
//     circlePositions.add(thisRow);
//   }
// }

// void drawCirclesAndLines() {
//   staticCircles.beginDraw();
//   staticCircles.background(desertImage); // 使用沙漠背景
//   staticCircles.fill(0, 102, 153);

//   // 绘制圆
//   for (ArrayList<PVector> row : circlePositions) {
//     for (PVector circle : row) {
//       staticCircles.ellipse(circle.x, circle.y, circleDiameter, circleDiameter);
//     }
//   }

//   // 绘制连接线
//   // [此处添加连接线的绘制逻辑，根据circlePositions中的圆的位置]

//   staticCircles.endDraw();
// }
