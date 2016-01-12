class CustomEllipse {

  ArrayList<int[]> shapes = new ArrayList<int[]>();
  Pen pen;

  CustomEllipse(Pen pen) {
    noStroke();
    this.pen = pen;
  }

  void addShape(int x, int y, int r, int g, int b) {
    int shape[] = {x, y, r, g, b, pen.penSize};
    shapes.add(shape);
  }
  
  void drawShape() {
    int len = shapes.size();

    for (int i = 0; i < len; i++) {
      int shape[] = shapes.get(i);
      
      fill(shape[2], shape[3], shape[4]);      
      ellipse(shape[0], shape[1], shape[5], shape[5]);
    }
  }
  
  void clearShapes() {
    this.shapes.clear();
  }
  
  String saveArt() {
    String[] lines = loadStrings("data/art_number.txt");
    int number = Integer.parseInt(lines[0].trim());
    String strNumber = str(number);

    saveGameArt("data/" + strNumber + "_game.png");
    saveWebArt("data/" + strNumber + "_web.png");
    
    number++;
    
    lines[0] = str(number);
    
    saveStrings("data/art_number.txt", lines);
    
    return strNumber;
  }
  
  void saveGameArt(String fileName) {
    int shapeSize = this.shapes.size();
    
    int baseX = width;
    int baseY = height;
    
    int maxX = 1;
    int maxY = 1;
        
    for (int i = 0; i < shapeSize; i++) {
      int shape[] = this.shapes.get(i);
      
      if ((width - shape[0]) < baseX) {
        baseX = width - shape[0];
      }
      
      if ((width - shape[0]) > maxX) {
        maxX = width - shape[0] + shape[5];
      }
      
      if (shape[1] < baseY) {
        baseY = shape[1];
      }
      
      if (shape[1] > maxY) {
        maxY = shape[1] + shape[5];
      }
    }
        
    int artSizeX = maxX - baseX;
    int artSizeY = maxY - baseY;

    PGraphics art = createGraphics(artSizeX, artSizeY);
    
    art.beginDraw();
    
    art.background(255, 255, 255, 0);
    art.noStroke();
    
    for (int i =0; i < shapeSize; i++) {
      int shape[] = this.shapes.get(i);
      
      art.fill(shape[2], shape[3], shape[4]);
      
      int shapeX = width - shape[0] - baseX + shape[5] / 2;
      int shapeY = shape[1] - baseY + shape[5] / 2;
      
      art.ellipse(shapeX, shapeY, shape[5], shape[5]);
    }
    
    art.endDraw();
    art.save(fileName);
  }
  
  void saveWebArt(String fileName) {
    int shapeSize = this.shapes.size();
        
    PGraphics art = createGraphics(width, height);
    
    art.beginDraw();
    
    art.background(255, 255, 255, 0);
    art.noStroke();

    for (int i =0; i < shapeSize; i++) {
      int shape[] = this.shapes.get(i);
      
      art.fill(shape[2], shape[3], shape[4]);
      
      int shapeX = width - shape[0] + (shape[5] / 2);
      int shapeY = shape[1] + (shape[5] / 2);
      
      art.ellipse(shapeX, shapeY, shape[5], shape[5]);
    }
    
    art.endDraw();
    art.save(fileName);
  }
  
}