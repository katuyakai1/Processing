/**
  upload.pde 内の
    String imgFilePath = "C:/"+imgFileName;
  は、Processing実行環境に合わせて変更してください。
**/
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.Random;

import ddf.minim.*;

Minim minim;
AudioPlayer player;

int x;
int m;
PImage teamLogo;
int timer = 0;
int gamePhase = 0;

// ゲームで使用
int gm;
PImage img;
PImage bg;
int gamePoint;
int imgPosX = 0;
int imgPosY = 0;
int moveX = 1;
int moveY = 1;
int speed = 1;
Random r = new Random();

// BGM
String[] bgm = {
"groove.mp3",  // 0
"Apple_like_CM01.mp3",  //1
"end of the star of the dream.mp3",  //2
"Good night first star.mp3",  //3
"Long_Way.mp3",  // 4
"luminous_2.mp3",  // 5
"Night sky and the city lights.mp3",  // 6
"quickly a star in the night sky.mp3"};  //7

// アップロードするファイル名
String imgFileName = "";  // 保存した画像ファイル名をいれてください
String point = "";

// ランキング登録用
String playerName = "";

// アップロードするか
boolean fileUpload = false;

// ランキングに追加するか
boolean rankingAdd = false;

void setup(){
 size(640,480);
 frameRate(60);
 noStroke();
 
 // BGM使用準備
 minim = new Minim(this);
 player = minim.loadFile(bgm[0], 2048);
 player.loop();
}

/* 
  メイン
  -- ループの流れ --
  0：タイトル
  1：お絵かき
  2：お絵かき終了
  3：ゲーム説明画面
  4：ゲーム画面
  5：ゲーム終了画面
  6：ランキング画面
*/
void draw(){
  background(0);
  switch(gamePhase){
    case 0:
      reset();
      title();
      break;
    case 1:
      painting();
      break;
    case 2:
      paintEnd();
      fileUpload();
      break;
    case 3:
      gameTitle();
      break;
    case 4:
      gamePlay();
      break;
    case 5:
      gameEnd();
      break;
    case 6:
      ranking();
      break;
  }
}

/****************************
  フェーズ１
****************************/
// タイトル
void title() {
  background(0);
  teamLogo = loadImage("title.png");
  image(teamLogo, 35, 150, teamLogo.width*0.8, teamLogo.height*0.8);
  m = 3600;
  gm = 5940;
}

/****************************
  フェーズ２  
****************************/
// お絵かき
void painting() {
  paintTime();
  textSize(30);
  text("painting",450,350,255);
  if(m < 0) {
    gamePhase = 2;
  }
}

// お絵かき時間表示
void paintTime() {
  fill(255);
  textSize(20);
  text(m/60,50,50,100);
  m -= 1;
}

/****************************
  フェーズ３
****************************/
// お絵かき終了
void paintEnd() {
  background(0);
  textSize(30);
  text("paint end",450,350,255);
}

// ゲーム説明
void gameTitle(){
  background(0);
  textSize(30);
  text("Click start",450,350,255);
}

/****************************
  フェーズ４
****************************/
// ゲーム画面
void gamePlay(){
  bg = loadImage("sora.jpg");
  img  = loadImage("star.png");
  
  imgPosX += moveX * speed;
  imgPosY += moveY * speed;
  
  image(bg,0,0);
  
  gameTime();
  gameUI();
  
  image(img,imgPosX,imgPosY,img.width/4, img.height/4);
  if(imgPosX < width) imgPosX = imgPosX + img.width/4;
  if(imgPosY < height)imgPosY = imgPosY + img.height/4;
  
  if(gm < 0) {
    gamePhase = 5;
  }
}

void gameUI(){
  text("game now",10,20,255);
  text(gamePoint+"pt", 150,20,255);
}

// ゲーム時間表示
void gameTime() {
  fill(255);
  textSize(20);
  text(gm/60,50,50,100);
  gm -= 1;
}

/****************************
  フェーズ５
****************************/
// ゲーム終了
void gameEnd() {
  background(0);
  textSize(30);
  text(gamePoint+"pt",200,200,255);
  text("game end",450,350,255);
}

/****************************
  フェーズ６
****************************/
// ランキング画面
void ranking(){
  if(rankingAdd){
    background(0);
    point = String.valueOf(gamePoint);
    rankingPost(playerName, point);
    gamePhase = 0;
  }
}

// アップロード
void fileUpload(){
  if(fileUpload){
    filePost(imgFileName);
    fileUpload = false;
  }
}

// フラグリセット
void reset(){
  if(!fileUpload) fileUpload = true;
  if(!rankingAdd) rankingAdd = true;
  gamePoint = 0;
  point = "";
}

// マウスクリック時処理
void mouseClicked(){
  if(gamePhase == 0 && mouseButton == LEFT) {
    gamePhase = 1;
  } else if(gamePhase == 2 && mouseButton == LEFT){
    gamePhase = 3;
  } else if(gamePhase == 3 && mouseButton == LEFT){
    gamePhase = 4;
  }

  if(mouseButton == RIGHT){
    gamePhase += 1;
  }
}

/****************************
  ゲーム画面で動作するキーイベント
****************************/
void keyPressed(KeyEvent e ){
  if(gamePhase == 4){
    String pressedKey = String.valueOf(key);
    Pattern p = Pattern.compile("[0-9a-zA-Z]");
    Matcher m = p.matcher(pressedKey);
    if(m.find()){
      gamePoint += 10;
      imgPosX = r.nextInt(width);
      imgPosY = 0;
      moveX = r.nextInt(10);
      moveY = r.nextInt(10);
    }
  }
}