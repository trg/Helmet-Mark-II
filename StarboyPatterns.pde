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
}

/*
* Green Matrix
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
*/

void cylon(byte color, int spd, int frames) {

   int x = 0;
   bool goingRight = true;

   for(int frame = 0; frame < frames; frame++) {
      
     Serial.print(x);
     
      if (goingRight) {
        x++;
      } else {
        x--;
      }
      
      clearDisplay();
      
      for(int y = 0; y < MAX_Y; y++) {
         setLED(x, y, color, ON);
      }
      
      delay(spd);
      
      if (x == MAX_X - 1)
        goingRight = false;
  
      if (x == 0) 
        goingRight = true;
      
   }
  
}
  
  
/*
* NOISE
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
  
  
  
  
  
  
  
  
  
  
