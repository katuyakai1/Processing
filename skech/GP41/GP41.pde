/**
 upload.pde 内の
 String imgFilePath = "C:/"+imgFileName;
 は、Processing実行環境に合わせて変更してください。
 **/
import java.lang.*;
import java.util.regex.Pattern;
import java.util.regex.Matcher;
import java.util.Random;

import ddf.minim.*;

Minim minim;
AudioPlayer player;

PFont hello;
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
int imgPosX = 1000;
int imgPosY = 1000;
int moveX = 1;
int moveY = 2;
int speed = 2;
Random r = new Random();

int SPEED_THRESHOLD = 25;
int SHAKE_TIMEOUT = 500;
int SHAKE_DURATION = 200;
int SHAKE_COUNT = 1;
int mShakeCount = 0;
long mLastTime = 0;
long mLastAccel = 0;
long mLastShake = 0;
float mLastX, mLastY, mLastZ = 0;

// BGM
String[] bgm = {
  "groove.mp3", // 0
  "Apple_like_CM01.mp3", //1
  "end of the star of the dream.mp3", //2
  "Good night first star.mp3", //3
  "Long_Way.mp3", // 4
  "luminous_2.mp3", // 5
  "Night sky and the city lights.mp3", // 6
  "quickly a star in the night sky.mp3"};  //7

// アップロードするファイル名
String imgFileName = "";
String point = "";

// ランキング登録用
String playerName = "";

//ランキング必要変数
String[] keys = new String[15];
int count = 0;
int moji = 70;
int under = 73;
int underColor = 0;

// アップロードするか
boolean fileUpload = false;

// ランキングに追加するか
boolean rankingAdd = false;

