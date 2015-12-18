import oscP5.*;
import netP5.*;

import ketai.net.*;
import ketai.ui.*;
import ketai.sensors.*;


OscP5 oscP5;
NetAddress myRemoteLocation;

KetaiSensor sensor;
KetaiGesture gesture;

String x;
ArrayList<Float> AValue = new ArrayList<Float>();
ArrayList<Float> GValue = new ArrayList<Float>();
ArrayList<Float> OValue = new ArrayList<Float>();

void setup() {
  oscP5 = new OscP5(this, 11001);
  myRemoteLocation = new NetAddress("192.168.1.10", 11000);
  
  gesture = new KetaiGesture(this);
  sensor = new KetaiSensor(this);
  
  for(int i = 0; i < 3; i++){
    AValue.add(new Float(0));
    GValue.add(new Float(0));
    OValue.add(new Float(0));
  }

  sensor.enableAccelerometer();
  sensor.enableGyroscope();
  //sensor.enableOrientation();
  //sensor.enableLight();
  sensor.start();

}

void draw() {  
  String info = "";
  info += "AccelerometerX:"+AValue.get(0)+"\n";
  info += "AccelerometerY:"+AValue.get(1)+"\n";
  info += "AccelerometerZ:"+AValue.get(2)+"\n";
  info += "GyroscopeX:"+GValue.get(0)+"\n";
  info += "GyroscopeY:"+GValue.get(1)+"\n";
  info += "GyroscopeZ:"+GValue.get(2)+"\n";
  //info += "OrientationX:"+OValue.get(0)+"\n";
  //info += "OrientationY:"+OValue.get(1)+"\n";
  //info += "OrientationZ:"+OValue.get(2)+"\n";

  OscMessage sendValue = new OscMessage("/left");

  // 加速度センサー
  sendValue.add(AValue.get(0));
  sendValue.add(AValue.get(1));
  sendValue.add(AValue.get(2));

  // ジャイロスコープセンサー
  sendValue.add(GValue.get(0));
  sendValue.add(GValue.get(1));
  sendValue.add(GValue.get(2));

  // 電子コンパス
  //sendValue.add(OValue.get(0));
  //sendValue.add(OValue.get(1));
  //sendValue.add(OValue.get(2));

  oscP5.send(sendValue, myRemoteLocation);
  
  background(0);
  textSize(20);
  fill(255);
  text(info,50,50);

}

void onAccelerometerEvent(float x, float y, float z){
    float AX = 0.9*GValue.get(0)+0.1*x;
    float AY = 0.9*GValue.get(1)+0.1*y;
    float AZ = 0.9*GValue.get(2)+0.1*z;
     
    AValue.set(0,AX);
    AValue.set(1,AY);
    AValue.set(2,AZ);
}
 
void onGyroscopeEvent(float x, float y, float z){
    float GX = 0.9*GValue.get(0)+0.1*x;
    float GY = 0.9*GValue.get(1)+0.1*y;
    float GZ = 0.9*GValue.get(2)+0.1*z;
     
    GValue.set(0,GX);
    GValue.set(1,GY);
    GValue.set(2,GZ);
}
 
void onOrientationEvent(float x, float y, float z){
    float OX = 0.9*OValue.get(0)+0.1*x;
    float OY = 0.9*OValue.get(1)+0.1*y;
    float OZ = 0.9*OValue.get(2)+0.1*z;
     
    OValue.set(0,OX);
    OValue.set(1,OY);
    OValue.set(2,OZ);
}