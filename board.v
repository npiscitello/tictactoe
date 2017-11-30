`include "defines.v"

// holds and manages board state (aka what's in every cell).
module board_m( output wire `FLAG_T refresh,
                input wire `INDEX_T update_loc,
                input wire `STATE_T update_val,
                input wire `FLAG_T submit,
                input wire `FLAG_T reset,
                output wire `BOARD_T `STATE_T board );

  reg `FLAG_T _refresh = 0;
  reg `BOARD_T `STATE_T _board;
  assign refresh = _refresh;
  assign board = _board;
  reg unsigned [(`BOARD_ROWS - 1):0] row;
  reg unsigned [(`BOARD_COLS - 1):0] col;

  // start with a blank board
  initial begin
    for( row = 0; row < `BOARD_ROWS; row = row + 1 ) begin
      for( col = 0; col < `BOARD_COLS; col = col + 1 ) begin
        _board[`BOARD_ROWS * row + col] = `CELL_BLANK;
      end
    end
  end

  always @( posedge submit ) begin

    // clear the board if asked
    if( reset ) begin
      _board = 0;
    end

    // validate index
    if( update_loc < `BOARD_ROWS * `BOARD_COLS ) begin
      // we only want to do anything if it's a valid move
      if( _board[update_loc] == `CELL_BLANK ) begin
        _board[update_loc] = update_val;
        #1 _refresh = ~refresh;
      end
    end


  end

endmodule
