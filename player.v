`include "defines.v"

// generates inputs for the board
module player_m(  input wire `FLAG_T turn,
                  output wire `INDEX_T update_loc,
                  output wire `STATE_T update_val,
                  output wire `FLAG_T submit,
                  output wire `FLAG_T reset );
  reg `INDEX_T _update_loc;
  reg `STATE_T _update_val;
  reg `FLAG_T _submit;
  reg `FLAG_T _reset;
  // the player is the only module who needs to keep track of the turn number
  reg [2:0]_turn_counter = 0;
  // The regs are hooked up to the output wires by way of tri-state buffers, enabled when
  // it's the player's turn and disabled when it's the ai's turn.
  assign update_loc = turn ? 'bz : _update_loc;
  assign update_val = turn ? 'bz : _update_val;
  assign submit = turn ? 'bz : _submit;
  assign reset = turn ? 'bz : _reset;

  always @( turn ) begin
    if( turn == `TURN_PLAYER ) begin
`ifdef DEBUG
      $display("Player's turn, round %d", _turn_counter);
`endif
      case( _turn_counter )
        0: begin
          #2 _update_loc = 0; _update_val = `CELL_X; _submit = 1;
          #2 _submit = 0;
        end

        1: begin
          #2 _update_loc = 2; _update_val = `CELL_X; _submit = 1;
          #2 _submit = 0;
        end

        2: begin
          #2 _update_loc = 5; _update_val = `CELL_X; _submit = 1;
          #2 _submit = 0;
        end

        3: begin
          #2 _update_loc = 4; _update_val = `CELL_X; _submit = 1;
          #2 _submit = 0;
        end
      endcase

      _turn_counter = _turn_counter + 1;
    end
  end

endmodule
