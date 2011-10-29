void grid() {
  /*
  for( int y = 0; y < MAX_X; y++) {
    for( int x = 0; x < MAX_Y; x++) {
      setLED(x, y, RED, ON);
      //delay(50);
    }
  }
  */
  
  setLED(0,0, GREEN, ON);
  setLED(0,1, RED, ON);
  setLED(1,0, BLUE, ON);
  setLED(1,1, RED|BLUE|GREEN, ON);
  
  setLED(6, 15, GREEN, ON);
  setLED(7, 15, WHITE, ON);
  setLED(7, 14, WHITE, ON);
  
  
  /*
  setLED(0, 0, RED, ON);
  setLED(0, 7, GREEN, ON);
  setLED(7, 0, YELLOW, ON);
  setLED(7, 7, BLUE, ON);
  
  setLED(8, 0, BLUE, ON);
  setLED(8, 15, BLUE, ON);
  setLED(15, 0, BLUE, ON);
  setLED(15, 8, BLUE, ON);
  */
  /*
  for (int y = 0; y < MAX_Y; y++)
    for (int x = 0; x < MAX_X; x++)
      setLED(x, y, COLORS[(x+y)%6], ON);
      */
}

/*
* Green Matrix
* STATUS: Work in progress, requires refactoring helmet code
*/
void theMatrix(byte color, int spd) {
    
  // Move all lines down
  for (int y = MAX_X; y > 0; y--) {
    for (int x = MAX_Y; x > 0; x--) {
     
      copyLED(x, y-1, x, y);
      
    }
  }
  
  // Render top line
  for (int x = 0; x < MAX_Y; x++ ) {
    int chance = random(2);
    if (chance <= 1) {
      setLED(x, 0, color, ON);
    } else {
      setLED(x, 0, color, OFF);
    } 
  }
  
  delay(spd);
}

/*
  Snakes a dumb snake around the screen.
  STATUS: works but looks bad
*/
void snake(byte color, int spd, int length) {
  
  clearDisplay();
  
  int x = (int)random(0, MAX_Y);
  int y = (int)random(0, MAX_X);

  // 0 UP
  // 1 RIGHT
  // 2 DOWN
  // 3 UP

  int heading = (int) random(4);

  for(int frame = 0; frame < length; frame++) {
    
    int new_heading;
    
    do {
      new_heading = (int)random(4);
    }while(heading==new_heading);
    
    switch(new_heading) {
       
      case 0:
        y--;
        break;
      case 1:
        x++;
        break;
      case 2:
        y++;
        break;
      case 3:
        x--;
        break;
      
    }
    
    setLED(x, y, color, ON);
    
    delay(spd);
    
  }

}
  
  
/* 
* Makes a Cylon effect
* STATUS: Done
*/

void cylon(byte color, int spd, int frames) {

   int y = 0;
   bool goingRight = true;

   for(int frame = 0; frame < frames; frame++) {
     
      if (goingRight) {
        y++;
      } else {
        y--;
      }
      
      clearDisplay();
      
      for(int x = 0; x < MAX_X; x++) {
         setLED(x, y, color, ON);
      }
      
      delay(spd);
      
      if (y == MAX_Y - 1)
        goingRight = false;
  
      if (y == 0) 
        goingRight = true;
      
   }
  
}
  
  
/*
* NOISE - randomly turn on/off a color
* STATUS: Done
*/
void noise(byte color, int spd, int frames, int percentChance) {
  for(int f = 0; f < frames; f++) {
    for(int y = 0; y < MAX_Y; y++) {
        for(int x = 0; x < MAX_X; x++) {
           if(random(100) < percentChance) {
             setLED(x,y, color, ON);
           } else {
             setLED(x,y, color, OFF);
           }
        }
     }
     delay(spd);
   }
}

/*
* Display the word "TOM"
* work in progress, requires fixing setRowPattern for rows > 7
*/
void tom(byte color, int spd) {
  clearDisplay();
  
  setRowPattern(7,  B10101010, color); 
  setRowPattern(8,  B11100111, color);
  setRowPattern(9, B00011000, color); 
  
  delay(spd);
 
}

