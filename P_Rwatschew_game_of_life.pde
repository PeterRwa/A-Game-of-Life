/*
  Peter Rwatschew
  2019 - BBC Software Graduate Scheme Application
  Implimentation of A Game of Life
  
  Rules 
  1. A live cell with less than 2 neighbours dies.
  2. A live cell with more than 3 neighbours dies.
  3. A live cell with 2 or 3 neighbours lives.
  4. A dead cell with 3 neighbours becomes alive.
  
  Assumptions
  1. The rules are applied to all cells at the same time, as opposed to cell by cell.
  
  2. A suitably large but finite grid of cells can adequatly replicate an infinite grid.
     The grid of cells is finite. A region of cells can be added which are not dispayed to the screen but act as normal cells.
     These cells help to imitate an infinite grid. Cells which are not displayed are called the buffer.  Increasing the buffer
     better replicates an infinite grid but slows the animation of cell evolution.
  
  3. The term neighbour refers to living cells only.
  
  4. The user has use of a mouse and keyboard.
  
  5. The user has Processing 2.2.1 or is able to view the code at OpenProcessing (see link below).
  
  Usage
    User Controls
    1. Enter - start/stop animation of cells.
    2. Delete (when animation stopped) - clears the cells.
    3. Leftmouse click/drag (when animation stopped) - switches the state of cell/s.
    4. Tab (when animation stopped) - show/hide user controls 
      
    Functions
      void Setup() - Called once to set initial conditions.
      void Draw() - Called for every frame, even when animation of cells is stopped
      void KeyPressed() - Called whenever there is a keyboard event. Handels user keyboard controls
      void mouseClicked() & mouseDragged() - Called by their specific mouse events. Handles user mouse controls.
      void drawCells() - Draws a square, of size cellSize, for each cell. The outline of the squares produces the "grid".
                         Alive cells are coloured black (fill(0)). Dead cells are coloured white (fill(255))
      void refresh() - Sets all cells to dead.
      int neighbours(int i, int j) - Returns the number of living cells directly next to cell with index i, j.
      void updateCells() - Applies rules to current state of cells. Overwrites current state with evolved state. 

  Available
  Github - https://github.com/PeterRwa/A-Game-of-Life
  OpenProcessing - https://www.openprocessing.org/user/150995#sketches
*/

// Global Variables
boolean run = false;
boolean show = true;
int[][] cells;
int[][] nextCells;
int cellSize = 15;

String info = "A Game of Life\nUser Controls\n  1. Enter - start/stop animation of cells.\n  2. Delete (when animation stopped) - clears the cells.\n  3. Left mouse click/drag (when animation stopped) - switches the state of cell/s.\n  4. Tab (when animation stopped) - show/hide user controls";

// Dimention of screen (in terms of cells)
// col = width row = height
int col = 75;
int row = 40;
// Number of rows/cols in buffer
int buffer = 3;

void setup()  {
  // Inital settings
  size(col * cellSize, row * cellSize);
  background(255);
  stroke(0);
  frameRate(6);
  
  // Corrects for cells in buffer 
  translate(-buffer * cellSize, -buffer * cellSize);
  
  // Initialise arrays for cell states
  cells = new int[col + buffer][row + buffer];
  nextCells = new int[col + buffer][row + buffer];
 
  // Set cells to dead
  refresh(cells);
  refresh(nextCells);

}


void draw()  {
  // Corrects for cells in buffer 
  translate(-buffer * cellSize, -buffer * cellSize);
  
  // Draw cells to screen
  drawCells();
  
  // Display user instructions
  if (run == false && show == true)  {
    fill(255);
    rect(width/2 - 280, height/2 - 60, 640, 170);
    fill(0);
    textSize(15);
    text(info, width/2 - 250, height/2 - 40);
  }
  
  // Logic to start/stop animation
  if (run == true)  {
    // Apply rules to cells
    updateCells();
  }
}


