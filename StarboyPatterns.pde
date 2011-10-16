void colorFill(int spd, int *colors) {
    
  int lastCol = TOTAL_COLS;
  
  for (int ci = 0; ci < 8; ci++) {
    
    int currentColor = colors[ci];
    
    for (int row = 0; row < TOTAL_ROWS; row++) {
      
      for (int col = 0; col < lastCol; col++) {
     
        if (col != 0) {

          setLED(row, col - 1, currentColor, 0);
        }
        
        setLED(row, col, currentColor, 1);
        
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