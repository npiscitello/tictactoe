`define STATE_T     unsigned [1:0]
`define BOARD_ROWS  3
`define BOARD_COLS  3
`define ROW_T [(`BOARD_ROWS-1):0]
`define COL_T [(`BOARD_COLS-1):0]

// cell states
`define STATE_BLANK 0
`define STATE_X     1
`define STATE_O     2

module main;
  // board[row][column] = cell state
  reg `STATE_T board `ROW_T `COL_T;
  reg unsigned `ROW_T row;
  reg unsigned `COL_T col;

  initial begin
    // start with a blank board
    for( row = 0; row < `BOARD_ROWS; row = row + 1 ) begin
      for( col = 0; col < `BOARD_COLS; col = col + 1 ) begin
        board[row][col] = `STATE_BLANK;
      end
    end
  end
endmodule
