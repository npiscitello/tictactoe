`include "defines.v"

// holds and manages board state (aka what's in every cell).
module board_m( output wire `FLAG_T turn,
                input wire `INDEX_T update_loc,
                input wire `FLAG_T submit,
                input wire `FLAG_T reset,
                output wire `BOARD_T `STATE_T board );

  reg `FLAG_T _turn = `TURN_PLAYER;
  reg `BOARD_T `STATE_T _board;
  assign turn = _turn;
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

  // on falling edge so we know everything's reset before we continue
  always @( negedge submit ) begin

    // if triggered, clear the board and reset the game...
    if( reset ) begin
      `DEBUG_LOG("board reset");
      // This triggers the AI but ignores it's move b/c the board is being reset anyways. The
      // purpose of doing this is to provide a transition to the player's turn so as to trigger the
      // always block for the player again.
      _turn = `TURN_AI;
      _board = 0;
      _turn = `TURN_PLAYER;

    // ...or, if not, make the move
    end else if( update_loc < `BOARD_ROWS * `BOARD_COLS ) begin
      // we only want to do anything if it's a valid move
      if( _board[update_loc] == `CELL_BLANK ) begin
        `DEBUG_LOG("board update");
        _board[update_loc] = _turn ? `CELL_O : `CELL_X;
        _turn = ~turn;
      end
    end


  end

endmodule
