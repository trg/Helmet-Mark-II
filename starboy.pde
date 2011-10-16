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

#define WHITE RED|GREEN|BLUE

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
  
  //grid();
  
  //theMatrix(GREEN, 50);
  
  //snake(GREEN, 50, 100);
  
  //cylon(RED, 15, 100);

  noise(GREEN, 0, 100, 50);


}
