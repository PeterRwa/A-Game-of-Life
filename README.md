# A Game of Life
Implementation of  A Game of Life for the BBC's Software Graduate Scheme application process.

This implimentation is written using Processing 2.1.1 can also be viewed here - https://www.openprocessing.org/sketch/660047.

 # Rules 
  1. A live cell with less than 2 neighbours dies.
  2. A live cell with more than 3 neighbours dies.
  3. A live cell with 2 or 3 neighbours lives.
  4. A dead cell with 3 neighbours becomes alive.
  
 # Assumptions
  1. The rules are applied to all cells at the same time, as opposed to cell by cell.
  
  2. A suitably large but finite grid of cells can adequatly replicate an infinite grid.
     The grid of cells is finite. A region of cells can be added which are not dispayed to the screen but act as normal cells.
     These cells help to imitate an infinite grid. Cells which are not displayed are called the buffer.  Increasing the buffer
     better replicates an infinite grid but slows the animation of cell evolution.
  
  3. The term neighbour refers to living cells only.
  
  4. The user has use of a mouse and keyboard.
  
  5. The user has Processing 2.2.1 or is able to view the code at OpenProcessing (see link below).
