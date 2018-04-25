int gameScreen = 0;
float gravity = 1;

//ball parameters
float ballSpeedVert = 0;
float ballSpeedHorizon = 10;
float ballX, ballY;
float ballSize = 20;
float ballColor = color(0);

//air friction parameters
float k=0.9;
float friction=0.1;
float airfriction = 0.0001;

//racket parameters
color racketColor = color(0);
float racketWidth = 100;
float racketHeight = 10;

int wallSpeed = 5;
int wallInterval = 1000;
float lastAddTime = 0;
int minGapHeight = 200;
int maxGapHeight = 300;
int wallWidth = 80;
color wallColors = color(0);
//==========================================================
ArrayList<int[]> walls = new ArrayList<int[]>();

void setup() {
  size(500, 500);
  background(255);
  ballX=width/4;
  ballY=height/5;
}

void draw() {
  // Display the contents of the current screen
  if (gameScreen == 0) {
    initScreen();
  } else if (gameScreen == 1) {
    gameScreen();
  } else if (gameScreen == 2) {
    gameOverScreen();
  }
}

void initScreen() {
  background(0);
  textAlign(CENTER);
  text("Click to start", height/2, width/2);
}

void gameOverScreen() {
  // codes for game over screen
}

public void mousePressed() {
  // if we are on the initial screen when clicked, start the game
  if (gameScreen==0) {
    startGame();
  }
}

void startGame() {
  gameScreen=1;
}

void gameScreen() {
  background(255);
  drawBall();
  applyGravity();
  keepInScreen();
  drawRacket();
  watchRacketBounce();
  applyHorizontalSpeed();
  wallAdder();
  //wallHandler();

}

void wallAdder() {
  if (millis()-lastAddTime > wallInterval) {
    int randHeight = round(random(minGapHeight, maxGapHeight));
    int randY = round(random(0, height-randHeight));
    // {gapWallX, gapWallY, gapWallWidth, gapWallHeight}
    int[] randWall = {width, randY, wallWidth, randHeight}; 
    walls.add(randWall);
    lastAddTime = millis();
      }
}

//void wallHandler() {
//  for (int i = 0; i < walls.size(); i++) {
//    wallRemover(i);
//    wallMover(i);
//    wallDrawer(i);7
    
//  }
//}
void applyHorizontalSpeed(){
  ballX += ballSpeedHorizon;
  ballSpeedHorizon -= (ballSpeedHorizon * airfriction);
}


// RACKET BOUNCE
void watchRacketBounce() {
  float overhead = mouseY - pmouseY;
  if ((ballX+(ballSize/2) > mouseX-(racketWidth/2)) && (ballX-(ballSize/2) < mouseX+(racketWidth/2))) {
     if (dist(ballX, ballY, ballX, mouseY)<=(ballSize/2)+abs(overhead)) {
        makeBounceBottom(mouseY);
        ballSpeedHorizon = (ballX - mouseX)/5;
        ballY+=overhead;
        ballSpeedVert+=overhead;
    }
  }
}

void drawRacket(){
  fill(racketColor);
  rectMode(CENTER);
  rect(mouseX, mouseY, racketWidth, racketHeight);
}

void drawBall() {
  fill(ballColor);
  ellipse(ballX, ballY, ballSize, ballSize);
}

void applyGravity() {
  ballSpeedVert += gravity;
  ballY += ballSpeedVert;
  ballSpeedVert -= (ballSpeedVert * airfriction);
}


// BOUNDARIES 
void makeBounceBottom(float surface) {
  ballY = surface-(ballSize/2);
  ballSpeedVert*=-k;
}

void makeBounceTop(float surface) {
  ballY = surface+(ballSize/2);
  ballSpeedVert*=-k;
}

void makeBounceLeft(float surface){
  ballX = surface+(ballSize/2);
  ballSpeedHorizon*=-k;

}

void makeBounceRight(float surface){
  ballX = surface-(ballSize/2);
  ballSpeedHorizon*=-k;

}

void keepInScreen() {
  // ball hits floor
  if (ballY+(ballSize/2) > height) { 
    makeBounceBottom(height);
  }
  // ball hits ceiling
  if (ballY-(ballSize/2) < 0) {
    makeBounceTop(0);
  }
  if (ballX-(ballSize/2) < 0){
    makeBounceLeft(0);
  }
  if (ballX+(ballSize/2) > width){
    makeBounceRight(width);
  }  
}
