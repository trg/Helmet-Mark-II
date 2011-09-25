#include <TimerOne.h>

#define LATCH_PIN 10
#define CLOCK_PIN 11
#define DATA_PIN 12

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

uint8_t displayBuffer[BUFFER_SIZE];


void drawBufferContents() {
  
  uint8_t* pixel = displayBuffer;

  uint8_t rowOn = 1;
  uint8_t rowOn2 = 1;
  
  uint8_t colROn = 0;
  uint8_t colGOn = 0;
  uint8_t colBOn = 0;
  
  uint8_t colROn2 = 0;
  uint8_t colGOn2 = 0;
  uint8_t colBOn2 = 0;

  for(byte r1 = 0; r1 < TOTAL_ROWS; r1++) {
    
    colROn = 0; colGOn = 0; colBOn = 0;
    
    for (byte c1 = 0; c1 < 8; c1++) {
        
        colROn |= *pixel & RED   ? _BV(c1) : 0;
        colGOn |= *pixel & GREEN ? _BV(c1) : 0;
        colBOn |= *pixel & BLUE  ? _BV(c1) : 0;

        *pixel++;
    }
    
    colROn2 = 0; colGOn2 = 0; colBOn2 = 0;
    
    //for (byte c2 = 8; c2 < TOTAL_COLS; c2++) {
    for (byte c2 = 0; c2 < 8; c2++) {   
        colROn2 |= *pixel & RED   ? _BV(c2) : 0;
        colGOn2 |= *pixel & GREEN ? _BV(c2) : 0;
        colBOn2 |= *pixel & BLUE  ? _BV(c2) : 0;

        *pixel++;
    }
    
    digitalWrite(LATCH_PIN, LOW); 
    
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST,  rowOn2);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~colGOn2);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~colROn2);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~colBOn2);

    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST,  rowOn);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~colGOn);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~colROn);
    shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~colBOn);
    
    digitalWrite(LATCH_PIN, HIGH);
    
    rowOn <<= 1;
    rowOn2 <<= 1;
  }

  digitalWrite(LATCH_PIN, LOW); 

  shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST,  0x00); // Row (ground)
  shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~0x00); // Green
  shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~0x00); // Red
  shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~0x00); // Blue

  shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST,  0x00); // Row (ground)
  shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~0x00); // Green
  shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~0x00); // Red
  shiftOut(DATA_PIN, CLOCK_PIN, MSBFIRST, ~0x00); // Blue

  digitalWrite(LATCH_PIN, HIGH);
}

int getDisplayBufferIndex(int row, int col) {
  return (row * TOTAL_COLS) + col;
}

void setLED(int x, int y, byte color, boolean on) {
  
  int new_x, new_y;
  
  if ( x < 8 ) {

    new_x = 15 - y;
    new_y = 7 - x;
    
  } else {

    new_x = 7 - y;
    new_y = 15 - x; 
  }
  
  int i = getDisplayBufferIndex(new_y, new_x);
  
  displayBuffer[i] = on ? (displayBuffer[i] | color) : (displayBuffer[i] & ~color);
}

uint8_t* getLED(int row, int col) {
  
  return &displayBuffer[getDisplayBufferIndex(row, col)];
}

void setCol(int col, byte color, boolean on) {

  for (int i = 0; i < TOTAL_COLS; i++) {
   
    setLED(i, col, color, on); 
    
  }
  
}

void setRow(int row, byte color, boolean on) {
 
  for (int i = 0; i < TOTAL_COLS; i++) {
   
    setLED(row, i, color, on);
  }
}

void clearDisplay() {
 
  for (int i = 0; i < BUFFER_SIZE; i++) {

    displayBuffer[i] &= ~(RED|GREEN|BLUE);    
  }
}

void setup() {
  
  Serial.begin(9600);
  
  pinMode(DATA_PIN, OUTPUT);
  pinMode(LATCH_PIN, OUTPUT);
  pinMode(CLOCK_PIN, OUTPUT);
  
  Timer1.initialize(TIMER_PERIOD);
  Timer1.attachInterrupt(drawBufferContents);
}


