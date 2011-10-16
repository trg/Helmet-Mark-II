#include <TimerOne.h>

#define LATCH_PIN 10 // BLUE
#define CLOCK_PIN 11 // YELLOW
#define DATA_PIN 12 // GREEN

#define TOTAL_ROWS 8
#define TOTAL_COLS 16    

#define ON true
#define OFF false

#define RED   0x01
#define GREEN 0x02
#define BLUE  0x04

#define OFF_BYTE 0x00 // Used to turn LED to off in updateBuffer

#define BUFFER_SIZE (TOTAL_ROWS * TOTAL_COLS)

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
  
  clearDisplay();

  setLED(0, 2, GREEN, ON);
  
  setLED(4, 2, BLUE, ON);
  
  setLED(4, 0, RED, ON);
  
  setLED(13, 0, RED|BLUE|GREEN, ON);
  
  setLED(14, 2, RED|GREEN, ON);
  
  delay(50);

}