/* 
* Three rasta colors scrolling down
*/
void rasta(int spd, int frames) {
  for(int f = 0; f < frames; f++) {
    
    clearDisplay();
    
    int h = 4;
    
    int offset = (f % h) - h;
    
    for(int i = offset; i < MAX_X + h; i+=h) {
      setRow(i, RED, ON);
      setRow(i+1, YELLOW, ON);
      setRow(i+2, GREEN, ON);
    }
    delay(spd);
  }
}


/* 
* Random colors EVERYWHERE
*/
void totallyRandom(int frames) {
   
  for( int f = 0; f < frames; f++ ) {
    
    int x = random(MAX_X);
    int y = random(MAX_Y);
    
    byte color = getRandomColor();
    
    setLED(x, y, color, ON);    
     
  }
  
}

/*
* Blink a wall of a single random color
* Status: DONE
*/

void blinkRandomColors(int spd, int frames) {
  
  byte c = getRandomColor();
  
  for( int f=0; f < frames; f++) {
    
    clearDisplay();
    
    delay(spd);
    
    byte c1;
    do {
      c1 = getRandomColor();
    } while (c == c1);
 
    c = c1;
    
    for( int x = 0; x < MAX_X; x++) {
       for( int y = 0; y < MAX_Y; y++) {
         setLED(x,y,c,ON);
       }  
    }
    
    delay(spd);
  }
}

/*
* Blink a wall of a single random color
* Status: DONE
*/

void blinkColor(byte c, int spd, int frames) {
  for( int f=0; f < frames; f++) {
    
    clearDisplay();
    
    delay(spd);
    
    for( int x = 0; x < MAX_X; x++) {
       for( int y = 0; y < MAX_Y; y++) {
         setLED(x,y,c,ON);
       }  
    }
    
    delay(spd);
  }
}

/* Diagonal Rainbow Scroll
*
*/

void diagonalRainbowScroll(int spd, int frames) {
  
  int offset = 0;
  
  for( int f=0; f < frames; f++) {
    clearDisplay();
    for (int y = 0; y < MAX_Y; y++) {
      for (int x = 0; x < MAX_X; x++) {
        
        byte c = COLORS[(x+y + offset)%6];
        
        setLED(x, y, c , ON); 
      }  
    }
    
    offset++;
    delay(spd);    
  }
  
}

/* 
* box that goes in to the center
* STATUS: DONE
*/
void throughTheVoid(byte color, int spd, int times) {
  
  clearDisplay();
  
  for (int t = 0; t < times; t++) {
    
    for (int f = 0; f < 4; f++) {
      
      clearDisplay();
      
      switch(f) {
        
        case 0:
          setRow(0, color, ON);
          setRow(7, color, ON);
          setCol(0, color, ON);
          setCol(15, color, ON);
          break;
          
        case 1:
          setRow(1, color, ON);
          setRow(6, color, ON);
          setCol(1, color, ON);
          setCol(14, color, ON);
          
          setRow(0, color, OFF);
          setRow(7, color, OFF);
          setCol(0, color, OFF);
          setCol(15, color, OFF);
          break;
          
        case 2:
          setRow(2, color, ON);
          setRow(5, color, ON);
          setCol(2, color, ON);
          setCol(13, color, ON);
          
          setRow(0, color, OFF);
          setRow(7, color, OFF);
          setCol(0, color, OFF);
          setCol(15, color, OFF);
          setRow(1, color, OFF);
          setRow(6, color, OFF);
          setCol(1, color, OFF);
          setCol(14, color, OFF);
          break;
          
        case 3:
          setRow(3, color, ON);
          setRow(4, color, ON);
          setCol(3, color, ON);
          setCol(12, color, ON);
          
          setRow(0, color, OFF);
          setRow(7, color, OFF);
          setCol(0, color, OFF);
          setCol(15, color, OFF);
          setRow(1, color, OFF);
          setRow(6, color, OFF);
          setCol(1, color, OFF);
          setCol(14, color, OFF);
          setRow(2, color, OFF);
          setRow(5, color, OFF);
          setCol(2, color, OFF);
          setCol(13, color, OFF);
          break;
      }
      
      delay(spd);
      
    }
  }
}

