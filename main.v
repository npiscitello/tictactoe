// uncomment below or pass -DDEBUG at compile time for verbose output
//`define DEBUG

`define BOARD_ROWS    3
`define BOARD_COLS    3

`define CLOCK_T       unsigned [0:0]
`define STATE_T       [1:0]
`define BOARD_T       [(`BOARD_ROWS * `BOARD_COLS - 1):0]

// is it a bitmask? Is it just counting? The world may never know!
`define CELL_BLANK   0
`define CELL_X       1
`define CELL_O       2

module main;

  reg `CLOCK_T clock = 0;

  // 3D arrays don't work well - I'll just suck it up and use a 2D array.
  reg `BOARD_T `STATE_T board;
  reg unsigned [(`BOARD_ROWS - 1):0] row;
  reg unsigned [(`BOARD_COLS - 1):0] col;

  output_m out(clock, board);

  initial begin
    for( row = 0; row < `BOARD_ROWS; row = row + 1 ) begin
      for( col = 0; col < `BOARD_COLS; col = col + 1 ) begin
        board[`BOARD_ROWS * row + col] = `CELL_BLANK;
      end
    end
  end

  always begin
`ifdef DEBUG
    $display("clock: %d", clock);
`endif
    #1 clock = ~clock;
  end

endmodule

module output_m(  input wire `CLOCK_T clock,
                  input wire `BOARD_T `STATE_T board );

  initial begin
    $display("\n(0,0), (0,1), (0,2); (1,0), (1,1), (1,2); (2,0), (2,1), (2,2)\n");
  end

  always @( negedge clock ) begin
    // man, I wish we could use ncurses
    // since we can't, we're limited to one line of output so we can overwrite it
    $write("%02d, %02d, %02d; %02d, %02d, %02d; %02d, %02d, %02d\015",
      board[0], board[1], board[2], 
      board[3], board[4], board[5],
      board[6], board[7], board[8]);
  end

endmodule
