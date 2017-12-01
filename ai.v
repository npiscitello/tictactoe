`include "defines.v"

// generates inputs for the board
module ai_m(  input wire `BOARD_T `STATE_T board_state,
              input wire `FLAG_T turn,
              output wire `INDEX_T update_loc,
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

      // Fair warning: a lot of the logic below could be more efficiently implemented with loops,
      // but verilog has no provision to break loops early!

      // the center is the most desirable cell - if it's open, take it!
      if( board_state[4] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] the center is miiiine!");
        `SUBMIT_MOVE(4);

      // Ok, so the center is taken. If it's ours, that's good!
      end else if( board_state[4] == `CELL_O ) begin
        // yay! we have the center! The player has 4 win opportunities. Are any of them ready?
        `DEBUG_LOG("[AI] the center is stil miiiiine!");
        // horizontal top
        if( board_state[0] == `CELL_X && board_state[1] == `CELL_X && board_state[2] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(2);
        end else if( board_state[0] == `CELL_X && board_state[1] == `CELL_BLANK && board_state[2] == `CELL_X ) begin
          `SUBMIT_MOVE(1);
        end else if( board_state[0] == `CELL_BLANK && board_state[1] == `CELL_X && board_state[2] == `CELL_X ) begin
          `SUBMIT_MOVE(0);

        // horizontal bottom
        end else if( board_state[6] == `CELL_X && board_state[7] == `CELL_X && board_state[8] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(8);
        end else if( board_state[6] == `CELL_X && board_state[7] == `CELL_BLANK && board_state[8] == `CELL_X ) begin
          `SUBMIT_MOVE(7);
        end else if( board_state[6] == `CELL_BLANK && board_state[7] == `CELL_X && board_state[8] == `CELL_X ) begin
          `SUBMIT_MOVE(6);

        // vertical left
        end else if( board_state[0] == `CELL_X && board_state[3] == `CELL_X && board_state[6] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(6);
        end else if( board_state[0] == `CELL_X && board_state[3] == `CELL_BLANK && board_state[6] == `CELL_X ) begin
          `SUBMIT_MOVE(3);
        end else if( board_state[0] == `CELL_BLANK && board_state[3] == `CELL_X && board_state[6] == `CELL_X ) begin
          `SUBMIT_MOVE(0);

        // vertical right
        end else if( board_state[2] == `CELL_X && board_state[5] == `CELL_X && board_state[8] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(8);
        end else if( board_state[2] == `CELL_X && board_state[5] == `CELL_BLANK && board_state[8] == `CELL_X ) begin
          `SUBMIT_MOVE(5);
        end else if( board_state[2] == `CELL_BLANK && board_state[5] == `CELL_X && board_state[8] == `CELL_X ) begin
          `SUBMIT_MOVE(2);
 
        // so the player can't win yet...can we? We have 4 win opportunities. And, we know we have the center.
        // horizontal middle
        end else if( board_state[3] == `CELL_O && board_state[5] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(5);
        end else if( board_state[3] == `CELL_BLANK && board_state[5] == `CELL_O ) begin
          `SUBMIT_MOVE(3);

        // vertical middle
        end else if( board_state[1] == `CELL_O && board_state[7] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(7);
        end else if( board_state[1] == `CELL_BLANK && board_state[7] == `CELL_O ) begin
          `SUBMIT_MOVE(1);

        // top left diagonal
        end else if( board_state[0] == `CELL_O && board_state[8] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(8);
        end else if( board_state[0] == `CELL_BLANK && board_state[8] == `CELL_O ) begin
          `SUBMIT_MOVE(0);

        // top right diagonal
        end else if( board_state[2] == `CELL_O && board_state[6] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(6);
        end else if( board_state[2] == `CELL_BLANK && board_state[6] == `CELL_O ) begin
          `SUBMIT_MOVE(2);

        // OK, so we can't win either. Just kind of...fill clockwise until something happens?
        end else if( board_state[0] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(0);
        end else if( board_state[1] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(1);
        end else if( board_state[2] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(2);
        end else if( board_state[5] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(5);
        end else if( board_state[8] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(8);
        end else if( board_state[7] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(7);
        end else if( board_state[6] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(6);
        end else if( board_state[3] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(3);
        end else begin
          `DEBUG_LOG("[AI] Somehow, I'm paralyzed in indecision...");
        end

      end else begin
        // uh oh, the player has the center
      end
    end
  end

endmodule
