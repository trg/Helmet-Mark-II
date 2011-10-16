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


