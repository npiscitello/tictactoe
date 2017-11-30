`include "defines.v"
`include "board.v"
`include "output.v"
`include "tester.v"

// uncomment below or pass -DDEBUG at compile time for verbose output
//`define DEBUG

module main;

  wire `FLAG_T refresh_wire;
  // 3D arrays don't work well - I'll just suck it up and use a 2D array.
  wire `BOARD_T `STATE_T board_state_wire;
  wire `INDEX_T update_loc_wire;
  wire `STATE_T update_val_wire;
  wire `FLAG_T submit_wire;
  wire `FLAG_T reset_wire;

  board_m board(refresh_wire, update_loc_wire, update_val_wire, submit_wire, reset_wire, board_state_wire);
  output_m out(refresh_wire, board_state_wire);
  tester_m tester(update_loc_wire, update_val_wire, submit_wire, reset_wire);

endmodule
