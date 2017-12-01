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
      `DEBUG_LOG(">>> AI's turn <<<");

      // I'm sure there's a more elegant way to do this; there's a lot of duplication. But, it 
      // works, so until I figure out a better way to organize everything, this nausea-inducing
      // maze of if statements is how it's gonna be. I'm sorry. :(
      // One possibility that crossed my mind was for loops, but Verilog has no provision to break
      // loops early, so that kills any hope of doing that...
      // Is there possibly a way to leverage a case statement?

      // the center is the most desirable cell - if it's open, take it!
      if( board_state[4] == `CELL_BLANK ) begin
        `DEBUG_LOG("[AI] the center is miiiine!");
        `SUBMIT_MOVE(4);

      // Ok, so the center is taken. If it's ours, that's good!
      end else if( board_state[4] == `CELL_O ) begin
        `DEBUG_LOG("[AI] the center is stil miiiiine!");

        // Can we win? We have 4 opportunities. And, we know we have the center.
        // (actually, we could win anywhere, but it's unlikely. I might add that in later.)
        // horizontal middle
        if( board_state[3] == `CELL_O && board_state[5] == `CELL_BLANK ) begin
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

        // We can't win... can the player? They have 4 opportunities. Are any of them ready?
        // horizontal top
        end if( board_state[0] == `CELL_X && board_state[1] == `CELL_X && board_state[2] == `CELL_BLANK ) begin
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

        // OK, so they can't win either. Just kind of...fill clockwise until something happens?
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
        // note, this whole section is basically the logic above inverted (WRT cell contents)
        `DEBUG_LOG("[AI] You took the center? You'll pay for that!");

        // Can we win? We have the same 4 possibilities we just checked...
        // horiontal top
        if( board_state[0] == `CELL_O && board_state[1] == `CELL_O && board_state[2] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(2);
        end else if( board_state[0] == `CELL_O && board_state[1] == `CELL_BLANK && board_state[2] == `CELL_O ) begin
          `SUBMIT_MOVE(1);
        end else if( board_state[0] == `CELL_BLANK && board_state[1] == `CELL_O && board_state[2] == `CELL_O ) begin
          `SUBMIT_MOVE(0);

        // horizontal bottom
        end else if( board_state[6] == `CELL_O && board_state[7] == `CELL_O && board_state[8] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(8);
        end else if( board_state[6] == `CELL_O && board_state[7] == `CELL_BLANK && board_state[8] == `CELL_O ) begin
          `SUBMIT_MOVE(7);
        end else if( board_state[6] == `CELL_BLANK && board_state[7] == `CELL_O && board_state[8] == `CELL_O ) begin
          `SUBMIT_MOVE(6);

        // vertical left
        end else if( board_state[0] == `CELL_O && board_state[3] == `CELL_O && board_state[6] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(6);
        end else if( board_state[0] == `CELL_O && board_state[3] == `CELL_BLANK && board_state[6] == `CELL_O ) begin
          `SUBMIT_MOVE(3);
        end else if( board_state[0] == `CELL_BLANK && board_state[3] == `CELL_O && board_state[6] == `CELL_O ) begin
          `SUBMIT_MOVE(0);

        // vertical right
        end else if( board_state[2] == `CELL_O && board_state[5] == `CELL_O && board_state[8] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(8);
        end else if( board_state[2] == `CELL_O && board_state[5] == `CELL_BLANK && board_state[8] == `CELL_O ) begin
          `SUBMIT_MOVE(5);
        end else if( board_state[2] == `CELL_BLANK && board_state[5] == `CELL_O && board_state[8] == `CELL_O ) begin
          `SUBMIT_MOVE(2);

        // Darn, we can't win. Can the player? They have 4 main opportunities. Are any of them ready?
        // horizontal middle
        end else if( board_state[3] == `CELL_X && board_state[5] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(5);
        end else if( board_state[3] == `CELL_BLANK && board_state[5] == `CELL_X ) begin
          `SUBMIT_MOVE(3);

        // vertical middle
        end else if( board_state[1] == `CELL_X && board_state[7] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(7);
        end else if( board_state[1] == `CELL_BLANK && board_state[7] == `CELL_X ) begin
          `SUBMIT_MOVE(1);

        // top left diagonal
        end else if( board_state[0] == `CELL_X && board_state[8] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(8);
        end else if( board_state[0] == `CELL_BLANK && board_state[8] == `CELL_X ) begin
          `SUBMIT_MOVE(0);

        // top right diagonal
        end else if( board_state[2] == `CELL_X && board_state[6] == `CELL_BLANK ) begin
          `SUBMIT_MOVE(6);
        end else if( board_state[2] == `CELL_BLANK && board_state[6] == `CELL_X ) begin
          `SUBMIT_MOVE(2);

        // OK, so the player isn't going for any expected wins. Are they not using the center?
        // horiontal top
        end if( board_state[0] == `CELL_X && board_state[1] == `CELL_X && board_state[2] == `CELL_BLANK ) begin
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

        // OK, so they can't win either. Just kind of...fill clockwise until something happens?
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
      end
    end
  end

endmodule
