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

  for(byte r1 = 0; r1 < MAX_X; r1++) {
    
    colROn = 0; colGOn = 0; colBOn = 0;
    
    for (byte c1 = 0; c1 < 8; c1++) {
        
        colROn |= *pixel & RED   ? _BV(c1) : 0;
        colGOn |= *pixel & GREEN ? _BV(c1) : 0;
        colBOn |= *pixel & BLUE  ? _BV(c1) : 0;

        *pixel++;
    }
    
    colROn2 = 0; colGOn2 = 0; colBOn2 = 0;
    
    //for (byte c2 = 8; c2 < MAX_Y; c2++) {
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
  return (row * MAX_Y) + col;
}

void setLED(int x, int y, byte color, boolean on) {
  
  if (x < 0 || x >= MAX_X) return;
  
  if (y < 0 || y >= MAX_Y) return;
  
  int rotated_x = y;
  int rotated_y = 7 - x;
  
  int new_x, new_y;
  
  if ( rotated_x < 8 ) {

    new_x = 15 - rotated_y;
    new_y = 7 - rotated_x;
    
  } else {

    new_x = 7 - rotated_y;
    new_y = 15 - rotated_x; 
  }
  
  int i = getDisplayBufferIndex(new_y, new_x);
  
  displayBuffer[i] = B00000000; // turn LED off before setting color;
  if (on) {
    //displayBuffer[i] = on ? (displayBuffer[i] | color) : (displayBuffer[i] & ~color);
    displayBuffer[i] = displayBuffer[i] | color;
  }
}

uint8_t* getLED(int row, int col) {
  
  return &displayBuffer[getDisplayBufferIndex(row, col)];
}

void copyLED(int srcX, int srcY, int destX, int destY) {
    int src = (srcX * MAX_Y) + srcY;
    int dest = (destX * MAX_Y) + destY;
    
    displayBuffer[dest] = displayBuffer[src];
}


void setRow(int row, byte color, boolean on) {
 
  for (int y = 0; y < MAX_Y; y++) {
   
    setLED(row, y, color, on);
    
  }
}

void setCol(int col, byte color, boolean on) {
 
  for (int x = 0; x < MAX_X; x++) {
   
    setLED(x, col, color, on);
    
  }
}

void setRowPattern(int row, byte pattern, byte color) {
  
  //row = (MAX_Y - 1) - row;
  
  byte colOn = B00000001;
  
  for (int c = (MAX_X - 1); c >= 0; c--) {
    
    uint8_t* rgb = getLED(row, c);
  
    if ((colOn & pattern) == colOn) {
      
      *rgb |= color;
    }
    
    colOn <<= 1; 
  }
}

void clearDisplay() {
 
  for (int i = 0; i < BUFFER_SIZE; i++) {

    displayBuffer[i] &= ~(RED|GREEN|BLUE);    
    
  }
}

void drawSquare(byte c, int x1, int y1, int x2, int y2) {
  
    if (y2 <= y1 || x2 <= x1) return;
  
    for( int x = x1; x <= x2; x++ ) {
      for (int y = y1; y <= y2; y++ ) {
        setLED(x,y,c,ON);
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

byte getRandomColor() {
  return COLORS[(int)random(0,7)];
}

