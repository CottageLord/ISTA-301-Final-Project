/*--------- system settings ---------*/
final int noTransparency = 255;
final int canvasLength = 1024;
final int canvasHeight = 1024;
int colorMode = 1; // 0 Yellow/white; 1 colorful; 2 bomb
/*--------- user settings ----------*/
// how frequent of drawing new flower (in seconds)
final float bloomFrequency = 1;
// max flowers that can be drew simultaneously
final int maxDrawing = 2;
final int minPetal = 5;
final int maxPetal = 10;
// the size range of a petal (in pixels)
final int minPetalRange = canvasLength / 10;
final int maxPetalRange = canvasLength / 5;
// the speed that a petal can grow
final int minBloomSpeed = canvasLength / 30;
final int maxBloomSpeed = canvasLength / 20;

int[][] drawingQueue;
// [index][isDrawing x y gap speed progress petalNum ...finalPetalLengths...]
int[][][] colorTracker;
final int petalLengthIndex = 6;
void setup() 
{
  background(0);
  size(1024, 1024);
  stroke(255,255,255);
  // initialize drawing queue
  drawingQueue = new int[maxDrawing][petalLengthIndex + maxPetal + 1];
  colorTracker = new int[maxDrawing][maxPetal][3];
  for(int i = 0; i < maxDrawing; i++) {
    drawingQueue[i][0] = -1;
  }
  //printArray ();
  
}

void draw(){
  if(tryToBloom(false, false, -1, -1)) {
      printArray();
  }
}

void printArray () {
  for(int i = 0; i < maxDrawing; i++) {
    for(int j = 0; j < maxPetal + petalLengthIndex; j++) {
      print(drawingQueue[i][j] + " ");
    }
    print("\n");
  }
  
  for(int i = 0; i < maxDrawing; i++) {
    print("[");
    for(int j = 0; j < drawingQueue[i][petalLengthIndex - 1]; j++) {
      print("[");
      for(int k = 0; k < 3; k++) {
        print(colorTracker[i][j][k]+",");
      }
      print("]");
    }
    print("]\n");
  }
}
boolean tryToBloom (boolean isBomb, boolean isClicked, int mx, int my) {
  boolean okToBloom = false;
  int x, y;
  // generate bloom position
  if(isClicked){
    x = mx;
    y = my;
  } else {
    x = (int)random(maxPetalRange, canvasLength - maxPetalRange);
    y = (int)random(maxPetalRange, canvasHeight - maxPetalRange);
  }
  
  for(int i = 0; i < maxDrawing; i++) { // find space
    if(drawingQueue[i][0] == -1) {
      drawingQueue[i][0] = 1; // occupied
      okToBloom = true;
      createFlower(i, x, y, isBomb);
    }
  }
  return okToBloom;
}
  
void createFlower(int index, int x, int y, boolean isBomb){
  int petal = (int) random(5, maxPetal+1);
  float petalAngle = TWO_PI / petal;
  // [index][isDrawing x y gap speed progress petalNum ...finalPetalLengths...]
  drawingQueue[index][1] = x;
  drawingQueue[index][2] = y;
  drawingQueue[index][3] = (int)random(minBloomSpeed, maxBloomSpeed); //speed
  drawingQueue[index][4] = 0;//progress
  drawingQueue[index][5] = petal;//petalNum
  // generate all padals
  for(int i = petalLengthIndex; i < petalLengthIndex + petal; i++) {
    drawingQueue[index][i] = (int)random(minPetalRange, maxPetalRange);
    generateColors(index);
  }
  // tint(noTransparency, noTransparency/2);
}

void generateColors(int index) {
  boolean switcher = true;
  for(int i = 0; i < drawingQueue[index][5]; i++) {
    switch (colorMode) {
      case 0: // Yellow/White
        if(switcher){
          colorTracker[index][i][0] = 255;
          colorTracker[index][i][1] = 255;
          colorTracker[index][i][2] = 0;
        } else {
          colorTracker[index][i][0] = 255;
          colorTracker[index][i][1] = 255;
          colorTracker[index][i][2] = 255;
        }
        switcher = !switcher;
        break;
      case 1: // colorful
        colorTracker[index][i][0] = (int)random(noTransparency);
        colorTracker[index][i][1] = (int)random(noTransparency);
        colorTracker[index][i][2] = (int)random(noTransparency);
        break;
      case 2: // bomb (Yellow/Black)
        if(switcher){
          colorTracker[index][i][0] = 255;
          colorTracker[index][i][1] = 255;
          colorTracker[index][i][2] = 0;
        } else {
          colorTracker[index][i][0] = 0;
          colorTracker[index][i][1] = 0;
          colorTracker[index][i][2] = 0;
        }
        switcher = !switcher;
        break;
      default:
        break;
    }
  }
}
