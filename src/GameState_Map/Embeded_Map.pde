// The visible dimensions of the embedded canvas
int embeddedCanvasWidth = 500;
int embeddedCanvasHeight = 650;

// The content height of the embedded canvas is taller than its actual height, allowing for scrolling
int contentHeight = 1200;

void drawEmbeddedCanvas() {
  // Set the visible range of the embedded canvas based on the scroll offset
  int canvasX = width/2 - embeddedCanvasWidth/2;
  int canvasY = height/2 - embeddedCanvasHeight/2;
    
  // Save the current drawing state
  pushMatrix();
  pushStyle();
  
  // Set the clipping area to only display a portion of the embedded canvas's content
  clip(canvasX, canvasY, embeddedCanvasWidth, embeddedCanvasHeight);
  
  // Draw the actual content
  //translate(canvasX, canvasY - scrollOffset);
  //fill(200);
  //rect(0, 0, embeddedCanvasWidth, contentHeight); // Assume the content is a gray rectangle
  
  // Display the corresponding part of the image based on the scroll offset
  image(desertImage, canvasX, canvasY - scrollOffset, embeddedCanvasWidth, desertImage.height);
  // 根据滚动偏移量调整staticCircles的位置并显示
  image(staticCircles, canvasX, canvasY - scrollOffset);
  // Restore the previous drawing state
  popStyle();
  popMatrix();
}
