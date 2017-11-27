`include "defines.v"

module output_m(  input wire `CLOCK_T clock,
                  input wire `BOARD_T `STATE_T board );

  // lookup table for output characters
  reg unsigned [7:0]char_table [3:0];

  // initialize the character table
  initial begin
    char_table[`CELL_BLANK] = "_";
    char_table[`CELL_X] = "X";
    char_table[`CELL_O] = "O";
    char_table[`CELL_RSVD] = "?";
  end

  // Output on the negative edge because everything happens on positive edges.
  // This guarantees that the state will be settled when it's time to print.
  always @( negedge clock ) begin
    // man, I wish we could use ncurses
   $write("\n%c %c %c\n%c %c %c\n%c %c %c\n",
     char_table[board[0]], char_table[board[1]], char_table[board[2]], 
     char_table[board[3]], char_table[board[4]], char_table[board[5]], 
     char_table[board[6]], char_table[board[7]], char_table[board[8]]);

  end

endmodule
