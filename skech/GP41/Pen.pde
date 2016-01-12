class Pen {
 
  String colorName = "red";
  
  int r = 255;
  int g = 0;
  int b = 0;
  
  int penSize  = 20;

  void penSetup() {
    String[] lines = loadStrings("data/pen_status.txt");
    String[] status = split(lines[0], ",");
   
    this.setPenColor(status[0].trim());
    this.penSize = Integer.parseInt(status[1].trim());
  }  
  
  void setPenColor(String colorName) {
    if (colorName.equals("red")) {
      this.colorName = "red";
      setRGB(255, 0, 0);
    } else if (colorName.equals("blue")) {
      this.colorName = "blue";
      setRGB(0, 0, 255);
    } else if (colorName.equals("green")) {
      this.colorName = "green";
      setRGB(0, 255, 0);
    } else if (colorName.equals("yellow")) {
      this.colorName = "yellow";
      setRGB(255, 255, 0);
    }
  }
  
  void setRGB(int r, int g, int b) {
    this.r = r;
    this.g = g;
    this.b = b;
  }
  
}