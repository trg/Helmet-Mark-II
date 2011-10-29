#include <TimerOne.h>

#define LATCH_PIN 10 // BLUE
#define CLOCK_PIN 11 // YELLOW
#define DATA_PIN 12 // GREEN

#define MAX_X 8
#define MAX_Y 16    

#define ON true
#define OFF false

#define RED   0x01
#define GREEN 0x02
#define BLUE  0x04
#define YELLOW RED|GREEN
#define PURPLE RED|BLUE
#define CYAN GREEN|BLUE
#define WHITE RED|GREEN|BLUE

byte COLORS[7] = {RED, YELLOW, GREEN, BLUE, CYAN, PURPLE, WHITE};

#define OFF_BYTE 0x00 // Used to turn LED to off in updateBuffer

#define BUFFER_SIZE (MAX_X * MAX_Y)

unsigned int TIMER_PERIOD = 10000;

void setup() {
  
  Serial.begin(9600);
  
  pinMode(DATA_PIN, OUTPUT);
  pinMode(LATCH_PIN, OUTPUT);
  pinMode(CLOCK_PIN, OUTPUT);
  
  Timer1.initialize(TIMER_PERIOD);
  Timer1.attachInterrupt(drawBufferContents);
  
  randomSeed(analogRead(0));
}

void loop() {
  
  
  /* Good */
  
  //*
  
  switch(random(10)) {
    case 0:
    cylon(RED, 5, 200);
    break;
    
    case 1:
    noise(getRandomColor(), 0, 30, 50);
    break;
    
    case 2:
    throughTheVoid(getRandomNonWhiteColor(), 30, 25);
    break;
    
    case 3:
    rasta(25, 10);
    break;
    
    case 4:
    fallingRain(getRandomColor(), 3, 50);
    break;
    
    case 5:
    waveFromCenter(getRandomNonWhiteColor(), 30, 4*3);
    break;
    
    case 6:
    fillingBalls(getRandomColor(), 3, 1000);
    break;
    
    case 7:
    crazyRain(3, 25, COLORS, 6);
    break;
    
    case 8:
    for( int i = 0; i < 3; i++)
      fallingRows(getRandomColor(), 15);
    break;
    
    case 9:
    equalizer(getRandomColor(), 50, 500);
    break;
    
  }


  
  

  
  
  
  
  
  
  
  
  
  /* work, but not that cool */
  
  //drawSquares(50, 25);
  
  //mario();
  
  //totallyRandom(500);
  
  //blinkRandomColors(50, 25);
  
  //diagonalRainbowScroll(50, 50);
  
  
  
  
  
  /* work but pretty badly 
  
  blinkEyes(100, 50);
  
  blinkColor(WHITE, 50, 25);
  
  marchingColorLines(10, 500);
  
  */
  
  
  /* broken */
  
  //grid();
  
  //theMatrix(GREEN, 50); // not working
  
  //snake(GREEN, 50, 100); // not working

  //tom(WHITE, 50); // not working

  // connectFour(RED, BLUE, 50);
  
  
  
  
}
