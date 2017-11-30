`include "defines.v"

// generates inputs for the board
module ai_m(  input wire `BOARD_T `STATE_T board_state,
              input wire `FLAG_T turn,
              output wire `INDEX_T update_loc,
              output wire `STATE_T update_val,
              output wire `FLAG_T submit,
              output wire `FLAG_T reset );

  reg `INDEX_T _update_loc;
  reg `STATE_T _update_val;
  reg `FLAG_T _submit;
  reg `FLAG_T _reset;

  // The regs are hooked up to the output wires by way of tri-state buffers, enabled when
  // it's the ai's turn and disabled when it's the player's turn.
  assign update_loc = turn ? _update_loc : 'bz;
  assign update_val = turn ? _update_val : 'bz;
  assign submit = turn ? _submit : 'bz;
  assign reset = turn ? _reset : 'bz;

  // the ai determines its move via board state so it doesn't need to keep track of turn number
  always @( turn ) begin
    if( turn == `TURN_AI ) begin
      `DEBUG_LOG("AI's turn");

      if( board_state[0] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 0");
        #2 _update_loc = 0; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;

      end else if( board_state[1] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 1");
        #2 _update_loc = 1; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;

      end else if( board_state[2] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 2");
        #2 _update_loc = 2; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;

      end else if( board_state[3] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 3");
        #2 _update_loc = 3; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;

      end else if( board_state[4] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 4");
        #2 _update_loc = 4; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;

      end else if( board_state[5] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 5");
        #2 _update_loc = 5; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;

      end else if( board_state[6] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 6");
        #2 _update_loc = 6; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;

      end else if( board_state[7] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 7");
        #2 _update_loc = 7; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;

      end else if( board_state[8] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] writing to position 8");
        #2 _update_loc = 8; _update_val = `CELL_O; _submit = 1;
        #2 _submit = 0;
      end
    end
  end

endmodule
