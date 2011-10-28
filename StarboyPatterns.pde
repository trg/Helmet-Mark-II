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
    
    for(int i = offset; i < MAX_Y + h; i+=h) {
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
    byte color = (byte)random(7)+1;
    
    setLED(x, y, WHITE, OFF);
    setLED(x, y, color, ON);    
     
  }
  
}

/*
* Blink a wall of a single random color
* Status: DONE
*/

void blinkRandomColors(int spd, int frames) {
  for( int f=0; f < frames; f++) {
    
    clearDisplay();
    
    delay(spd);
    
    byte c = getRandomColor();
    
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


void dualingSquares(byte color, int spd, int frames) {

  bool isOutside = true;
  
  for( int f=0; f < frames; f++) {
    
     clearDisplay();
     
     for( int x = 0; x < MAX_X; x++) {
       for( int y = 0; y < MAX_Y; y++) {
         if (isOutside) {
           
           //if( x < 2 || x > MAX_X -2) 
           
         } else {
       
         }    
    
       }
     }
     
     delay(spd);
    
  }
  
}
  
