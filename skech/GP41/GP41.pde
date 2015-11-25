/**
  upload.pde 内の
    String imgFilePath = "C:/"+imgFileName;
    String txtFilePath = "C:/"+textFileName;
  は、Processing実行環境に合わせて変更してください。
**/

import ddf.minim.*;

Minim minim;
AudioPlayer player;

int x;
int m;
PImage teamLogo;
int timer = 0;
int gamePhase;

// BGM選択
String bgm =
"groove.mp3";
//"Apple_like_CM01.mp3";
//"end of the star of the dream.mp3";
//"Good night first star.mp3";
//"Long_Way.mp3";
//"luminous_2.mp3";
//"Night sky and the city lights.mp3";
//"quickly a star in the night sky.mp3";

// アップロードするファイル名
String imgFileName = "";  // 保存したファイル名をいれてください
String textFileName = "ranking.txt";

// ランキング登録用
String playerName = "";
String point = "";

// アップロードの有無
boolean fileUpload = false;

// ランキング追加の判定
boolean rankingAdd = false;

void setup(){
 size(1024,768);
 frameRate(60);
 noStroke();
 minim = new Minim(this);
 player = minim.loadFile(bgm, 2048);
 player.loop();
}

void draw(){
  background(0);
  switch(gamePhase){
    case 0:
      reset();
      title();
      break;
    case 1:
      gameStart();
      break;
    case 2:
      gameEnd();
      fileUpload();
      break;
    case 3:
      ranking();
      break;
  }
}

// タイトル画面
void title() {
  background(0);
  teamLogo = loadImage("title.png");
  image(teamLogo, 200, 250);
  m = 360;
}

// ゲーム画面
void gameStart() {
  counter();
  textSize(30);
  text("playing",450,350,255);
  if(m < 0) {
    gamePhase = 2;
  }
}

// ゲーム終了画面
void gameEnd() {
  background(0);
  textSize(30);
  text("thank you",450,350,255);
}

// ランキング画面
void ranking(){
  background(0);
  rankingPost(playerName, point);
  gamePhase = 0;
}

// ゲーム時間表示
void counter() {
  fill(255);
  textSize(20);
  text(m/60,50,50,100);
  m -= 1;
}

// アップロード
void fileUpload(){
  if(fileUpload){
    filePost(imgFileName, textFileName);
    fileUpload = false;
  }
}

// フラグリセット
void reset(){
  if(!fileUpload) fileUpload = true;
  if(!rankingAdd) rankingAdd = true;
}

// マウスクリック時処理
void mouseClicked(){
  if(gamePhase == 0 && mouseButton == LEFT) gamePhase = 1;
  else if(mouseButton == RIGHT){
    gamePhase = 0;
    fileUpload = true;
  }
  if(gamePhase == 2 && mouseButton == LEFT) gamePhase = 3;
}