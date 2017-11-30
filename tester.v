`include "defines.v"

// generates inputs for the board
module tester_m(  output wire `INDEX_T update_loc,
                  output wire `STATE_T update_val,
                  output wire `FLAG_T submit,
                  output wire `FLAG_T reset );
  reg `INDEX_T _update_loc;
  reg `STATE_T _update_val;
  reg `FLAG_T _submit;
  reg `FLAG_T _reset;
  assign update_loc = _update_loc;
  assign update_val = _update_val;
  assign submit = _submit;
  assign reset = _reset;

  initial begin
    #1 _update_loc = 0; _update_val = `CELL_O; _submit = 1;
    #1 _submit = 0;

    #1 _update_loc = 0; _update_val = `CELL_X; _submit = 1;
    #1 _submit = 0;

    #1 _update_loc = 8; _update_val = `CELL_X; _submit = 1;
    #5 _submit = 0;

    #1 _update_loc = 4; _update_val = `CELL_X; _submit = 1;
    #1 _submit = 0;

    $finish;
  end

endmodule
