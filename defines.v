`ifndef DEFINES_V
`define DEFINES_V

`define BOARD_ROWS    3
`define BOARD_COLS    3

// This is gonna have to be defined in every module that uses the clock.
// I'm sure there's a cleaner way to do it, but I can't think of one right now...
`define CLOCK_T       unsigned [0:0]
`define STATE_T       [1:0]
`define BOARD_T       [(`BOARD_ROWS * `BOARD_COLS - 1):0]

// is it a bitmask? Is it just counting? The world may never know!
// (this is set up for a 2 bit cell state variable)
`define CELL_BLANK    0
`define CELL_X        1
`define CELL_O        2
`define CELL_RSVD     3

`endif
