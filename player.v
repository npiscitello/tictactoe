`include "defines.v"

// generates inputs for the board
module player_m(  input wire `FLAG_T turn,
                  output wire `INDEX_T update_loc,
                  output wire `FLAG_T submit,
                  output wire `FLAG_T reset );

  reg `INDEX_T _update_loc;
  reg `FLAG_T _submit;
  reg `FLAG_T _reset;

  // The regs are hooked up to the output wires by way of tri-state buffers, enabled when
  // it's the player's turn and disabled when it's the ai's turn.
  assign update_loc = turn ? 'bz : _update_loc;
  assign submit = turn ? 'bz : _submit;
  assign reset = turn ? 'bz : _reset;

  // the player is the only module who needs to keep track of the turn number
  reg [3:0]_turn_counter = 0;

  always @( turn ) begin
    if( turn == `TURN_PLAYER ) begin
`ifdef DEBUG
      $display("turn %d", _turn_counter);
`endif
      `DEBUG_LOG("Player's turn");

      case( _turn_counter )
        0: begin
          //#1 _update_loc = 0; _submit = 1;
          #1 _update_loc = 2; _submit = 1;
          #1 _submit = 0;
        end

        1: begin
          //#1 _update_loc = 2; _submit = 1;
          #1 _update_loc = 4; _submit = 1;
          #1 _submit = 0;
        end

        2: begin
          //#1 _update_loc = 5; _submit = 1;
          #1 _update_loc = 6; _submit = 1;
          #1 _submit = 0;
        end

        3: begin
          #1 _update_loc = 7; _submit = 1;
          #1 _submit = 0;
        end

        4: begin
          #1 _reset = 1; _submit = 1;
          #1 _submit = 0;
        end

        5: begin
          #1 _reset = 0; _update_loc = 8; _submit = 1;
          #1 _submit = 0;
        end
      endcase

      _turn_counter = _turn_counter + 1;
    end
  end

endmodule
