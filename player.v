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
      `DEBUG_LOG(">>> Player's turn <<<");
`ifdef DEBUG
      $display("[PLAYER] turn: %d", _turn_counter);
`endif

      case( _turn_counter )
        0: begin `SUBMIT_MOVE(4); end
        1: begin `SUBMIT_MOVE(3); end
        2: begin `SUBMIT_MOVE(6); end
        3: begin `SUBMIT_MOVE(8); end
        4: begin `SUBMIT_MOVE(1); end
      endcase

      _turn_counter = _turn_counter + 1;
    end
  end

endmodule
