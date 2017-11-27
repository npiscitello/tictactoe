`include "defines.v"

// holds and manages board state (aka what's in every cell).
module board_m( input wire `CLOCK_T clock,
                output wire `BOARD_T `STATE_T board );

  reg `BOARD_T `STATE_T _board;
  assign board = _board;
  reg unsigned [(`BOARD_ROWS - 1):0] row;
  reg unsigned [(`BOARD_COLS - 1):0] col;

  // we want to make sure the board is always in a valid state
  // this is probably overkill and may be dropped later
  always @( _board ) begin
    for( row = 0; row < `BOARD_ROWS; row = row + 1 ) begin
      for( col = 0; col < `BOARD_COLS; col = col + 1 ) begin
        if( _board[`BOARD_ROWS * row + col] == `CELL_RSVD )
          _board[`BOARD_ROWS * row + col] = `CELL_BLANK;
      end
    end
  end

  // start with a blank board
  initial begin
    for( row = 0; row < `BOARD_ROWS; row = row + 1 ) begin
      for( col = 0; col < `BOARD_COLS; col = col + 1 ) begin
        _board[`BOARD_ROWS * row + col] = `CELL_BLANK;
      end
    end
  end

  always @( posedge clock ) begin
    // increment every cell as a test
    _board[0] = _board[0] + 1;
    _board[1] = _board[1] + 1;
    _board[2] = _board[2] + 1;
    _board[3] = _board[3] + 1;
    _board[4] = _board[4] + 1;
    _board[5] = _board[5] + 1;
    _board[6] = _board[6] + 1;
    _board[7] = _board[7] + 1;
    _board[8] = _board[8] + 1;
  end

endmodule
