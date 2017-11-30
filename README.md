# Structure
The board state is stored in a 3x3x2 bit array: we need at least 3 bits (blank, X, O) for each cell.

# Operation
There is a 'turn' flag; when it's set, it's the AI's turn and when it's not, it's the player's turn.
The board update regs in both modules are hooked up to the wires through tri state buffers switched
on that turn flag. That's really all there is to it: each turn, the user (player or AI) has to set
the desired move location and toggle the 'submit' flag twice (one rising and one falling edge). We
do this double flip because the board module looks for the falling edge; this guarantees everything
has been set and is stable before we start interpreting the input. The turn is only flipped if a
valid move has been made. A reset moves it back to the player's turn.

# Hardware Port
This should port very nicely to hardware - it was designed to be asynchronous, triggered on the
submit flag. Basically, the user should be able to adjust toggle switches (or another input method)
to indicate his or her desired move and then press the submit button. If nothing happens, it was an
invalid move. The reset button will reset the board and return to the player's turn.
