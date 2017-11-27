`include "defines.v"

// generates inputs for the board
module tester_m(  output wire `INDEX_T update_loc,
                  output wire `STATE_T update_val,
                  output wire `FLAG_T reset );
  reg `INDEX_T _update_loc;
  reg `STATE_T _update_val;
  reg `FLAG_T _reset;
  assign update_loc = _update_loc;
  assign update_val = _update_val;
  assign reset = _reset;

  initial begin
    #1 _update_loc = 0; _update_val = `CELL_O;

    #1 _update_loc = 0; _update_val = `CELL_X;

    #1 _update_loc = 8; _update_val = `CELL_X;
    #1 _update_loc = 9; _update_val = `CELL_X;

    $finish;
  end

endmodule
