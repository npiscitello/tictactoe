`include "defines.v"

// holds and manages board state (aka what's in every cell).
module board_m( input wire `CLOCK_T clock,
                input wire `INDEX_T update_loc,
                input wire `STATE_T update_val,
                input wire `FLAG_T reset,
                output wire `BOARD_T `STATE_T board );

  reg `BOARD_T `STATE_T _board;
  assign board = _board;
  reg unsigned [(`BOARD_ROWS - 1):0] row;
  reg unsigned [(`BOARD_COLS - 1):0] col;

  // we want to make sure the board is always in a valid state
  // this is probably overkill and may be dropped later
  // we can't modify _board in 2 different always blocks!
  /*
  always @( _board ) begin
    for( row = 0; row < `BOARD_ROWS; row = row + 1 ) begin
      for( col = 0; col < `BOARD_COLS; col = col + 1 ) begin
        if( _board[`BOARD_ROWS * row + col] == `CELL_RSVD )
          _board[`BOARD_ROWS * row + col] = `CELL_BLANK;
      end
    end
  end
  */

  // start with a blank board
  initial begin
    for( row = 0; row < `BOARD_ROWS; row = row + 1 ) begin
      for( col = 0; col < `BOARD_COLS; col = col + 1 ) begin
        _board[`BOARD_ROWS * row + col] = `CELL_BLANK;
      end
    end
  end

  always @( posedge clock ) begin

    // clear the board if asked
    if( reset ) begin
      _board = 0;
    end

    // validate index
    if( update_loc < `BOARD_ROWS * `BOARD_COLS ) begin
      // we only want to update the location if it's blank
      if( _board[update_loc] == `CELL_BLANK ) begin
        _board[update_loc] = update_val;
      end
    end

  end

endmodule