void keyPressed()  {
  // Enter key switches value of run between true/false i.e start/stop
  if (key == ENTER)  {
    run = (run) ? false : true;    
  }
  
  // Pressing delete refreshes (kills all cells) when stoped
  if (key == DELETE && run == false)  {
    refresh(cells);
    refresh(nextCells);
  }  
  
  // Show/hide user controls
  if (key == TAB && run == false)  {
    show = (show) ? false : true;
  }  
}

// User can set-up initial state using mouse clicks
void mouseClicked()  {
  if (run == false)  {
    // Convert mouse co-ords to cell position
    int i = floor((mouseX + buffer * cellSize)/ cellSize);
    int j = floor((mouseY + buffer * cellSize)/ cellSize);
    // Switches cells between dead and alive (white and black)
    cells[i][j] = (cells[i][j] == 0) ? 255 : 0;
  } 
}

// User can set-up initial state using mouse
int currentX = 0, currentY = 0;
int nextX, nextY;
void mouseDragged()  {
  // Convert mouse co-ords to cell position
  nextX = floor((mouseX + buffer * cellSize)/ cellSize);
  nextY = floor((mouseY + buffer * cellSize)/ cellSize);
  
  // Check if mouse moved to new cell
  if (nextX != currentX || nextY != currentY)  {
    cells[nextX][nextY] = (cells[nextX][nextY] == 0) ? 255 : 0;
    currentX = nextX;
    currentY = nextY;
  }
}

// Draws all cells based on state i.e dead/alive (white/black)
void drawCells()  {
  for (int i = 0; i < cells.length; i++)  {
    for (int j = 0; j < cells[0].length; j++)  {
      fill(cells[i][j]);
      rect(i * cellSize, j * cellSize, cellSize, cellSize);
    }    
  }
}

// Kills all cells i.e. set to 255/white
void refresh(int[][] c)  {
  for(int i = 0; i < c.length; i++)  {
    for(int j = 0; j < c[0].length; j++)  {
      c[i][j] = 255;
    }
  }
}

// Calculates number of live neighbours for a given cell 
int neighbours(int i, int j)  {
  // Number of neighbours
  int n = 0;
  // Horizontal and vertical range
  int Hleft = -1, Hright = 1;
  int Vup = -1,   Vdown = 1;
  
  // Handels edge/corner cases
  if (i == 0)                    {Hleft = 0;}
  if (i == cells.length - 1)     {Hright = 0;}
  if (j == 0)                    {Vup = 0;}
  if (j == cells[0].length - 1)  {Vdown = 0;}
  
  // Counts live cells in valid range of given cell
  for (int h = Hleft; h <= Hright; h++)  {
    for (int v = Vup; v <= Vdown; v++)  {
      if (cells[i + h][j + v] == 0)  {n++;}
    }
  }
  
  // Corrects for counting given cell
  if (cells[i][j] == 0)  {n--;}
  
  return n;
}

// Applies living/dying logic to all cells
// Uses nextCells[][] for temp storage
// Calls neighbours(i, j)
void updateCells()  {
  for(int j = 0; j < cells[0].length; j++)  {
    for (int i = 0; i < cells.length; i++)  {      
      // Total living neighbours
      int n = neighbours(i,j);
      
      // Living/dying rules based on neighbours (n) and cell state (alive/dead 0/255)
      if (cells[i][j] == 0 && n < 2)  {
        nextCells[i][j] = 255;
      }
      else if (cells[i][j] == 0 && n > 3)  {
        nextCells[i][j] = 255;
      }
      else if (cells[i][j] == 0 && (n == 3 || n == 2))  {
        nextCells[i][j] = 0;
      }
      else if (cells[i][j] == 255 && n == 3)  {
        nextCells[i][j] = 0;
      }
    }
  }
  
  // Copies nextCells values to current cells values
  for(int j = 0; j < cells[0].length; j++)  {
    for (int i = 0; i < cells.length; i++)  {
      cells[i][j] = nextCells[i][j];
    }
  }
}