void waveFromCenter(byte c, int spd, int frames) {
  
  for (int f = 0; f < frames; f++) {
    
    int topRow = 3 - (f % 4);
    int bottomRow = 4 + (f % 4);
    
    clearDisplay();
    setRow(topRow, c, ON);
    setRow(bottomRow, c, ON);
    
    delay(spd);
    
  }
  
}

void marchingColorLines(int spd, int frames) {
  
  byte lineArray[MAX_Y];
  
  for (int f = 0; f < frames; f++) {
    
    // shift array
    for(int i = MAX_Y-1; i > 0; i--) {
      lineArray[i] = lineArray[i-1];
    }
    
    if (f % 2 == 0)
      lineArray[0] = getRandomColor();
    else
      lineArray[0] = 0;
    
    clearDisplay();
    
    for(int i = 0; i < MAX_Y; i++) {
      byte c = lineArray[i];
      if (c > 0) {
        setCol(i, c, ON);
      }
    } 
    
    delay(spd);
    
  }
}

void drawSquares(int spd, int frames) {
  
  clearDisplay();
  
  for (int f = 0; f < frames; f++) {
   
    int x1 = random(0, MAX_X - 2);
    int y1 = random(0, MAX_Y - 2);
    
    int x2 = x1 + random(2, MAX_X - x1);
    int y2 = y1 + random(2, MAX_Y - y1);
    
    drawSquare(getRandomColor(), x1, y1, x2, y2);
    
    delay(spd);
  }
}

void blinkEyes(int spd, int frames) {
  
  for (int f = 0; f < frames; f++) {
   
    if(false && f % 2 == 0) {
      clearDisplay();
    } else {
      
      byte backgroundColor = getRandomColor();
      
      byte c = getRandomColor();
      while( c == backgroundColor ) {
        c = getRandomColor();
      }
      
      drawSquare(backgroundColor, 0, 0, MAX_X-1, MAX_Y-1);
      drawSquare(c, 2,2, 5,5);
      drawSquare(c, 2,10, 5,13);
      
    }
    
    delay(spd);
  }
  
}

void fallingRows( byte color, int spd ) {
  
  clearDisplay();
  
  for(int curr = MAX_X-1; curr >= 0; curr--) {
    for( int x = 0; x < curr; x++) {
      setRow(x, color, ON);
      setRow(x-1, color, OFF);
      delay(spd);
    }
  }
  
}

void mario() {
  
  clearDisplay(); 

  // sky
  setRow(0, CYAN, ON);
  setRow(1, CYAN, ON);
  setRow(2, CYAN, ON);
  setRow(3, CYAN, ON);
  setRow(4, CYAN, ON);
  setRow(5, CYAN, ON);
  setRow(6, CYAN, ON);
    
  //ground
  setRow(7, YELLOW, ON);
  
  // pipe
  drawSquare(GREEN, 2,1, 3,4);
  drawSquare(GREEN, 4,2, 6,3);
  
  // flower
  //setLED(1,2, RED, ON);
  //setLED(1,3, RED, ON);
  
  setLED(5,13, YELLOW, ON);
  
  setLED(4,13, YELLOW, ON);
  setLED(4,12, BLUE, ON);
  setLED(4,11, BLUE, ON);
  setLED(4,10, YELLOW, ON);
  
  setLED(3,12, BLUE, ON);
  setLED(3,11, BLUE, ON);
  setLED(3,10, YELLOW, ON);
  
  setLED(2,13, RED, ON);
  setLED(2,12, BLUE, ON);
  setLED(2,11, BLUE, ON);
  setLED(2,10, RED, ON);
  
  setLED(1,12, YELLOW, ON);
  setLED(1,11, YELLOW, ON);
  
  setLED(0,12, RED, ON);
  setLED(0,11, RED, ON);
  setLED(0,10, RED, ON);
  
  delay(1000);
  
}

