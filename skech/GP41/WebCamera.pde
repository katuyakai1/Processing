import processing.video.*;

class WebCamera {

  Capture cap;
  CustomEllipse ce;
  
  int defaultFrameRate = 60;
  int cameraFrameRate  = 30;
  
  int drawTime = defaultFrameRate / cameraFrameRate;
  int countTime = 0;

  /* use this->tracking */
  HashMap<String, Integer> targetColor = new HashMap<String, Integer>();    
  HashMap<String, Integer> colorRange = new HashMap<String, Integer>();

  WebCamera(PApplet parent, CustomEllipse ce) {
    
    /* Capture Setup */
    this.ce = ce;

    String[] caps = Capture.list();
        
    cap = new Capture(parent, 640, 480, caps[0], 30);
    cap.start();
    
    targetColor.put("r", 205);
    targetColor.put("g", 50);
    targetColor.put("b", 60);
    
    colorRange.put("r", 20);
    colorRange.put("g", 20);
    colorRange.put("b", 20);
  }
  
  void draw() {
    if (!this.isCameraFrame()) {
      return;
    }

    if (cap.available()) {
      cap.read();
    }

    /* Flip Horizontal */
    translate(width, 0);
    scale(-1, 1);
    
    image(cap, 0, 0, width, height);
        
    this.tracking();
    
    ce.drawShape();
  }
  
  void stop() {
    this.cap.stop();
    this.ce.clearShapes();
    
    translate(width, 0);
    scale(0, 0);
    
    background(255, 255, 255);
  }
  
  void tracking() {
    cap.loadPixels();

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        int pixel = get(x, y);
        
        float r = red(pixel);
        float g = green(pixel);
        float b = blue(pixel);
        
        if (!this.isTrackingColor("r", r)) {
          continue;
        } else if (!this.isTrackingColor("g", g)) {
          continue;
        } else if (!this.isTrackingColor("b", b)) {
          continue;
        }
        
        int shapeX = width - x;

        ce.addShape(shapeX, y, (int) r, (int) g, (int) b); // Ellipse
        
        return;        
      }
    }
  }

  boolean isTrackingColor(String rgb, float colorAmount) {
    if (colorAmount < (targetColor.get(rgb) - colorRange.get(rgb))) {
      return false;
    } else if (colorAmount > (targetColor.get(rgb) + colorRange.get(rgb))) {
      return false;
    }

    return true;
  }
  
  void changeTrackingColor(Pen pen) {
    String penColor = pen.colorName;    
    
    int r = 0, g = 0, b = 0;
    int rangeR = 20, rangeG = 20, rangeB = 20;
    
    if (penColor.equals("red")) {
      r = 255;
      g = 80;
      b = 30;
      
      rangeR = 10;
      rangeG = 20;
      rangeB = 40;
    } else if (penColor.equals("green")) {
      r = 10;
      g = 130;
      b = 10;
      
      rangeR = 10;
      rangeG = 30;
      rangeB = 30;
    } else if (penColor.equals("blue")) {
      r = 10;
      g = 100;
      b = 255; 

      rangeR = 30;
      rangeG = 40;
      rangeB = 20;
    }
    
    targetColor.put("r", r);
    targetColor.put("g", g);
    targetColor.put("b", b);
    
    colorRange.put("r", rangeR);
    colorRange.put("g", rangeG);
    colorRange.put("b", rangeB);
  }
  
  boolean isCameraFrame() {
    if (countTime < drawTime) {
      countTime++;
      return false;
    }
        
    countTime = 0;
    
    return true;
  }

}