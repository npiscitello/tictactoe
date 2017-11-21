// This is gonna have to be defined in every module that uses the clock.
// I'm sure there's a cleaner way to do it, but I can't think of one right now...
`define CLOCK_T       unsigned [0:0]

module output_m(  input wire `CLOCK_T clock,
                  input wire `BOARD_T `STATE_T board );

  reg unsigned [2:0]_iterator = 0;

  // header text
  initial begin
    $display("\n(0,0), (0,1), (0,2); (1,0), (1,1), (1,2); (2,0), (2,1), (2,2)\n");
  end

  // Output on the negative edge because everything happens on positive edges.
  // This guarantees that the state will be settled when it's time to print.
  always @( negedge clock ) begin
    // man, I wish we could use ncurses
    // since we can't, we're limited to one line of output so we can overwrite it
    //$write("%02d, %02d, %02d; %02d, %02d, %02d; %02d, %02d, %02d\015",
    $write("%02d, %02d, %02d; %02d, %02d, %02d; %02d, %02d, %02d\n",
      board[0], board[1], board[2], 
      board[3], board[4], board[5],
      board[6], board[7], board[8]);

    // just a quick test loop, used in conjunction with the logic in board.v
    if( !(~_iterator) ) begin
      $write("\n");
      $finish;
    end
    _iterator = _iterator + 1;

  end

endmodule