void fillingBalls(byte color, int spd, int times) {
  
  clearDisplay();
  
  int ballsAtIndex[MAX_Y];
  for (int i = 0; i < MAX_Y; i++) {
    ballsAtIndex[i] = MAX_X - 1;
  }  
  for (int f = 0; f < (MAX_X - 1) * MAX_Y; f++) {
    
     int row = random(0, MAX_Y);
     
     while( ballsAtIndex[row] <= 0 ) {
       row = random(0, MAX_Y);
     }
     
     int heightAtRow = ballsAtIndex[row];
     
     ballsAtIndex[row]--;
     
     for (int h = 0; h < heightAtRow; h++) {
       setLED(h-1, row, color, OFF);
       setLED(h, row, color, ON);
       delay(spd);
     }
    
  }
  
}

void fallingRain(byte color, int spd, int times) {
  
  clearDisplay();
  
  for (int f = 0; f < times; f++) {
    
     int row = random(0, MAX_Y);
     
     // Fill col
     for (int h = 0; h < MAX_X; h++) {
       setLED(h, row, color, ON);
       delay(spd);
     }
     
     // Emtpy Col
     for (int h = 0; h < MAX_X; h++) {
       setLED(h, row, color, OFF);
       delay(spd);
     }
  }
  
}


void crazyRain(int spd, int times, byte colors[], int colorsLength) {
  
  clearDisplay();
  
  for (int f = 0; f < times; f++) {
    
     byte color = colors[f % colorsLength];
    
     int row = random(0, MAX_Y);
     
     int counter = 1;
     if (random(2) == 1)
       counter = -1;
     
     // Fill col
     for (int h = 0; h < MAX_X; h++) {
       setLED(h, (row + ((h * counter) % MAX_Y)), color, ON);
       delay(spd);
     }
     
     // Emtpy Col
     /*for (int h = 0; h < MAX_X; h++) {
       setLED(h, row, color, OFF);
       delay(spd);
     }*/
  }
  
}

void equalizer(byte c, int spd, int frames) {
  
  int heights[MAX_Y];
  
  for (int y = 0; y < MAX_Y; y++) {
    heights[y] = random(MAX_X);
  }
  
  clearDisplay();
  
  for (int f = 0; f < frames; f++) {
  
    for (int y = 0; y < MAX_Y; y++) {
      
      for (int x = (MAX_X - 1); x > heights[y]; x-- ) {
        setLED(x,y,c,ON);
      }
      for (int x = heights[y]; x >= 0; x--) {
        setLED(x,y,c,OFF);
      }
      
      heights[y] += random(-1,2);
      
      if( heights[y] > 8 ) heights[y]--;
      if( heights[y] < 0) heights[y]++;
      
    }    
  }
  
}



/*
void connectFour(byte c1, byte c2, int spd) {
   
   byte color = c1;
   
   byte displayBuffer[MAX_X][MAX_Y];
   
   for( int f = 0; f < MAX_X * MAX_Y; f++) {
     
     Serial.println("In frame: " + f);
     
     int xIndex = (int) random(MAX_Y);
     
     // get an xIndex where the 0th element is null
     while(displayBuffer[0][xIndex] == B0) {
       xIndex = (int) random(MAX_Y);
       Serial.println("Setting xIndex to" + xIndex);
     }
     
     // drop at col index
     displayBuffer[0][xIndex] = c1;
     
     int h = 0;
     
     while (displayBuffer[h+1][xIndex] == B0 && h+1 < MAX_X-1) { // move down if there exists space below
       displayBuffer[h][xIndex] = B0;
       displayBuffer[h+1][xIndex] = color;
       h++;
       
       // send to buffer
       clearDisplay();
       for(int x = 0; x < MAX_X; x++) {
         for(int y = 0; y < MAX_Y; y++) {
           setLED(x,y, displayBuffer[x][y], ON);
         }
       }
       
       delay(spd);
     }
     
     // switch colors
     if (color == c1) 
       color = c2;
     else
       color = c1;
     
   }
  
}
*/