void sayHi(byte color) {
    
    clearDisplay();
    setCol(0, color, 1);
    setCol(1, color, 1);
    setCol(3, color, 1);
    setCol(4, color, 1);
    setCol(6, color, 1);
    setCol(7, color, 1);    
    setLED(3, 2, color, 1);  
    setLED(4, 2, color, 1);
}


void colorFill(int spd, int *colors) {
    
  int lastCol = TOTAL_COLS;
  
  for (int ci = 0; ci < TOTAL_COLS; ci++) {
    
    int currentColor = colors[ci];
    
    for (int row = 0; row < TOTAL_ROWS; row++) {
      
      for (int col = 0; col < lastCol; col++) {
     
        if (col != 0) {

          setLED(col - 1, row, currentColor, 0);
        }
        
        setLED(col, row, currentColor, 1);
        
        delay(spd);
      }      
    }

    if (lastCol != 0) {
      
      lastCol -= 1;
    }
    else {
     
      break; 
    }
  }  
}


void spiral(int spd, byte color) {

  const int UP = 0, RIGHT = 1, DOWN = 2, LEFT = 3;
  
  int row = 4, col = 3, currentDir = UP;
  
  int startLength = 4, maxLength = TOTAL_ROWS * TOTAL_COLS;
  
  for (int i = 1; i <= 7; i += 2) {

    int totalLength = i * startLength;
    
    int sideLength = (totalLength / 4);
    
    for (int j = 1; j <= totalLength; j++) {
          
      switch (currentDir) {
       
        case RIGHT:
          col++;
          break;
        
        case DOWN:
          row++;
          break;
          
        case LEFT:
          col--;
          break;
          
        case UP:
          row--;
          break;
          
        default:
          break;       
      }
      
      setLED(row, col, color, 1);    
      
      delay(spd);
      
      if (j % sideLength == 0) {

        if (currentDir != LEFT) {
          
          currentDir++;
        }
        else {
          
          col--; row++;
          currentDir = UP; 
        }
      }
    }
  }  
}


void blinkDisplay(int times, int spd) {
  
  uint8_t displayCopy[BUFFER_SIZE];
  
  for (int i = 0; i < BUFFER_SIZE; i++) {
   
    displayCopy[i] = displayBuffer[i]; 
    
  }
  
  int timesBlinked = 0;
  
  while (timesBlinked < times) {
   
    for (int i = 0; i < BUFFER_SIZE; i++) {
      
      displayBuffer[i] = 0;
    }
    
    delay(spd);
    
    for (int i = 0; i < BUFFER_SIZE; i++) {
      
      displayBuffer[i] = displayCopy[i]; 
    }
    
    delay(spd);
    
    timesBlinked++;
  }
}


void setRowPattern(int row, byte pattern, byte color) {
  
  byte colOn = B00000001;
  
  for (int c = (TOTAL_COLS - 1); c >= 0; c--) {
    
    uint8_t* rgb = getLED(row, c);
  
    if ((colOn & pattern) == colOn) {
      
      *rgb |= color;
    }
    
    colOn <<= 1; 
  }
}


void blinkSmile(int times, byte color, int spd) {
  
  int timesBlinked = 0;
  
  while (timesBlinked < times) {
    
    clearDisplay();
    smileOn(color);
    delay(spd);
    
    clearDisplay();
    smileOff(color);
    delay(spd);
    
    timesBlinked++;
  }
}

void smileOn(byte color) {
  
  setRowPattern(0, B00000000, color);
  setRowPattern(1, B01100110, color);
  setRowPattern(2, B01100110, color);
  setRowPattern(3, B00000000, color);
  setRowPattern(4, B00011000, color);
  setRowPattern(5, B10011001, color);
  setRowPattern(6, B01000010, color);
  setRowPattern(7, B00111100, color);
}


void smileOff(byte color) {
  
  setRowPattern(0, B00000000, color);
  setRowPattern(1, B00000000, color);
  setRowPattern(2, B01100110, color);
  setRowPattern(3, B00000000, color);
  setRowPattern(4, B00011000, color);
  setRowPattern(5, B10011001, color);
  setRowPattern(6, B01000010, color);
  setRowPattern(7, B00111100, color);
}


