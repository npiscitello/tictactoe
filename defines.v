`ifndef DEFINES_V
`define DEFINES_V

// uncomment below or pass -DDEBUG at compile time for verbose output
//`define DEBUG

// no variadic macros so we're stuck with static debug messages
`ifdef DEBUG
  `define DEBUG_LOG(A) $display(A)
`else
  `define DEBUG_LOG(A)
`endif

`define BOARD_ROWS    3
`define BOARD_COLS    3

`define STATE_T       [1:0]
`define BOARD_T       [(`BOARD_ROWS * `BOARD_COLS - 1):0]
`define FLAG_T        unsigned [0:0]
`define INDEX_T       unsigned [3:0]

// is it a bitmask? Is it just counting? The world may never know!
// (this is set up for a 2 bit cell state variable)
`define CELL_BLANK    0
`define CELL_X        1
`define CELL_O        2
`define CELL_RSVD     3

// these cannot change due to the ternaries in the assigns of the player and ai modules
// I wish I could use an explicit if statement, but that doesn't work outside of an always block
`define TURN_PLAYER   0
`define TURN_AI       1

`endif
