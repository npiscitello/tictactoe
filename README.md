# Structure
The board state is stored in a 3x3x2 bit array: we need at least 3 bits (blank, X, O) for each cell.
I tried to follow object oriented design principles as closely as possible here, specifically
encapsulation. Each module ('class' of sorts) fulfills a very specific function; see the code for
a lower level description:

* __main__ *routes signals between modules* - If this code were synchronous, it would also provide
  the system clock, but its asynchronous design obviates that feature.
* __board__ *manages board state* - Canonical values: `turn`, `board_state`. This module is the one
  that acutally handles turns. When each player clocks the submit line, this module interprets the 
  data on the update location and reset lines and combines that with the turn state and board state
  to decide what's happening on the board.

# Operation
There is a 'turn' flag; when it's set, it's the AI's turn and when it's not, it's the player's turn.
The board update regs in both modules are hooked up to the wires through tri state buffers switched
on that turn flag. That's really all there is to it: each turn, the user (player or AI) has to set
the desired move location and clock the 'submit' flag once (one rising and one falling edge). We do
this double flip because the board module looks for the falling edge; this guarantees everything
has been set and is stable before we start interpreting the input. It also eliminates
synchronization problems: by ensuring the submit flag in each module is set to zero at the end of
each turn, we don't have to pass state pertaining to it between the modules. I decided that time is
cheap and hardware (connecting wires, input/output definitions, and synchromization logic - thread 
safety, if you will) is expensive in this case. The turn is only flipped if a valid move has been
made. A reset moves it back to the player's turn.

# Extensibility
The logic in this game is very specific to a 3x3, 2 player tic tac toe game. The biggest hallmark of
this is the obscene network of conditionals in the AI and board modules to check the board status
for a pending or existing win. To generalize, we could implement some kind of pattern matching
algorithm to scan the board instead of checking individual cells, but that is both beyond the scope
of the assignment and, frankly, beyond the scope of the language in general (or, at least, with our
current familiarity with it).

# Hardware Port
This should port very nicely to hardware - it was designed to be asynchronous, triggered on the
submit flag. Basically, the user should be able to adjust toggle switches (or another input method)
to indicate his or her desired move and then press the submit button. If nothing happens, it was an
invalid move. The reset button will reset the board and return to the player's turn.