void checkerboard(byte color1, byte color2, int times, int spd) {
 
  int timesBlinked = 0;

  while (timesBlinked < times) {
  
    setRowPattern(0, B11001100, color1);
    setRowPattern(1, B11001100, color1);
    setRowPattern(0, B00110011, color2);
    setRowPattern(1, B00110011, color2);
    
    setRowPattern(2, B00110011, color1);
    setRowPattern(3, B00110011, color1);
    setRowPattern(2, B11001100, color2);
    setRowPattern(3, B11001100, color2);
  
    setRowPattern(4, B11001100, color1);
    setRowPattern(5, B11001100, color1);
    setRowPattern(4, B00110011, color2);
    setRowPattern(5, B00110011, color2);
  
    setRowPattern(6, B00110011, color1);
    setRowPattern(7, B00110011, color1);  
    setRowPattern(6, B11001100, color2);
    setRowPattern(7, B11001100, color2);
    
    delay(spd);

    byte tmp = color1;
    color1 = color2;
    color2 = tmp;
    
    clearDisplay();
    
    timesBlinked++;
  }
}

/* starboy's patterns */

// Utility Functions

byte randomColorByte() {
  return (byte) random(6) + 1;
}

void updateBuffer( byte (*f)(int, int) ) {
  
  for( int col = 0; col < TOTAL_COLS; col++) {
  
    for( int row = 0; row < TOTAL_ROWS; row++) {
  
      byte color = (*f)(col, row);
      
      if (color == OFF_BYTE) 
        setLED( col, row, RED|BLUE|GREEN, OFF );
      else
        setLED( col, row, color, ON );
       
    }
  }
}

// Old Style
void lightingEye(byte color) {
    
  for( int col = 0; col < TOTAL_COLS; col++) {
  
    for( int row = 0; row < TOTAL_ROWS; row++) {
      
      int x = col - 3;
      int y = row - 3;
      
      int x_distance = abs(x);
      int y_distance = abs(y);
      
      if ( random(8) > (x_distance + y_distance - 1) ) {
        setLED(row, col, color, ON);
      }
      
    }  
  }
}

// updateBuffer style
/*
 sets random colors
 */
byte randomColor(int col, int row) {
  return randomColorByte();
}



void theMatrix() {
    for( int col = 0; col < TOTAL_COLS; col++) {
  
      for( int row = 0; row < TOTAL_ROWS; row++) {
          
        // if it's the top row, random
          if ( row > 0) {
            
            byte above = (byte) getLED( row - 1, col );
         
            setLED(row, col, above, ON);
          
          } else {
          
            if (random(7) > 5)
              setLED(row, col, GREEN, OFF);
            else
              setLED(row, col, GREEN, ON);;
         
          }
        
        }
    }
}

void loop() {
  
//  for (int c = 0; c < 100; c++) {
//
//  updateBuffer(randomColor);  
//  delay(1);
//  clearDisplay();  
//  }
//  
  //setCol(7, RED, ON);
  
  //setCol(12, GREEN, ON);
  
  //
  //randomColor(RED,random(40,60));
  //lightingEye( RED );
  
  //delay(5);
  
  clearDisplay();

  setLED(0, 2, GREEN, ON);
  
  setLED(4, 2, BLUE, ON);
  
  setLED(4, 0, RED, ON);
  
  setLED(13, 0, RED|BLUE|GREEN, ON);
  
  setLED(14, 2, RED|GREEN, ON);
  
  delay(50);
  
  for(int i = 0; i < 100; i++) {
    theMatrix();
    delay(5);
  }
  
//
//  clearDisplay();
//  int colors[TOTAL_COLS] = {RED, RED|GREEN, GREEN, GREEN|BLUE, BLUE|RED, BLUE, RED|GREEN, RED, RED, RED|GREEN, GREEN, GREEN|BLUE, BLUE|RED, BLUE, RED|GREEN, RED};
//  colorFill(1, colors);
//  blinkDisplay(3, 30);
//  delay(50);
//  
//  clearDisplay();
//  checkerboard(RED, RED|GREEN|BLUE, 25, 100);
//  delay(5);
//
//  clearDisplay();
//  blinkSmile(10, BLUE|GREEN, 70);
//  delay(50);
  
} 
