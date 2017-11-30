`include "defines.v"

module output_m(  input wire `FLAG_T turn,
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

  // we want to update the display every time a turn ends
  always @( turn ) begin
    // man, I wish we could use ncurses
   $write("\n%c %c %c\n%c %c %c\n%c %c %c\n",
     char_table[board[0]], char_table[board[1]], char_table[board[2]], 
     char_table[board[3]], char_table[board[4]], char_table[board[5]], 
     char_table[board[6]], char_table[board[7]], char_table[board[8]]);

  end

endmodule
