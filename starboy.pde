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

int COLORS[7] = {RED, YELLOW, GREEN, BLUE, CYAN, PURPLE, WHITE};

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
}

void loop() {
  
  /* Good */
  
  //cylon(getRandomColor(), 15, 100);

  //noise(getRandomColor(), 0, 100, 50);
  
  rasta(50, 50);
  
  /* broke */
  
  //grid();
  
  //theMatrix(GREEN, 50); // not working
  
  //snake(GREEN, 50, 100); // not working

  //tom(WHITE, 50); // not working

  
  //totallyRandom(5000);
  
  //blinkRandomColors(50, 25);
  
  //blinkColor(GREEN, 50, 25);
  
  //diagonalRainbowScroll(50, 50);
  
  
  
}
