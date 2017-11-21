`include "board.v"
`include "output.v"

// uncomment below or pass -DDEBUG at compile time for verbose output
//`define DEBUG

// This is gonna have to be defined in every module that uses the clock.
// I'm sure there's a cleaner way to do it, but I can't think of one right now...
`define CLOCK_T       unsigned [0:0]

module main;

  reg `CLOCK_T clock = 0;

  // 3D arrays don't work well - I'll just suck it up and use a 2D array.
  wire `BOARD_T `STATE_T board_wire;

  board_m board(clock, board_wire);
  output_m out(clock, board_wire);


  // tick, tock, tick, tock...
  always begin
`ifdef DEBUG
    $display("clock: %d", clock);
`endif
    #1 clock = ~clock;
  end

endmodule
