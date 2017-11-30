`include "defines.v"
`include "board.v"
`include "output.v"
`include "player.v"
`include "ai.v"

module main;

  wire `FLAG_T turn_wire;
  // 3D arrays don't work well - I'll just suck it up and use a 2D array.
  wire `BOARD_T `STATE_T board_state_wire;
  wire `INDEX_T update_loc_wire;
  wire `FLAG_T submit_wire;
  wire `FLAG_T reset_wire;

  board_m board(turn_wire, update_loc_wire, submit_wire, reset_wire, board_state_wire);
  output_m out(turn_wire, board_state_wire);
  player_m player(turn_wire, update_loc_wire, submit_wire, reset_wire);
  ai_m ai(board_state_wire, turn_wire, update_loc_wire, submit_wire, reset_wire);

endmodule
