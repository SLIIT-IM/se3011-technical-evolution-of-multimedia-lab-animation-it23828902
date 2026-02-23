//game variables
int state=0;
int startTime;
int duration=30;
int score=0;

//player variables
float px=350,py=175;
float step=6;
float pr=20;

//helper variables
float hx,hy;
float ease=0.10;

// orb variables
float ox,oy;
float oxs=4,oys=3;
float or=20;

//trail toggle
boolean trails=false;

void setup() {
  size(700,350);
  px= width/2;
  py=height/2;
  hx=px;
  hy=py;
  resetOrb();
}

void draw() {
  if (!trails) {
    background(255);
  } else {
    noStroke();
    fill(255,35);
    rect(0,0,width,height);
  }
  
  //start screen
  if (state==0) {
    drawStartScreen();
  }
  
  //play screen
  if (state==1) {
    playGame();
  }
  
  //end screen
  if (state==2) {
    drawEndScreen();
  }
  
  //train on or off
  fill(0);
  textSize(12);
  text("Trails: "+(trails?"ON":"OFF")+"(Press T)",20,height-20);
}

void drawStartScreen() {
  textAlign(CENTER,CENTER);
  textSize(24);
  fill(0);
  text("Catch the Orb",width/2,height/2 - 40);
  textSize(18);
  text("Press -Enter- to Start",width/2,height/2 + 20);
  textSize(14);
  text("Use arrow keys to move | T to toggle trails",width/2, height/2 + 50);
}

void playGame() {
  //calculate remaining time
  int elapsed=(millis()-startTime)/1000;
  int left=duration-elapsed;
  
  //check if time is up
  if(left<=0) {
    state=2;
    return;
  }
  
  //move orb
  ox+=oxs;
  oy+=oys;
  
  //bounce orb
  if (ox>width-or||ox<or)oxs*=-1;
  if (oy>height-or||oy<or)oys*=-1;
  
  // Player movement with arrow keys
  if (keyPressed) {
    if (keyCode==RIGHT)px+=step;
    if (keyCode==LEFT)px-=step;
    if (keyCode==DOWN)py+=step;
    if (keyCode==UP)py-=step;
  }
  
  //keep player in screen
  px=constrain(px,pr,width-pr);
  py=constrain(py,pr,height-pr);
  
  //helper easing
  hx=hx+(px - hx)*ease;
  hy=hy+(py - hy)*ease;
  
  //check collision
  float distance=dist(px,py,ox,oy);
  if (distance<pr+or) {
    score++;
    resetOrb();
    oxs*=1.1;
    oys*=1.1;
  }
  
  //draw all
  drawGameElements(left);
}

void drawGameElements(int timeLeft) {
  //draw orb
  fill(255,120,80);
  ellipse(ox,oy,or*2,or*2);
  
  //draw helper (green)
  fill(80,200,120);
  ellipse(hx,hy,16,16);
  
  //draw player (blue)
  fill(60,120,200);
  ellipse(px,py,pr*2,pr*2);
  
  //draw UI
  fill(0);
  textAlign(LEFT,TOP);
  textSize(16);
  text("Time Left: "+timeLeft, 20, 20);
  text("Score: "+score, 20, 45);
}

void drawEndScreen() {
  textAlign(CENTER,CENTER);
  textSize(24);
  fill(0);
  text("GAME OVER",width/2,height/2-40);
  textSize(18);
  text("Final Score: "+score,width/2,height/2);
  text("Press R to Restart",width/2,height/2+40);
}

void resetOrb() {
  ox=random(or,width-or);
  oy=random(or,height-or);
}

void keyPressed() {
  if (key=='t'||key=='T') {
    trails=!trails;
  }
  
  if (state==0 && keyCode==ENTER) {
    state=1;
    startTime=millis();
    score=0;
    oxs=4;
    oys=3;
    resetOrb();
    px=width/2;
    py=height/2;
    hx=px;
    hy=py;
  }
  
  //restart game from end screen
  if (state==2 && (key=='r'||key=='R')) {
    state=0;
    trails=false;
  }
}
