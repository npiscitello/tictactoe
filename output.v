// This is gonna have to be defined in every module that uses the clock.
// I'm sure there's a cleaner way to do it, but I can't think of one right now...
`define CLOCK_T       unsigned [0:0]

module output_m(  input wire `CLOCK_T clock,
                  input wire `BOARD_T `STATE_T board );

  reg unsigned [2:0]_iterator = 0;

  // lookup table for output characters
  reg unsigned [7:0]char_table [2:0];

  // header text
  initial begin
    char_table[0] = "_";
    char_table[1] = "X";
    char_table[2] = "O";
  end

  // Output on the negative edge because everything happens on positive edges.
  // This guarantees that the state will be settled when it's time to print.
  always @( negedge clock ) begin
    // man, I wish we could use ncurses
   $write("\n%c %c %c\n%c %c %c\n%c %c %c\n",
     char_table[board[0]], char_table[board[1]], char_table[board[2]], 
     char_table[board[3]], char_table[board[4]], char_table[board[5]], 
     char_table[board[6]], char_table[board[7]], char_table[board[8]]);

    // just a quick test loop, used in conjunction with the logic in board.v
    if( !(~_iterator) ) begin
      $write("\n");
      $finish;
    end
    _iterator = _iterator + 1;

  end

endmodule