void setup() {
  size(640, 480);
  frameRate(60);
  noStroke();

  // BGM使用準備
  minim = new Minim(this);
  player = minim.loadFile(bgm[0], 2048);
  player.loop();
  
  // OSC通信開始
  oscSetup();

  smooth();
  fill(255);
  hello = loadFont("BradleyHandITC-48.vlw"); 
  textFont(hello, 32);
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
void draw() {
  background(0);
  switch(gamePhase) {
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
  gm = 600;
}

/****************************
 フェーズ２  
 ****************************/
// お絵かき
void painting() {
  paintTime();
  textSize(60);
  text("painting", 400, 350, 255);
  if (m < 0) {
    gamePhase = 2;
  }
}

// お絵かき時間表示
void paintTime() {
  fill(255);
  textSize(40);
  text(m/60, 50, 50, 100);
  m -= 1;
}

/****************************
 フェーズ３
 ****************************/
// お絵かき終了
void paintEnd() {
  background(0);
  textSize(60);
  text("paint end", 400, 350, 255);
}

// ゲーム説明
void gameTitle() {
  background(0);
  textSize(60);
  text("Click start", 400, 350, 255);
}

/****************************
 フェーズ４
 ****************************/
// ゲーム画面
void gamePlay() {
  bg = loadImage("sora.jpg");
  img  = loadImage("star.png");
  image(bg, 0, 0);

  gameTime();
  gameUI();
  
  int accel = abs((int)AValue.get(0).floatValue() + (int)AValue.get(1).floatValue() + (int)AValue.get(2).floatValue());

  imgPosX += moveX * speed;
  imgPosY += moveY * speed;
  
  image(img, imgPosX, imgPosY, img.width/6, img.height/6);
  if (imgPosX < width) imgPosX = imgPosX + img.width/6;
  if (imgPosY < height)imgPosY = imgPosY + img.height/6;

  if(accel > 3){
    boolean isShaked = detectShake(AValue.get(0), AValue.get(1), AValue.get(2));
    if(isShaked){
      shake();
    }
  }

  if (gm < 0) {
    point += gamePoint;
    gamePhase = 5;
  }
}

void gameUI() {
  text("game now", 30, 40, 255);
  text(gamePoint+"pt", 170, 40, 255);
}

// ゲーム時間表示
void gameTime() {
  fill(255);
  textSize(40);
  text(gm/60, 50, 80, 100);
  gm -= 1;
}

// 端末を振った時の動作
void shake(){
  gamePoint += 10;
  imgPosX = r.nextInt(width)-50;
  imgPosY = 0;
  moveX = r.nextInt(10);
  moveY = r.nextInt(10);
}

// 端末を振ったかのチェック
boolean detectShake(float x, float y, float z){
    boolean isShaked = false;
    // 時間の確認
    long now = System.currentTimeMillis();
    if(mLastTime == 0){
        mLastTime = now;
    }
    // 時間内にさらに振られたかを確認
    if(now - mLastAccel > SHAKE_TIMEOUT){
        mShakeCount = 0;
    }
    // 速度を算出
    long diff = now - mLastTime;
    float speed = Math.abs(x + y + z - mLastX - mLastY - mLastZ) / diff * 10000;
    if(speed > SPEED_THRESHOLD){
        // 規定回数（SHAKE_COUNT）振られたかの確認
        // 前回振られた時から規定時間（SHAKE_DURATION）が経過したかの確認
        if(++mShakeCount >= SHAKE_COUNT && now - mLastShake > SHAKE_DURATION){
            mLastShake = now;
            mShakeCount = 0;
            isShaked = true;
        }
        // 規定速度（SPEED_THRESHOLD）を超える速度で端末を振られた時刻をセット
        mLastAccel = now;
    }
    mLastTime = now;
    mLastX = x;
    mLastY = y;
    mLastZ = z;
    return isShaked;
}

/****************************
 フェーズ５
 ****************************/
// ゲーム終了
void gameEnd() {
  background(0);
  textSize(60);
  text(point+"pt", 250, 250, 255);
  text("game end", 400, 350, 255);
}

/****************************
 フェーズ６
 ****************************/
// ランキング画面
void ranking() {
  //hello = loadFont("Aharoni-Bold-48Aharoni-Bold-48.vlw"); 
  //hello = loadFont("AngsanaNew-Bold-48.vlw"); 
  //hello = loadFont("AnonymousPro-Bold-48.vlw"); 
  //hello = loadFont("Arial-Black-48.vlw"); 
  //hello = loadFont("Arial-BoldMT-48.vlw"); 
  //hello = loadFont("ArialRoundedMTBold-48.vlw"); 
  //hello = loadFont("BradleyHandITC-48.vlw"); 
  //hello = loadFont("Calibri-Bold-48.vlw"); 
  //hello = loadFont("FreesiaUPC-48.vlw"); 
  //hello = loadFont("Latha-Bold-48.vlw"); 

  background(0);
  textSize(50);
  textAlign(LEFT);

  text("PlayerName", 240, 200, 255);
  text("_", under, 340, 255);

  for (int i=0; i<14; i++) {
    if (keys[i] != null) {
      text( keys[i], moji, 310, width, height);
      moji = moji + 40;
    } else {
      break;
    }
  }
  moji = 50;


  if (rankingAdd) {
    rankingPost(playerName, point);
    rankingAdd = false;
    gamePhase = 0;
  }
}

// アップロード
void fileUpload() {
  if (fileUpload) {
    filePost(imgFileName);
    fileUpload = false;
  }
}

// フラグリセット
void reset() {
  if (!fileUpload) fileUpload = true;
  gamePoint = 0;
  point = "";
  moji = 70;
  under = 53;
  playerName = "";
}

// マウスクリック時処理
void mouseClicked() {
  if (gamePhase == 0 && mouseButton == LEFT) {
    gamePhase = 1;
  } else if (gamePhase == 2 && mouseButton == LEFT) {
    gamePhase = 3;
  } else if (gamePhase == 3 && mouseButton == LEFT) {
    gamePhase = 4;
  } else if (gamePhase == 5 && mouseButton == LEFT) {
    gamePhase = 6;
  }

  if (mouseButton == RIGHT) {
    gamePhase += 1;
  }
}

/****************************
 キーイベント
 ****************************/
void keyPressed(KeyEvent e ) {
  /*
  if (gamePhase == 4) {
    String pressedKey = String.valueOf(key);
    Pattern p = Pattern.compile("[0-9a-zA-Z]");
    Matcher m = p.matcher(pressedKey);
    if (m.find()) {
      gamePoint += 10;
      imgPosX = r.nextInt(width);
      imgPosY = 0;
      moveX = r.nextInt(10);
      moveY = r.nextInt(10);
    }
  }
  */

  if (gamePhase == 6) {
    //登録処理
    if (key == ENTER) {
      for (int i=0; i<14; i++) {
        if (keys[i] != null) {
          playerName = playerName + keys[i];

          keys[i] = null;
        } else {
          break;
        }
      }

      rankingAdd = true;
    }
    //保留
    else if (key == BACKSPACE) {

      for (int i=1; i<15; i++) {
        if (keys[0] != null) {
          if (keys[i] == null) {
            int x = i - 1;
            keys[x] = null;

            if (i == 14) {
              under = 572;
            } else {
              under = under - 40;
            }

            break;
          }
        }
      }
    }
    //通常処理
    else {

      char newKeys[] = {key};
      String key = new String(newKeys);

      for (int i=0; i<14; i++) {
        if (keys[i] == null) {
          keys[i] = key;

          if (i == 13) {
            under = 1000;
          } else if (i == 12) {
            under =  572;
          } else {
            under = under + 40;
          }
          break;
        }
      }
    }
  }
}