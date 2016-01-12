Capture cam;
WebCamera wc;
CustomEllipse ce;
Pen pen;

class Draw {
  
  void setup(PApplet parent) {
    colorMode(RGB);
    
    pen = new Pen();
    ce = new CustomEllipse(pen);
    wc = new WebCamera(parent, ce);
  }

  void drawTime() {
    wc.draw();
    pen.penSetup();
    wc.changeTrackingColor(pen);
  }
  
  String drawEnd() {
    String imgNum = ce.saveArt();
    wc.stop();
    
    return imgNum;
  }

}