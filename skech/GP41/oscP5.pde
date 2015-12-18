import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

ArrayList<Float> AValue = new ArrayList<Float>();
ArrayList<Float> GValue = new ArrayList<Float>();
ArrayList<Float> OValue = new ArrayList<Float>();

void oscSetup(){  
  for(int i = 0; i < 3; i++){
    AValue.add(new Float(0));
    GValue.add(new Float(0));
    OValue.add(new Float(0));
  }

  oscP5 = new OscP5(this, 11000);
  myRemoteLocation = new NetAddress("192.168.1.185.", 11001);// ip"192.168.1.185" with HTC Hotspot
  oscP5.plug(this, "levell", "left");
  oscP5.plug(this, "levelr", "/right");
}

void oscEvent(OscMessage theOscMessage) {

  if (theOscMessage.checkAddrPattern("/left")==true) {
    AValue.set(0,theOscMessage.get(0).floatValue());
    AValue.set(1,theOscMessage.get(1).floatValue());
    AValue.set(2,theOscMessage.get(2).floatValue());
  }

}